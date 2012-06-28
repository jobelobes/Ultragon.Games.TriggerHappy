#include "stdhdr.h"

namespace Singularity
{
	namespace Tasks
	{
		class CTaskQueue
		{
			private:
				#pragma region Variables
				unsigned			m_iCount;
				unsigned			m_iCapacity;
				CTask**				m_pNodes;

				LPCRITICAL_SECTION	m_pLock;
				#pragma endregion

				#pragma region Methods
				void _removeTask(CTask* task, bool forceRemove = false);
				#pragma endregion

			public:
				#pragma region Constructors and Finalizers
				CTaskQueue(int capacity = 256);
				~CTaskQueue();
				#pragma endregion

				#pragma region Methods
				CTask* Pop();
				void Push(CTask* task);
				#pragma endregion
		};
	}
}