@echo off
REM Builds both browser apps and copies them into backend\ so Render can serve them.
cd /d "%~dp0..\mobile"
call "%~dp0..\env.bat"

where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter is not installed - using the last builds in backend\webapp and backend\admin_webapp.
  if not exist "%~dp0..\backend\webapp\index.html" (
    echo No supplier build found. Install Flutter first.
    pause
    exit /b 1
  )
  goto done
)

echo Building the supplier app...
call flutter pub get
call flutter build web --base-href /app/
if errorlevel 1 (
  echo Supplier build failed.
  pause
  exit /b 1
)
if exist "%~dp0..\backend\webapp" rmdir /s /q "%~dp0..\backend\webapp"
xcopy /e /i /q "build\web" "%~dp0..\backend\webapp" >nul

echo Building the operator console...
call flutter build web --target lib/main_admin.dart --base-href /admin/ --output build/admin_web
if errorlevel 1 (
  echo Operator build failed.
  pause
  exit /b 1
)
if exist "%~dp0..\backend\admin_webapp" rmdir /s /q "%~dp0..\backend\admin_webapp"
xcopy /e /i /q "build\admin_web" "%~dp0..\backend\admin_webapp" >nul

:done
echo.
echo Done. Commit and push so Render can redeploy.
echo See deploy\ONLINE_GUIDE.md.
pause
