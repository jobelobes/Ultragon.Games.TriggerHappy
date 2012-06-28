#include "stdhdr.h"

namespace Singularity
{
	namespace Tasks
	{
		#pragma region Constructors and Finalizers
		CTaskQueue::CTaskQueue(int capacity)
			: m_iCount(0), m_iCapacity(capacity)
		{
			this->m_pNodes = (CTask**)calloc(this->m_iCapacity, sizeof(CTask*));
		}

		CTaskQueue::~CTaskQueue()
		{
			if(this->m_pNodes != NULL)
				free(this->m_pNodes);
		}
		#pragma endregion

		#pragma region Methods
		void CTaskQueue::_removeTask(CTask* task, bool forceRemove)
		{
			unsigned index;

			if(task == NULL)
				return;

			if(this->m_iCount == NULL)
				return;

			// if set to recycle then don't mess with the object, just reset its state
			if(!forceRemove && task->m_eState == TaskState::Recycle)
			{
				task->Reset();
				return;
			}

			for(index = 0; index < this->m_iCount; index++)
			{
				if(this->m_pNodes[index] == task)
				{
					this->m_pNodes[index] = this->m_pNodes[this->m_iCount - 1];
					this->m_pNodes[--this->m_iCount];
					return;
				}
			}
		}

		CTask* CTaskQueue::Pop()
		{
			CTask *task, *tmp;
			unsigned index;
			unsigned __int64 now, taskSpan, tmpSpan;

			task = NULL;
			::QueryPerformanceCounter((LARGE_INTEGER*)&now);
			for(index = 0; index < this->m_iCount; index++)
			{
				tmp = this->m_pNodes[index];
				
				// replace if the current task isn't actually ready
				if(tmp->m_eState != TaskState::Ready)
					continue;
				
				if(task == NULL)
					task = tmp;
				else if(tmp->m_iFrequency > 0)
				{
					tmpSpan = (now < tmp->m_iLastExecutionTime ? _UI64_MAX : 0) + now - tmp->m_iLastExecutionTime;
					if(task->m_iEstimatedExecutionTime > tmpSpan)
						task = tmp;
				}
				
			}

			if(task->m_eState != TaskState::Ready)
				return NULL;
			return task;
		}

		void CTaskQueue::Push(CTask* task)
		{
			if(task == NULL)
				return; //throw SingularityException("\"task\" is a NULL reference and cannot be removed.");
			if(this->m_iCount == this->m_iCapacity)
				return; //throw SingularityException("The queue is currently filled to capacity");

			this->m_pNodes[this->m_iCount++] = task;
		}
		#pragma endregion
	}
}