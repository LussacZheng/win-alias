@if "%~1"=="" (
	start notepad C:\Windows\System32\drivers\etc\hosts
) else (
	notepad C:\Windows\System32\drivers\etc\hosts
	ipconfig /flushdns
)

