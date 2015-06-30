@echo off
set /a MYPATH=%cd%
set /a path = %~d0
echo %MYPATH%
if "%1" EQU "1" (goto update)



:update
echo "md ignore all errors"
md {{xtDir}}\home\rzrk\db_bak\bak
md {{xtDir}}\home\rzrk\server\userdata\pids
rmdir /s /q {{xtDir}}\home\rzrk\server\bin\core
c:\python27\python win_Deploy.py 2 .
call {{xtDir}}\home\rzrk\server\monitor\win_dailyRestart.bat


