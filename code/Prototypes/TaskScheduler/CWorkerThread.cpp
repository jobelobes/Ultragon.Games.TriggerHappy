#include "stdhdr.h"

namespace Singularity
{
	namespace Tasks
	{
		#pragma Constructors and Finalizers
		CWorkerThread::CWorkerThread() {}
		#pragma endregion

		#pragma Methods
		bool CWorkerThread::Start(CTaskPool* taskpool)
		{
			::QueryPerformanceFrequency((LARGE_INTEGER*)&this->m_iFrequency);
			this->m_iFrequency /= 60;
			this->m_iTimeLeft				= this->m_iFrequency;
			this->m_pTaskPool				= taskpool;

			this->m_pCurrentTask			= NULL;
			
			return true;
		}

		bool CWorkerThread::Step()
		{
			CWorkerThread::DoWork((void*)this);
			return true;
		}

		bool CWorkerThread::Stop()
		{
			return true;
		}

		void CWorkerThread::Idle()
		{
			//::Sleep(0);
		}
		#pragma endregion

		#pragma Static Methods
		// static method defined to run the tasks assigned to 
		//  the thread.  This is what is doing all the work, 
		//	essentially the method is a big while(true) loop
		//	that iterates over the tasks list.
		DWORD WINAPI CWorkerThread::DoWork(void* value)
		{
			//__int64 previousTimer = 0;
			//__int64 currentTimer = 0;
			//CTask* currentTask = NULL;
			CWorkerThread* workerThread = (CWorkerThread*)value;

			//::QueryPerformanceCounter((LARGE_INTEGER*)&previousTimer);

			// prevents while(true) warning during compile
			//for(;;)
			//{

				if(workerThread->m_pCurrentTask == NULL || workerThread->m_iTaskRunCount == 0)
				{
					if(workerThread->m_pCurrentTask = workerThread->m_pTaskPool->PopTask())
						workerThread->m_iTaskRunCount = workerThread->m_pCurrentTask->m_iRunCount;
				}

				if(workerThread->m_pCurrentTask != NULL)
					workerThread->m_iTaskRunCount--;
				else
					workerThread->Idle();

				/*if(currentTask = workerThread->m_pTaskPool->PopTask())
				{
					currentTask->m_pWorkerThread = workerThread;
					currentTask->InternalExecute(workerThread);
				}
				else
					workerThread->Idle();*/
					
				/*::QueryPerformanceCounter((LARGE_INTEGER*)&currentTimer);
				workerThread->m_iTimeLeft -= currentTimer - previousTimer;
				previousTimer = currentTimer;*/
			//}

			return 0;
		}
		#pragma endregion
	}
}