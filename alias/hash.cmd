@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
@rem >>> EDIT AT YOUR OWN RISK. <<<
@echo off
@setlocal

:: Usage: hash [HashAlgorithm] <file>
::
:: The [HashAlgorithm]s are: (ignore case)
::                     no specific algorithm, use 'hash sha256 <file>' by default
::     MD2             print the cryptographic hash (MD2) of target file
::     MD4             print the cryptographic hash (MD4) of target file
::     MD5             print the cryptographic hash (MD5) of target file
::     SHA1            print the cryptographic hash (SHA1) of target file
::     SHA256          print the cryptographic hash (SHA256) of target file
::     SHA384          print the cryptographic hash (SHA384) of target file
::     SHA512          print the cryptographic hash (SHA512) of target file
::     help            print the help message
::
:: end

echo.
set "_hash_algorithm=%~1"
if /i "%_hash_algorithm%"=="MD2" goto Hash_show
if /i "%_hash_algorithm%"=="MD4" goto Hash_show
if /i "%_hash_algorithm%"=="MD5" goto Hash_show
if /i "%_hash_algorithm%"=="SHA1" goto Hash_show
if /i "%_hash_algorithm%"=="SHA256" goto Hash_show
if /i "%_hash_algorithm%"=="SHA384" goto Hash_show
if /i "%_hash_algorithm%"=="SHA512" goto Hash_show
if /i "%_hash_algorithm%"=="help" goto Hash_show
if exist "%_hash_algorithm%" (
    REM then it is a file instead of an algorithm
    set "_hash_default=true"
    set "_hash_algorithm=SHA256"
    goto Hash_show
)
echo hash %_hash_algorithm%: unknown or unsupported algorithm, or file not specific
echo. && goto Hash_help
goto :eof


rem ================= Action Types =================


:Hash_show
if NOT defined _hash_default shift
for /f "usebackq skip=1 delims=" %%i in (`certutil -hashfile "%~1" %_hash_algorithm%`) do (
    set "_hash_result=%%i"
    goto :hash_next
)
:hash_next
echo %_hash_result%
REM Use `echo %_hash_result% | clip` will cause
REM   an additional whitespace and one more line.
set /p "_hash_trimSpace=%_hash_result%" < NUL | clip
goto :eof


:Hash_help
setlocal EnableDelayedExpansion
for /f "usebackq eol=@ delims=" %%i in ("%~f0") do (
    set "_hash_temp="%%i""
    echo !_hash_temp! | findstr "::" >NUL && (
            set "_hash_temp=!_hash_temp:::=!"
            set "_hash_temp=!_hash_temp:"=!"
        )
    if "!_hash_temp!"=="" (
        echo.
    ) else if "!_hash_temp!"==" end" (
        goto hash_endOfHelp
    ) else (
        echo !_hash_temp!
    )
)
:hash_endOfHelp
endlocal
goto :eof
