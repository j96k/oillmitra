@echo off
REM Builds the supplier app and copies it to backend\webapp (served at /app/).
cd /d "%~dp0"
call "%~dp0..\env.bat"

where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter was not found on PATH.
  echo The prebuilt app in ..\backend\webapp still works.
  echo To rebuild, install Flutter or set FLUTTER_HOME in ..\env.bat.
  pause
  exit /b 1
)

echo Building the supplier app for the browser...
call flutter pub get
call flutter build web --base-href /app/
if errorlevel 1 (
  echo Build failed.
  pause
  exit /b 1
)

echo Copying to ..\backend\webapp ...
if exist "..\backend\webapp" rmdir /s /q "..\backend\webapp"
xcopy /e /i /q "build\web" "..\backend\webapp" >nul

echo.
echo Done. Start backend\run_server.bat, then open http://localhost:8000/app/
start "" http://localhost:8000/app/
pause
