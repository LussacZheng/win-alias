@rem - Encoding:utf-8; Mode:Batch; Language:en; LineEndings:CRLF -

@echo.
@echo Active Connections
@echo.
@echo   Proto  Local Address          Foreign Address        State           PID

@REM Uncomment to check indent and align:
@REM @echo   TCP    0.0.0.0:135            0.0.0.0:0              LISTENING       564
@REM @echo   TCP    0.0.0.0:5040           0.0.0.0:0              LISTENING       5536

@netstat -ano | findstr "%~1"
