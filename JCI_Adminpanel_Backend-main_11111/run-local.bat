@echo off
cd /d "%~dp0"

echo Freeing port 3002 if needed...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3002 ^| findstr LISTENING') do (
  echo Killing PID %%a
  taskkill /PID %%a /F >nul 2>&1
)

echo Starting JCI backend...
npm start
