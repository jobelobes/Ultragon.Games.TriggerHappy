#include "stdhdr.h"

namespace Singularity
{
	namespace Tasks
	{
		struct TASK_OPTIONS
		{
			int Iterations;
			float Frequency;
			int Affenity;
		};

		enum TaskState { Ready = 1, Executing = 2, PendingComplete = 3, Complete = 4, PendingRecycle = 5, Recycle = 6 };

		class CTaskPool;
		class CWorkerThread;

		class CTask
		{
			private:
				#pragma region Variables
				unsigned			m_iAffinity;
				unsigned			m_iRefCount;
				TaskState			m_eState;
				
				CTask*				m_pParent;
				CWorkerThread*		m_pWorkerThread;
				
				__int64				m_iFrequency;
				__int64				m_iEstimatedExecutionTime;
				__int64				m_iLastExecutionTime;

				unsigned			m_iRunCount;
				#pragma endregion

				#pragma region Methods
				void InternalExecute(CWorkerThread* workerThread);
				#pragma endregion

			protected:
				#pragma region Constructors and Finalizers
				CTask();
				CTask(unsigned count);
				#pragma endregion

				#pragma region Properties
				__inline __int64 Get_LastExecutionTime() { return this->m_iLastExecutionTime; };

				__inline __int64 Get_EstimatedExecutionTime() { return this->m_iEstimatedExecutionTime; };
				__inline void Set_EstimatedExecutionTime(__int64 value) { this->m_iEstimatedExecutionTime = value; };

				__inline CWorkerThread* Get_WorkerThread() { return this->m_pWorkerThread; };

				__inline CTask* Get_ParentTask() { return this->m_pParent; };

				__inline unsigned Get_Affinity() { return this->m_iAffinity; };
				__inline void Set_Affinity(unsigned value) { this->m_iAffinity = min(10, max(0, value)); };
				#pragma endregion

				#pragma region Methods
				void Spawn(CTask* task);
				void Recycle();
				void Reset();

				//virtual bool OnExecute() = 0;
				#pragma endregion

				friend class CTaskQueue;
				friend class CWorkerThread;
				friend class CTaskPool;
		};
	}
}