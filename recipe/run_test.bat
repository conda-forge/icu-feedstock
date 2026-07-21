@echo on

pkg-config --print-errors --exact-version "%PKG_VERSION%" icu-uc
if errorlevel 1 exit 1

for /f "usebackq tokens=*" %%a in (`pkg-config --cflags icu-uc`) do set "PC_CFLAGS=%%a"
for /f "usebackq tokens=*" %%a in (`pkg-config --msvc-syntax --libs --static icu-uc`) do set "PC_LIBS=%%a"

%CC% %CFLAGS% %PC_CFLAGS% test.c /link %LDFLAGS% %PC_LIBS%
if errorlevel 1 exit 1

test.exe
if errorlevel 1 exit 1
