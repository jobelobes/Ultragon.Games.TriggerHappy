#include "stdhdr.h"

namespace Singularity
{
	namespace Tasks
	{
		#pragma region Constructors and Finalizers
		CTask::CTask()
			: m_pParent(NULL), m_iRefCount(0), m_eState(TaskState::Ready) {}
		
		CTask::CTask(unsigned count)
			: m_pParent(NULL), m_iRefCount(0), m_eState(TaskState::Ready), m_iRunCount(count) {}
		#pragma endregion

		#pragma region Methods
		// spawns a task using the current task as the parent
		//	note: what this means is that the parent will not complete until all its children complete
		void CTask::Spawn(CTask* task)
		{
			// set the tasks parent to the current task
			task->m_pParent = this;

			// increment the reference count
			++this->m_iRefCount;

			// push the task onto the queue
			//this->Get_WorkerThread()->Get_TaskPool()->PushTask(task);
		}

		void CTask::InternalExecute(CWorkerThread* workerThread)
		{
			__int64 prev, next, actualProcessTime;

			if(this->m_eState == TaskState::Ready)
			{
				this->m_eState = TaskState::Executing;

				::QueryPerformanceCounter((LARGE_INTEGER*)&prev);
				//this->OnExecute();
				::QueryPerformanceCounter((LARGE_INTEGER*)&next);

				actualProcessTime = next - prev;
				this->m_iEstimatedExecutionTime += (actualProcessTime - this->m_iEstimatedExecutionTime) / 100;
			}

			switch(this->m_eState)
			{
				case TaskState::PendingComplete:
				case TaskState::Executing:
					{
						if(this->m_iRefCount > 0)
						{
							this->m_eState = TaskState::PendingComplete;

							this->Get_WorkerThread()->Get_TaskPool()->PushTask(this);
						}
						else if(this->m_pParent) 
								--this->m_pParent->m_iRefCount;
						break;
					}
				case TaskState::PendingRecycle:
					{
						if(this->m_iRefCount == 0)
						{
							if(this->m_pParent) 
								--this->m_pParent->m_iRefCount;	

							this->Reset();						
						}

						this->Get_WorkerThread()->Get_TaskPool()->PushTask(this);
						break;
					}
			};
		}

		void CTask::Recycle()
		{
			this->m_eState = TaskState::PendingRecycle;
		}

		void CTask::Reset()
		{
			this->m_pParent = NULL;
			this->m_iRefCount = 0;
			this->m_eState = TaskState::Ready;
		}
		#pragma endregion
	}
}