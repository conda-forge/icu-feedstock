
cd source

:: This seems to be required - not sure why but
:: rc.exe gets confused with the '/' form of slashes
set MSYS_RC_MODE=1

:: Can't seem to determine msys2 due to bug in config.guess,
:: BUT runConfigureICU expects cygwin, so we just pretend we are
bash runConfigureICU Cygwin/MSVC --build=x86_64-pc-cygwin --prefix=%CYGWIN_PREFIX%/Library
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
