@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -
@rem >>> EDIT AT YOUR OWN RISK. <<<
@echo off

:: Usage: proxy [command]
::
:: The [command]s are:
::                     no command, just the same as "proxy toggle"
::     toggle          toggle the Proxy for current window
::     on              enable the Proxy for current window
::     off             disable the Proxy for current window
::     status          show the value of %HTTP_PROXY% and %HTTPS_PROXY%
::     help            print the help message
::
:: end

echo.
set "_proxy_command=%~1"
if "%_proxy_command%"=="" goto Proxy_toggle
if "%_proxy_command%"=="toggle" goto Proxy_toggle
if "%_proxy_command%"=="on" goto Proxy_enable
if "%_proxy_command%"=="off" goto Proxy_disable
if "%_proxy_command%"=="status" goto Proxy_status
if "%_proxy_command%"=="help" goto Proxy_help
echo proxy %_proxy_command%: unknown command
echo. && goto Proxy_help
goto :eof


rem ================= Action Types =================


:Proxy_toggle
call :proxy_get
if "%_proxy_state%"=="true" goto Proxy_disable
goto Proxy_enable


:Proxy_enable
if NOT exist "%~dp0proxy.conf" (
    set "_proxy_state=unknown"
    goto proxy_msg
)
pushd "%~dp0"
set "_proxyHost=" & set "_httpPort=" & set "_httpsPort="
for /f "tokens=2 delims= " %%i in ('findstr /i "ProxyHost" proxy.conf') do ( set "_proxyHost=%%i" )
for /f "tokens=2 delims= " %%i in ('findstr /i "HttpPort" proxy.conf') do ( set "_httpPort=%%i" )
for /f "tokens=2 delims= " %%i in ('findstr /i "HttpsPort" proxy.conf') do ( set "_httpsPort=%%i" )
popd
if NOT "%_proxyHost%"=="" if NOT "%_httpPort%"=="" if NOT "%_httpsPort%"=="" (
    set "http_proxy=%_proxyHost%:%_httpPort%"
    set "https_proxy=%_proxyHost%:%_httpPort%"
    set "_proxy_state=true"
    goto Proxy_status
)
set "_proxy_state=unknown"
goto proxy_msg


:Proxy_disable
set "http_proxy="
set "https_proxy="
set "_proxy_state=false"
call :proxy_msg
goto :eof


:Proxy_status
call :proxy_get
call :proxy_msg
echo "HTTP_PROXY=%http_proxy%"
echo "HTTPS_PROXY=%https_proxy%"
echo.
goto :eof


:Proxy_help
setlocal EnableDelayedExpansion
for /f "usebackq eol=@ delims=" %%i in ("%~f0") do (
    set "_proxy_temp="%%i""
    echo !_proxy_temp! | findstr "::" >NUL && (
            set "_proxy_temp=!_proxy_temp:::=!"
            set "_proxy_temp=!_proxy_temp:"=!"
        )
    if "!_proxy_temp!"=="" (
        echo.
    ) else if "!_proxy_temp!"==" end" (
        goto proxy_endOfHelp
    ) else (
        echo !_proxy_temp!
    )
)
:proxy_endOfHelp
endlocal
goto :eof


rem ================= FUNCTIONS =================


:proxy_get
if NOT defined _proxy_state ( set "_proxy_state=false" )
if NOT "%http_proxy%"=="" ( set "_proxy_state=true" )
if NOT "%https_proxy%"=="" ( set "_proxy_state=true" )
goto :eof


:proxy_msg
if "%_proxy_state%"=="true" (
    echo Proxy for current window: temporarily enabled
)
if "%_proxy_state%"=="false" (
    echo Proxy for current window: temporarily disabled
)
if "%_proxy_state%"=="unknown" (
    echo "proxy.conf" NOT founded. Or incomplete proxy settings in "proxy.conf".
)
echo.
goto :eof
