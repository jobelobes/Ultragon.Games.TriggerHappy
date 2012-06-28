#include "stdhdr.h"

namespace Singularity
{
	class SingularityException : public std::exception
	{
		private:
			const char* m_pMessage;
			int m_pErrorCode;

		public:
			#pragma region Properties
			virtual const char* Get_Message();
			virtual int Get_ErrorCode();
			#pragma endregion

			#pragma region Constructors and Finalizers
			SingularityException(const char*) throw();
			SingularityException(const char*, int) throw();
			SingularityException(int) throw();
			virtual ~SingularityException() throw();
			#pragma endregion

			#pragma region Methods
			virtual const char* what() const throw();
			#pragma endregion
	};
}