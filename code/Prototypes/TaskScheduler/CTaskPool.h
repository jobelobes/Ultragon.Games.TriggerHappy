#include "stdhdr.h"

namespace Singularity
{
	namespace Tasks
	{
		class CTaskPool
		{
			public:
				#pragma region Static Variables
				static DWORD				g_iTLSindex;
				#pragma endregion

				#pragma region Variables
				unsigned					m_iState;
				unsigned					m_iThreadCount;

				unsigned					m_iTaskCount;
				CTask*						m_pTasks[SINGULARITY_TASKS_MAX_TASKS];
				unsigned					m_pLinks[SINGULARITY_TASKS_MAX_TASKS];

				CWorkerThread*				m_pThreads;
				CRITICAL_SECTION			m_pLock;
				#pragma endregion

			public:
				#pragma region Constructors and Finalizers
				CTaskPool();
				~CTaskPool();
				#pragma endregion

				#pragma region Methods	
				void Initialize(int options = 0);
				void Start();
				void Stop();
				void Pause();

				CTask* PopTask();
				void PushTask(CTask* task);
				#pragma endregion
				
				#pragma region Static Methods
				static unsigned GetHardwareThreadsCount();
				#pragma endregion

				friend class CWorkerThread;
		};
	}
}