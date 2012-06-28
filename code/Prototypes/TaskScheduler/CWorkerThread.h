#include "stdhdr.h"

namespace Singularity
{
	namespace Tasks
	{
		class CTaskPool;

		class CWorkerThread 
		{
			private:
				#pragma region Variables
				HANDLE			m_hThread;

				__int64			m_iFrequency;
				__int64			m_iTimeLeft;

				CTask*			m_pCurrentTask;
				unsigned		m_iTaskRunCount;

				CTaskPool*		m_pTaskPool;
				CTask*			m_pTasks[SINGULARITY_TASKS_MAX_TASKS];
				#pragma endregion

				#pragma region Methods
				bool Start(CTaskPool* taskpool);
				bool Step();
				bool Stop();
				void Idle();

				void ExecuteTask(CTask* task);

				void _PushTask(CTask* task);
				#pragma endregion

			public:		
				#pragma region Constructors and Finalizers
				CWorkerThread();
				#pragma endregion
				
				#pragma region Properties
				__inline CTaskPool* Get_TaskPool() { return this->m_pTaskPool; }
				#pragma endregion

				#pragma region Static Methods
				static DWORD WINAPI DoWork(void* value);
				#pragma endregion

				friend class CTaskPool;
		};
	}
}