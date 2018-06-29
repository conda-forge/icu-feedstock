SETLOCAL EnableDelayedExpansion
cd source

:: Remove all instances of /W4 from configure.
:: They get passed to the linker and confuse it.
:: Given that we aren't interested in warnings anyway
:: remove it. I could have used a patch but this seemed
:: more 'upgrade friendly'
sed "s~ /W4~~g" configure > configure.new
move configure.new configure

:: This seems to be required - not sure why but
:: rc.exe gets confused with the '/' form of slashes
set MSYS_RC_MODE=1

:: 32-bit and VS2015 ends in failure:
:: uconv.o : MSIL .netmodule or module compiled with /GL found; restarting link with /LTCG; add /LTCG to the link command line to improve linker performance
:: uconv.o : error LNK2001: unresolved external symbol _uconvmsg_dat
:: ../../bin/uconv.exe : fatal error LNK1120: 1 unresolved externals
:: .. without this
if "%ARCH%"=="32" (
  if "%c_compiler%"=="vs2015" (
    set DISABLE_EXTRAS=--disable-extras
  )
)

:: Can't seem to determine msys2 due to bug in config.guess,
:: BUT runConfigureICU expects cygwin, so we just pretend we are
:: The prefix looks strange but it seems we are chrooted into almost the right
:: place by msys2, but can't write to the directories we need - fix up below
if "%ARCH%"=="32" (
  FOR /F "delims=" %%i IN ('cygpath.exe -u "%LIBRARY_PREFIX%"') DO set "CYGWIN_LIBRARY_PREFIX=%%i"
  bash runConfigureICU Cygwin/MSVC --build=x86_64-pc-cygwin --prefix=!CYGWIN_LIBRARY_PREFIX!/icu %DISABLE_EXTRAS%
) else (
  bash runConfigureICU Cygwin/MSVC --build=x86_64-pc-cygwin --prefix=/icu %DISABLE_EXTRAS%
)

:: Ignore errorlevel - there are warnings about various things missing
:: which we don't actually seem to need. Just keep going...
::if errorlevel 1 exit 1

make -j%CPU_COUNT%
:: Run make twice. There is some timing issue between msys2 and rc.exe
:: that means that directories are created after they are required...
make -j%CPU_COUNT%
if errorlevel 1 exit 1

make install
if errorlevel 1 exit 1

:: Fix up for not being able to write into the root path with msys2
xcopy /e /i %LIBRARY_PREFIX%\icu\lib %LIBRARY_LIB%
if errorlevel 1 exit 1
xcopy /e /i %LIBRARY_PREFIX%\icu\bin %LIBRARY_BIN%
if errorlevel 1 exit 1
xcopy /e /i %LIBRARY_PREFIX%\icu\include %LIBRARY_INC%
if errorlevel 1 exit 1
xcopy /e /i %LIBRARY_PREFIX%\icu\share %LIBRARY_PREFIX%\share
if errorlevel 1 exit 1
rmdir /s /q %LIBRARY_PREFIX%\icu
if errorlevel 1 exit 1

:: The .dlls end up in the wrong place
move %LIBRARY_LIB%\icu*.dll %LIBRARY_BIN%
if errorlevel 1 exit 1