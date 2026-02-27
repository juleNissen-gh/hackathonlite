@echo off
echo === Hackathon Lite – Starter dashboard ===
echo.
echo Dashboard tilgjengelig på http://localhost:8080
echo Del denne lenken med lagene så de kan sjekke forbruket sitt.
echo La dette vinduet stå åpent under hackathonen.
echo Trykk Ctrl+C for å stoppe.
echo.

python -m http.server 8080 --directory dashboard
pause
