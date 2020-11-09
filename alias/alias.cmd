@echo off

echo All currently available aliases:

setlocal EnableDelayedExpansion
pushd "%~dp0"
for /f "delims=" %%i in ('dir /b /a-d /o:n ^| findstr "\.cmd$ \.bat$"') do (
    set "als_Item=%%i"
    set "als_Item=!als_Item:~0,-4!"
    echo  * !als_Item!
)
popd
endlocal
