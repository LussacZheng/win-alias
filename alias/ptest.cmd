@echo off

call proxy on
echo ==================================
echo.

pushd %TEMP%

if NOT exist proxy_speed_test\ md proxy_speed_test
pushd proxy_speed_test

del /Q 10mb.test* >NUL 2>NUL
del /Q 100mb.test* >NUL 2>NUL

wget http://cachefly.cachefly.net/10mb.test
if NOT "%~1"=="" wget http://cachefly.cachefly.net/100mb.test

popd & popd
