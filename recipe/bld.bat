cd source

:: MSYS includes a link.exe that is not MSVC's linker.  Hide it.
MOVE %LIBRARY_PREFIX%\usr\bin\link.exe %LIBRARY_PREFIX%\usr\bin\link.exe.backup

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

bash -x runConfigureICU MSYS/MSVC --prefix=%LIBRARY_PREFIX% --enable-static
appveyor PushArtifact C:\conda\conda-bld\work\icu\source\config.log
if errorlevel 1 exit 1
make
if errorlevel 1 exit 1
make check
if errorlevel 1 exit 1
make install
if errorlevel 1 exit 1

set LIBRARY_PREFIX=%LIBRARY_PREFIX:/=\%

MOVE %LIBRARY_PREFIX%\lib\*.dll %LIBRARY_BIN%\

:: Restore MSYS' link.exe
MOVE %LIBRARY_PREFIX%\usr\bin\link.exe.backup %LIBRARY_PREFIX%\usr\bin\link.exe
exit 0
