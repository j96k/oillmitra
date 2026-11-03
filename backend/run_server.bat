@echo off
REM Starts the OilMitra API on port 8000.
cd /d "%~dp0"
if not exist .venv (
  echo Creating Python virtual environment...
  python -m venv .venv
  .venv\Scripts\pip install -r requirements.txt
)
if not exist .env (
  copy .env.example .env
  echo Created backend\.env - uses SQLite by default.
)
echo.
echo  Supplier app:    http://localhost:8000/app/
echo  Operator console: http://localhost:8000/admin/
echo  API docs:        http://localhost:8000/docs
echo.
echo  Your PC's IP addresses (for phones on the same Wi-Fi):
ipconfig | findstr /i "IPv4"
echo.
.venv\Scripts\uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
echo.
echo  The server has stopped.
pause
