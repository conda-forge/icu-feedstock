
cd source

:: Can't seem to determine msys2 due to bug in config.guess,
:: BUT runConfigureICU expects cygwin, so we just pretend we are
bash runConfigureICU Cygwin/MSVC --build=x86_64-pc-cygwin --prefix=%CYGWIN_PREFIX%
:: Ignore errorlevel - there are warnings about various things missing
:: which we don't actually seem to need. Just keep going...
::if errorlevel 1 exit 1

make -j%CPU_COUNT%
if errorlevel 1 exit 1

make install
if errorlevel 1 exit 1
