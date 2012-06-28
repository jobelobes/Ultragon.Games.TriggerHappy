#include "stdhdr.h"

namespace Singularity
{
	#pragma region Properties
	const char* SingularityException::Get_Message()
	{
		return this->m_pMessage;
	}

	int SingularityException::Get_ErrorCode()
	{
		return this->m_pErrorCode;
	}
	#pragma endregion

	#pragma region Constructors and Finalizers
	SingularityException::SingularityException(const char* message) throw()
	{
		this->m_pMessage = message;
		this->m_pErrorCode = -1;
	}

	SingularityException::SingularityException(const char* message, int errorcode) throw()
	{
		this->m_pMessage = message;
		this->m_pErrorCode = errorcode;
	}

	SingularityException::SingularityException(int errorcode) throw()
	{
		this->m_pErrorCode = errorcode;

		switch(this->m_pErrorCode)
		{
			case D3D10_ERROR_FILE_NOT_FOUND:
				this->m_pMessage = "The file was not found.";
				break;
			case D3D10_ERROR_TOO_MANY_UNIQUE_STATE_OBJECTS:
				this->m_pMessage = "There are too many unique instances of a particular type of state object.";
				break;
			case D3DERR_INVALIDCALL:
				this->m_pMessage = "The method call is invalid. For example, a method's parameter may not be a valid pointer.";
				break;
			case D3DERR_WASSTILLDRAWING:
				this->m_pMessage = "The previous blit operation that is transferring information to or from this surface is incomplete.";
				break;
			case E_FAIL:
				this->m_pMessage = "Attempted to create a device with the debug layer enabled and the layer is not installed.";
				break;
			case E_INVALIDARG:
				this->m_pMessage = "An invalid parameter was passed to the returning function.";
				break;
			case E_OUTOFMEMORY:
				this->m_pMessage = "Direct3D could not allocate sufficient memory to complete the call.";
				break;
			default:
				this->m_pMessage = "Unknown Direct 3D 10 Error.";
				break;
		}
	}

	SingularityException::~SingularityException() throw(){}
	#pragma endregion

	#pragma region Methods
	const char* SingularityException::what() const throw()
	{
		char* buffer = new char[strlen(this->m_pMessage) + 20];
		sprintf(buffer, "%s\n\tError code: 0x%x", this->m_pMessage, this->m_pErrorCode);
		return (const char*)buffer;
	}
	#pragma endregion
}