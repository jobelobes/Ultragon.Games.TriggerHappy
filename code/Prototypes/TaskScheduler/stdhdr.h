#pragma once

#ifndef SINGULARITY_TASKS_MAX_THREADS
#define SINGULARITY_TASKS_MAX_THREADS 32		// maximum number of worker threads we expect to encounter
#endif

#ifndef SINGULARITY_TASKS_MAX_TASKS
#define SINGULARITY_TASKS_MAX_TASKS	256			// maximum capacity of a task queue
#endif

#ifndef SINGULARITY_TASKS_STACKSIZE
#define SINGULARITY_TASKS_STACKSIZE 64 * 1024	// worker threads stack size: 64K
#endif

#define TASKPOOL_OPTION_NONE			0x00000000
#define TASKPOOL_OPTION_SINGLETHREADED	0x00000001

#define TASKPOOL_STATE_UNINITIALIZED	0x00000000
#define TASKPOOL_STATE_INITIALIZED		0x00000001
#define TASKPOOL_STATE_STARTING			0x00000002
#define TASKPOOL_STATE_STARTED			0x00000003
#define TASKPOOL_STATE_IDLE				0x00000004
#define TASKPOOL_STATE_STOPPING			0x00000005
#define TASKPOOL_STATE_STOPPED			0x00000006

#include <windows.h>
#include <math.h>
#include <iostream>
#include <exception>
#include <d3dx10.h>

#include "SingularityException.h"

#include "CTask.h"
#include "CWorkerThread.h"
#include "CTaskPool.h"
#include "CTaskQueue.h"