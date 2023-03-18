@echo off
color 0a
title Website Admin Desa Girimulyo
echo Selamat Datang

::-------------Cek Apakah Terhubung dengan Internet------------------------
:check
echo:&Ping www.google.com -n 1 -w 1000 > NUL
if errorlevel 1 (echo Tidak Terhubung Dengan Internet & echo Segala Perubahan Mungkin Tidak Tersimpan Pada File Global & echo Tetapi Tetap Tersimpan Pada File Local & echo: & echo Ingin Lanjut? & echo Y = Iya, T = Tidak, C = Cek Ulang & echo: & choice /C YTC /m "Pilih ") else (echo Terhubung Dengan Internet Mohon Tunggu& timeout /t 2 /nobreak>NUL)
if %errorlevel% equ 1 goto login
if %errorlevel% equ 2 exit
if %errorlevel% equ 3 cls & timeout /t 3 /nobreak & goto check

:start
::--------------Menjalankan Program---------------------
echo: & echo Menjalankan Lokal Server
timeout /t 2 /nobreak>NUL
start D:\wamp64\wampmanager.exe

echo: & echo Menjalankan Auto Stop Program
timeout /t 2 /nobreak>NUL
start D:\wamp64\www\giri-admin\wp-admin\user\AutoRun\user.lnk

echo: & echo Menunggu Lokal Server Siap
:repeat
for /f %%a in ('tasklist /FI "IMAGENAME eq mysqld.exe" ^| find /I /C "mysqld.exe"') do (if %%a neq 2 goto repeat)

echo: & echo Lokal Server Sudah siap
echo Menjalankan Web Admin
start msedge.exe http://localhost/giri-admin/wp-admin -inprivate
::------------------------------------------------------

:loop
set /A looping+=1

::--------------Membuat tanggal dan waktu---------------
For /F "tokens=1,2,3,4 delims=/ " %%A in ('Date /t') do (
  Set DayW=%%A
  Set Month=%%B
  Set Day=%%C
  Set Year=%%D
  Set All=%%A %%B/%%C/%%D
)
For /F "tokens=1,2,3 delims=:,. " %%A in ('echo %time%') do (
  set /a "Hour=100%%A%%100"
  set Min=%%B
  set Sec=%%C
)
if %Hour% geq 12 (
  set AMPM=PM
  set /a "Hour-=12"
) else set "AMPM=AM"
if %Hour% equ 0 set "Hour=12"
if %Hour% lss 10 set "Hour=0%Hour%"
set "Allm=%Hour%:%Min%:%Sec% %AMPM%"

::------Meriksa Perubahan File Global dan File Local-----
echo: & echo Memeriksa File Global Github
cd /d D:\wamp64\www\girimulyo\
timeout /t 5 /nobreak > NUL
git pull https://github.com/ryan-ern/girimulyo.git

echo: & echo Memeriksa File Local
git add --all
git commit -m "AutoCommit %All% %Allm%"
git push

timeout /t 3 /nobreak > NUL
if %looping%==2 cls & set looping=0
::------Pull atau Push Otomatis Ketika Ada Perubahan -----
goto loop

exit
