@if "%~1"=="" (
	git archive -o ./archive.zip HEAD
) else (
	git archive -o "%~1" HEAD
)
