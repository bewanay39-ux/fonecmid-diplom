@echo off
setlocal EnableExtensions

REM ==========================================================
REM  Vanessa Automation runner for 1C
REM  Настрой один раз пути ниже.
REM ==========================================================

REM --- Путь к 1cv8.exe (поменяй на свою версию)
set V8="C:\Program Files\1cv8\8.3.27.XXXX\bin\1cv8.exe"

REM --- База: файловая (папка) или серверная /S
REM Пример файловой:
set IB=/F "C:\Bases\VKM_Demo"
REM Пример серверной (если надо):
REM set IB=/S "server\base"

REM --- Авторизация (если пароль не нужен, оставь только /N)
set AUTH=/N "Администратор"
REM set AUTH=/N "Администратор" /P "123"

REM --- Путь к VanessaAutomation.epf
set VA="C:\Tools\VanessaAutomation\VanessaAutomation.epf"

REM --- Каталог фич
set FEATURES="%~dp0features"

REM --- Лог
set LOG="%~dp0va_run.log"

echo === Vanessa Automation run started ===
echo V8=%V8%
echo IB=%IB%
echo VA=%VA%
echo FEATURES=%FEATURES%
echo LOG=%LOG%
echo =====================================

REM --- Проверки
if not exist %V8% (
  echo ERROR: 1cv8.exe not found: %V8%
  pause
  exit /b 1
)

if not exist %VA% (
  echo ERROR: VanessaAutomation.epf not found: %VA%
  pause
  exit /b 2
)

if not exist %FEATURES% (
  echo ERROR: Features folder not found: %FEATURES%
  pause
  exit /b 3
)

REM --- Запуск
REM Важно: FeaturePath указываем на папку features
REM Лог сохраняем в файл, чтобы можно было приложить к сдаче при необходимости
%V8% ENTERPRISE %IB% %AUTH% /Execute %VA% /C "StartFeaturePlayer;FeaturePath=%FEATURES%;VBParams=;Exit=true;" /Out %LOG%

set ERR=%ERRORLEVEL%
echo =====================================
echo ExitCode=%ERR%
echo Log saved to: %LOG%
echo =====================================

if not "%ERR%"=="0" (
  echo FAILED. Open log: %LOG%
  pause
  exit /b %ERR%
)

echo SUCCESS
exit /b 0
