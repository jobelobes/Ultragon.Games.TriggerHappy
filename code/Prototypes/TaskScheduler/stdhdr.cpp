#include "stdhdr.h"

using namespace std;
using namespace Singularity;
using namespace Singularity::Tasks;

int main(int argc, char* argv[])
{
	try
	{
		CTaskPool* taskpool = new CTaskPool();

		CTask* task1 = new CTask(1);
		CTask* task2 = new CTask(1);
		CTask* task3 = new CTask(1);


	}
	catch(SingularityException& e) 
	{
		fprintf(stderr, "An exception has occurred: %s\n", e.what());
 
		system("PAUSE"); // press any key to continue...
		return e.Get_ErrorCode();
	}
 
	return 0;
}