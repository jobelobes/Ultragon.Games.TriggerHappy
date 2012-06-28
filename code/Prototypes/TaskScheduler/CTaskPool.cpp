#include "stdhdr.h"

using namespace Singularity;

namespace Singularity
{
	namespace Tasks
	{
		#pragma region Static Variables
		DWORD CTaskPool::g_iTLSindex = TLS_OUT_OF_INDEXES;
		#pragma endregion

		#pragma region Constructors and Finalizers
		CTaskPool::CTaskPool()
			: m_iThreadCount(0), m_pThreads(NULL), m_iState(TASKPOOL_STATE_UNINITIALIZED)
		{
			// null out the task & reference array
			ZeroMemory(this->m_pTasks, sizeof(CTask*) * SINGULARITY_TASKS_MAX_TASKS);
			ZeroMemory(this->m_pLinks, sizeof(unsigned) * SINGULARITY_TASKS_MAX_TASKS);

			::InitializeCriticalSection(&this->m_pLock);
		}

		CTaskPool::~CTaskPool()
		{
			// release the TLS and set the index to invalid value
			if(CTaskPool::g_iTLSindex != TLS_OUT_OF_INDEXES)
			{
				TlsFree(CTaskPool::g_iTLSindex); 
				CTaskPool::g_iTLSindex = TLS_OUT_OF_INDEXES;
			}

			::DeleteCriticalSection(&this->m_pLock);
		}
		#pragma endregion

		#pragma region Methods
		void CTaskPool::Initialize(int options)
		{
			if(this->m_iState != TASKPOOL_STATE_UNINITIALIZED)
				throw SingularityException("TaskPool is already initialized!");

			// initialize Thread Local Storage
			// TLS allows us to have a unified heap across all of the threads
			CTaskPool::g_iTLSindex = ::TlsAlloc();
			if (TLS_OUT_OF_INDEXES == CTaskPool::g_iTLSindex)
				throw SingularityException("Unable to allocate local storage.");

			// create the worker threads for the tasking
			// determine the correct thread limit for the process
			this->m_iThreadCount = CTaskPool::GetHardwareThreadsCount();
			if (this->m_iThreadCount > SINGULARITY_TASKS_MAX_THREADS)
				this->m_iThreadCount = SINGULARITY_TASKS_MAX_THREADS;
			this->m_pThreads = new CWorkerThread[this->m_iThreadCount];

			// update the pool's state
			this->m_iState = TASKPOOL_STATE_INITIALIZED;

			::EnterCriticalSection(&this->m_pLock);
			{
				// null out the task & reference array and reset the count
				ZeroMemory(this->m_pTasks, sizeof(CTask*) * SINGULARITY_TASKS_MAX_TASKS);
				ZeroMemory(this->m_pLinks, sizeof(unsigned) * SINGULARITY_TASKS_MAX_TASKS);
			}
			::LeaveCriticalSection(&this->m_pLock);
		}

		void CTaskPool::Start()
		{
			unsigned int index;

			if(this->m_iState != TASKPOOL_STATE_INITIALIZED && 
				this->m_iState != TASKPOOL_STATE_IDLE &&
				this->m_iState != TASKPOOL_STATE_STOPPED)
				throw SingularityException("TaskPool is already running or cannot be started!");

			// intermediate update to the pool's state
			this->m_iState = TASKPOOL_STATE_STARTING;

			// start up all the threads
			for( index = 0; index < this->m_iThreadCount; index++)
				this->m_pThreads[index].Start(this);

			// update the pool's state
			this->m_iState = TASKPOOL_STATE_STARTED;

			for(;;)
			{
				for( index = 0; index < this->m_iThreadCount; index++)
					this->m_pThreads[index].Step();
			}
		}

		void CTaskPool::Stop()
		{
			unsigned index;

			if(this->m_iState != TASKPOOL_STATE_STARTED || 
				this->m_iState != TASKPOOL_STATE_IDLE)
				throw SingularityException("TaskPool is either already stopped or cannot be stopped!");

			// intermediate update to the pool's state
			this->m_iState = TASKPOOL_STATE_STOPPING;

			// spin wait for them to finish
			for( index = 0; index < this->m_iThreadCount; index++)
			{
				// this->m_pThreads[index].Abort();
				//while (!this->m_pThreads[index].Get_IsCompleted())
				//{ 
				//	Sleep(0); // wait for the thread to die off
				//}
			}

			// update the pool's state
			this->m_iState = TASKPOOL_STATE_STOPPED;
		}

		CTask* CTaskPool::PopTask()
		{
			CTask* task;
			unsigned i, linkIndex;

			::EnterCriticalSection(&this->m_pLock);
			{
				// grab the task index;
				linkIndex = this->m_pLinks[0];

				// grab the task
				task = this->m_pTasks[linkIndex];

				if(task)
				{
					// reset the head node to the next link
					this->m_pTasks[linkIndex] = NULL;
					this->m_pLinks[0] = this->m_pLinks[linkIndex];
					this->m_pLinks[linkIndex] = 0;
				}
			}
			::LeaveCriticalSection(&this->m_pLock);

			return task;
		}

		void CTaskPool::PushTask(CTask* task)
		{
			bool inserted;
			bool linked;
			unsigned i, linkIndex, storeIndex;
			CTask* cTask;

			if(this->m_iState < TASKPOOL_STATE_INITIALIZED)
				throw SingularityException("Tasks cannot be added to the pool until it is initialized.");

			::EnterCriticalSection(&this->m_pLock);
			{
				inserted = false;
				linked = false;
				for(i = 0, linkIndex = 0; i < SINGULARITY_TASKS_MAX_TASKS; i++)
				{
					if(!(inserted || this->m_pTasks[i]))
					{
						// mark as inserted
						inserted = true;

						// save where we stuck the object
						storeIndex = i;
					}

					if(!linked)
					{
						cTask = this->m_pTasks[linkIndex];

						// link before longer executing tasks
						if(!cTask || 
							cTask->m_eState != TaskState::Ready ||
							cTask->Get_EstimatedExecutionTime() > task->Get_EstimatedExecutionTime() || 
							!this->m_pLinks[linkIndex])
						{
							// mark as linked
							linked = true;
						}
						else
						{
							// move to the next index in the list
							linkIndex = this->m_pLinks[linkIndex];
						}
					}

					// kick out of the loop if you both found a spot and linked the node
					if(linked && inserted)
					{
						this->m_pLinks[storeIndex] = this->m_pLinks[linkIndex];
						this->m_pLinks[linkIndex] = storeIndex;
						this->m_pTasks[storeIndex] = task;
						break;
					}
				}	
			}
			::LeaveCriticalSection(&this->m_pLock);
		}
		#pragma endregion

		#pragma region Static Methods
		unsigned CTaskPool::GetHardwareThreadsCount()
		{
			SYSTEM_INFO si;
			::GetSystemInfo(&si);
			return si.dwNumberOfProcessors;
		}
		#pragma endregion
	}
}