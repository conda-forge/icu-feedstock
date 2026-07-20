@echo on

pkg-config --print-errors --exact-version "%PKG_VERSION%" icu-uc
if errorlevel 1 exit 1

for /f "usebackq tokens=*" %%a in (`pkg-config --cflags icu-uc`) do set "PC_CFLAGS=%%a"
for /f "usebackq tokens=*" %%a in (`pkg-config --msvc-syntax --libs --static icu-uc`) do set "PC_LIBS=%%a"

%CC% %CFLAGS% %LDFLAGS% %PC_CFLAGS% %PC_LIBS% "%RECIPE_DIR%\test.c"
if errorlevel 1 exit 1

test.exe
if errorlevel 1 exit 1
