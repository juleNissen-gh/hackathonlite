@echo off
echo === Hackathon Lite – Starter LiteLLM-server ===
echo.

REM Last inn .env
if not exist .env (
    echo FEIL: .env mangler. Kjør 1_setup.bat først.
    pause
    exit /b 1
)

for /f "usebackq tokens=1,* delims==" %%A in (".env") do (
    if not "%%A"=="" if not "%%A:~0,1%"=="#" set "%%A=%%B"
)

if "%GEMINI_API_KEY%"=="din-gemini-api-nøkkel-her" (
    echo FEIL: Fyll inn GEMINI_API_KEY i .env-filen.
    pause
    exit /b 1
)
if "%LITELLM_MASTER_KEY%"=="sk-sett-noe-hemmelig-her" (
    echo FEIL: Fyll inn LITELLM_MASTER_KEY i .env-filen.
    pause
    exit /b 1
)

echo Server starter på http://localhost:4000
echo La dette vinduet stå åpent under hackathonen.
echo Trykk Ctrl+C for å stoppe.
echo.

litellm --config config.yaml --port 4000
pause
