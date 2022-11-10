@rem - Encoding:utf-8; Mode:Batch; Language:en-US; LineEndings:CRLF -
@rem >>> EDIT AT YOUR OWN RISK. <<<
@echo off


REM Show help if there are no arguments, otherwise  turn to arguments parsing
if "%~1"=="" goto Usage
goto Run


:Usage
REM Print help information
echo.Use `7za` to archive all input files with password, for secure uploading or sharing.
echo.
echo.USAGE:
echo.    %~n0 [OPTIONS] [^<FILES_OR_DIRS^>...]
echo.
echo.OPTIONS:
echo.    -o, --output ^<PATH^>           Set output archive filename
echo.    -p, --password ^<PASSWD^>       Set password for archive
echo.        --no-hide-filenames       Don't encrypt filenames inside a password protected `.7z` archive
echo.        --sfx [MODULE]            Create SFX (self extracting) archive
echo.                                      [default: console] [possible values: console, gui]
echo.
echo.    -v, --verbose                 Use verbose output
echo.    -h, --help                    Print help information
echo.
echo.EXAMPLES:
echo.
echo.    za .
echo.    za --sfx
echo.    za -p 123456 -o my-name.7z
echo.    za -p 123456 -o my-name.zip
echo.    za -v -p 123456 --no-hide-filenames --sfx gui -o my-name.7z.exe dir1 dir2/file1 file2.txt file3.mp4
echo.
echo.NOTES:
echo.
echo.    * The length of [FILES_OR_DIRS] should not exceed 9.
exit /b 127


:Run
REM Set default values for all flags
setlocal EnableDelayedExpansion
set "verbose=false"
set "output=archive.7z"
set "output_notProvided=true"
set "overwrite=false"
set "password="
set "hide-filenames=true"
set "sfx=false"


:CheckOpts
REM Update flags based on user input
if "%~1"=="-h" goto Usage
if "%~1"=="--help" goto Usage
if "%~1"=="help" goto Usage
if "%~1"=="-v" ( set "verbose=true" ) & shift & goto CheckOpts
if "%~1"=="--verbose" ( set "verbose=true" ) & shift & goto CheckOpts
if "%~1"=="-o" ( set "output=%2" & set "output_notProvided=false" ) & shift & shift & goto CheckOpts
if "%~1"=="--output" ( set "output=%2" & set "output_notProvided=false" ) & shift & shift & goto CheckOpts
if "%~1"=="-p" ( set "password=%2" ) & shift & shift & goto CheckOpts
if "%~1"=="--password" ( set "password=%2" ) & shift & shift & goto CheckOpts
if "%~1"=="--no-hide-filenames" ( set "hide-filenames=false" ) & shift & goto CheckOpts
if "%~1"=="--sfx" ( set "sfx=console" ) & shift & (
    if "%~2"=="console" ( set "sfx=console" ) & shift
    if "%~2"=="gui" ( set "sfx=gui" ) & shift
) & goto CheckOpts


:Preprocessing
REM Define some variables based on flags
call :dbg verbose
call :dbg overwrite
call :dbg password
call :dbg hide-filenames
call :dbg sfx
call :dbg output

for /f "delims=" %%i in ("%output%") do ( set "archive_format=%%~xi" )
call :dbg archive_format


:CombineOpts
REM Prepare the final arguments for `7za`
REM https://sevenzip.osdn.jp/chm/cmdline/switches/index.htm
set "_opts="
@REM if "%overwrite%"=="true" ( set "_opts=%_opts% -aoa" )
if NOT "%password%"=="" (
    set "_opts=!_opts! -p%password%"
    if "%archive_format%"==".7z" if "%hide-filenames%"=="true" (
        set "_opts=!_opts! -mhe"
    )
)
if "%sfx%"=="console" (
    set "_opts=%_opts% -sfx7zCon.sfx"
    if "%output_notProvided%"=="true" (
        set "output=%output%.exe"
    )
)
if "%sfx%"=="gui" (
    set "_opts=%_opts% -sfx7z.sfx"
    if "%output_notProvided%"=="true" (
        set "output=%output%.exe"
    )
)


:Archive
REM Create archive using `7za`
call :log Running command: 7za a -r %_opts% %output% %1 %2 %3 %4 %5 %6 %7 %8 %9

7za a %_opts% %output% %1 %2 %3 %4 %5 %6 %7 %8 %9

exit /b %ERRORLEVEL%


rem ================= FUNCTIONS =================


:log
if "%verbose%"=="true" ( echo [INFO ] %* )
goto :eof


REM https://stackoverflow.com/questions/28578290/batch-how-to-echo-variable
:dbg
if "%verbose%"=="true" (
    for /f "usebackq tokens=*" %%i in (`echo %%%1%%`) do (
        echo [DEBUG] %1: "%%i"
    )
)
goto :eof
