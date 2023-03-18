::----------Dijalankan dengan Shortcut agar bisa run as administrator--------------
@echo off
powershell -window hidden -command ""
color f2
:start
set /a loop+=1
tasklist /v | Find "Website Admin Desa Girimulyo"
if "%ERRORLEVEL%"=="1" taskkill /im msedge.exe /f & taskkill /im mysqld.exe /f & taskkill /im httpd.exe /f & taskkill /im wampmanager.exe /f & taskkill /im cmd.exe /f & exit
if %loop%==10 cls & set loop=0
goto :start
