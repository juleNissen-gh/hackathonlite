@echo off
echo === Hackathon Lite – Oppretter lagnøkler ===
echo.

REM Last inn .env
for /f "usebackq tokens=1,* delims==" %%A in (".env") do (
    if not "%%A"=="" if not "%%A:~0,1%"=="#" set "%%A=%%B"
)

set LITELLM_URL=http://localhost:4000
python create_teams.py

echo.
echo Nøklene er lagret i team_keys.json
pause
