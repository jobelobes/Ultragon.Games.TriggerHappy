/*
** Lua binding: tolua
** Generated automatically by tolua++-1.0.92 on Sun Feb 15 22:29:47 2009.
*/

#define WIN32_LEAN_AND_MEAN

#ifndef __cplusplus
#include "stdlib.h"
#endif
#include "string.h"

#include "tolua++.h"

#include "windows.h"
#include "resource.h"

/* Exported function */
TOLUA_API int  tolua_tolua_open (lua_State* tolua_S);


/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
}

/* Open function */
TOLUA_API int tolua_tolua_open (lua_State* tolua_S)
{
	HRSRC src;
	HANDLE bytes;
	char id[5] = {'#', '\0', '\0', '\0', '\0'};
	int top;

	tolua_open(tolua_S);
	tolua_reg_types(tolua_S);
	tolua_module(tolua_S,NULL,0);
	tolua_beginmodule(tolua_S,NULL);

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);
	      
		_itoa(IDR_LUA8, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/compat-5.1.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA7, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/compat.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA3, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/basic.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA15, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/feature.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA24, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/verbatim.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA6, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/code.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA22, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/typedef.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA9, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/container.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA20, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/package.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA17, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/module.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA18, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/namespace.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA12, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/define.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA14, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/enumerate.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA11, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/declaration.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA23, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/variable.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA2, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/array.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA16, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/function.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA19, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/operator.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA21, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/template_class.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA4, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/class.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA5, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/clean.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

	{ /* begin embedded lua code */
		top = lua_gettop(tolua_S);

		_itoa(IDR_LUA13, &id[1], 10);
		src = FindResource(NULL, id, "LUA");
		bytes = LoadResource(NULL, src);
		tolua_dobuffer(tolua_S,(char*)LockResource(bytes), SizeofResource(NULL, src),"tolua embedded: src/bin/lua/doit.lua");
		FreeResource(bytes);

		lua_settop(tolua_S, top);
	} /* end of embedded lua code */


	{ /* begin embedded lua code */
		int top = lua_gettop(tolua_S);
		static unsigned char B[] = {
			10,108,111, 99, 97,108, 32,101,114,114, 44,109,115,103, 32,
			 61, 32,112, 99, 97,108,108, 40,100,111,105,116, 41, 10,105,
			102, 32,110,111,116, 32,101,114,114, 32,116,104,101,110, 10,
			 32,108,111, 99, 97,108, 32, 95, 44, 95, 44,108, 97, 98,101,
			108, 44,109,115,103, 32, 61, 32,115,116,114,102,105,110,100,
			 40,109,115,103, 44, 34, 40, 46, 45, 58, 46, 45, 58, 37,115,
			 42, 41, 40, 46, 42, 41, 34, 41, 10, 32,116,111,108,117, 97,
			 95,101,114,114,111,114, 40,109,115,103, 44,108, 97, 98,101,
			108, 41, 10, 32,112,114,105,110,116, 40,100,101, 98,117,103,
			 46,116,114, 97, 99,101, 98, 97, 99,107, 40, 41, 41, 10,101,
			110,100,32
			};
		tolua_dobuffer(tolua_S,(char*)B,sizeof(B),"tolua: embedded Lua code 23");
		lua_settop(tolua_S, top);
	} /* end of embedded lua code */

 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_tolua (lua_State* tolua_S) {
 return tolua_tolua_open(tolua_S);
};
#endif

