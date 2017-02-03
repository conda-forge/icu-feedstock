if "%ARCH%"=="32" (
   set ARCH=Win32
   set COPYSUFFIX=
) else (
  set ARCH=x64
  set COPYSUFFIX=64
)

:: Need to move a more current msbuild into PATH.  The one on AppVeyor barfs on the solution
::     This one comes from the Win7 SDK (.net 4.0), and is known to work.
if %VS_MAJOR% == 9 (
    COPY C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe .\
    set "PATH=%CD%;%PATH%"
)

msbuild source\allinone\allinone.sln /p:Configuration=Release;Platform=%ARCH%
if errorlevel 1 exit 1

ROBOCOPY bin%COPYSUFFIX% %LIBRARY_BIN% *.dll /E
if %ERRORLEVEL% LSS 8 exit 0
ROBOCOPY lib%COPYSUFFIX% %LIBRARY_LIB% *.lib /E
if %ERRORLEVEL% LSS 8 exit 0
ROBOCOPY include %LIBRARY_inc% * /E
if %ERRORLEVEL% LSS 8 exit 0
