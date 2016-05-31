cd source

set LIBRARY_PREFIX=%LIBRARY_PREFIX:\=/%
set SRC_DIR=%SRC_DIR:\=/%
set MSYSTEM=MINGW%ARCH%
set MSYS2_PATH_TYPE=inherit
set CHERE_INVOKING=1
:: Set flag saying we have stdint.h manually.  We take care of providing it where
::    it is needed, but missing, by using msinttypes
set "CXXFLAGS=%CXXFLAGS% -DU_HAVE_STDINT_H=1"
set "CFLAGS=%CFLAGS% -DU_HAVE_STDINT_H=1"

:: Set PATH to include msys2's binaries
set "PATH=%PATH%;%LIBRARY_PREFIX%\usr\bin;%LIBRARY_PREFIX%\mingw-w64\bin"

set MSYS2_ARG_CONV_EXCL

bash -x runConfigureICU MSYS/MSVC --prefix=%LIBRARY_PREFIX% --enable-static

set "MSYS2_ARG_CONV_EXCL=/AI;/AL;/OUT"

bash -x runConfigureICU MSYS/MSVC --prefix=%LIBRARY_PREFIX% --enable-static

if errorlevel 1 (
   appveyor PushArtifact "%CD%\config.log"
   exit 1
)
make
if errorlevel 1 exit 1
make check
if errorlevel 1 exit 1
make install
if errorlevel 1 exit 1

set LIBRARY_PREFIX=%LIBRARY_PREFIX:/=\%

MOVE %LIBRARY_PREFIX%\lib\*.dll %LIBRARY_BIN%\

exit 0
