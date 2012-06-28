::@ECHO off
::CLS
::CHDIR ..\..\Code\Singularity_Engine\include
::FOR /F "tokens=1* delims=." %%a IN (..\..\..\Assets\Scripts\ScriptingBuildList.txt) DO (
::@ECHO Building %%a.%%~nb scripting package

::IF NOT EXIST "..\src\%%~nb.scripting\" MKDIR "..\src\%%~nb.scripting"
::IF NOT EXIST "..\include\%%~nb.scripting\" MKDIR "..\include\%%~nb.scripting\"
::"..\..\..\Assets\Tools\tolua++.exe" -D -n %%a_%%~nb -o "..\src\%%~nb.scripting\%%a.%%~nb.Scripting.cpp" -H "%%~nb.Scripting\%%a.%%~nb.Scripting.h" -L "..\..\..\Assets\Scripts\access_hook.lua" "..\..\..\Assets\Scripts\%%a.%%b"
::@ECHO      - writing to".\src\%%~nb.scripting\%%a.%%~nb.Scripting.cpp"
::)
::PAUSE
::EXIT
@ECHO off
CHDIR ..\..\Code\Singularity_Engine\include
"..\..\..\Assets\Tools\tolua++.exe" -D -q -n Singularity_scripting -o "..\src\scripting\Scripting.Definitions.cpp" -H "scripting\Scripting.Definitions.h" -L "..\..\..\Assets\Scripts\access_hook.lua" "..\..\..\Assets\Scripts\singularity.core.pkg"
@ECHO      - writing to "..\src\scripting\Scripting.Definitions.cpp"
PAUSE
EXIT