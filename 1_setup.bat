@echo off
echo === Hackathon Lite – Oppsett ===
echo.

REM Sjekk at Python finnes
python --version >nul 2>&1
if errorlevel 1 (
    echo FEIL: Python ikke funnet. Last ned fra https://python.org
    pause
    exit /b 1
)

REM Installer avhengigheter
echo Installerer avhengigheter (kan ta 1-2 min)...
pip install litellm[proxy] requests --quiet
if errorlevel 1 (
    echo FEIL: pip install feilet.
    pause
    exit /b 1
)

REM Opprett .env hvis den ikke finnes
if not exist .env (
    copy .env.example .env
    echo.
    echo VIKTIG: Åpne .env og fyll inn GEMINI_API_KEY og LITELLM_MASTER_KEY
    echo Trykk en tast når du har lagret .env...
    pause
)

echo.
echo Oppsett fullført! Kjør 2_start_server.bat neste.
pause
