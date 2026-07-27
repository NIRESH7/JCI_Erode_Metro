@echo off
REM JCI Local Backend — uses existing "jci" database (same as MySQL Workbench)

echo.
echo 1) Set HS_DB_PASSWORD in .env = same password you use in MySQL Workbench
echo 2) Import referral tables once via Workbench (see below) OR run this after password is set
echo.

cd /d "%~dp0"
npm start
