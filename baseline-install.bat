@echo OFF
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Easy Batch Installer Script                                ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Author . . . : William Quinn                               ::
:: Version. . . : 1.3                                         ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::
:: SETUP VARIABLES ::
:::::::::::::::::::::
set #error0=Everything looks good from here, should be complete!
set #error1=You need to run this batch file as an Administrator.
set #error2=Couldn't find the program. Check the #install variable.
set #error3=The MSI variable isn't set correctly. Use a 0 or 1 only.
set #errorX=Something happened that prevented this from working.
set #log=%computername%_%~nx0.log
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: #msi equals 1 if you are installing an MSI file, else      ::
:: change it to 0.                                            ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set #msi=0
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Set #install to the EXE or MSI file you're needing to      ::
:: install. If the file has spaces, put the file name in      ::
:: quotes.                                                    ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set #installx86=
set #installx64=
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: #flags can be changed to any switch needed for the         ::
:: install.                                                   ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set #flags=
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: #verifyarchitecture equals 1 if you want to only install   ::
:: x86 to an x86 machine and x64 to an x64 machine. This is   ::
:: useful for certain installers like Google Chrome, where    ::
:: you don't need the x86 variant if the machine installing   ::
:: to is x64.                                                 ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set #verifyarchitecture=0
:::::::::::::::::::
:: START LOGGING ::
:::::::::::::::::::
mode con: cols=65 lines=24
pushd "%~dp0"
color 0B
title %~nx0
cls
echo ================================================================ >%#log% 2>&1
echo ================================================================
echo Logfile for %~nx0 >>%#log% 2>>&1
echo Logfile for %~nx0
echo Running on %computername% >>%#log% 2>>&1
echo Running on %computername%
echo Started on %date% @ %time% >>%#log% 2>>&1
echo Started on %date% @ %time%
echo ================================================================ >>%#log% 2>>&1
echo ================================================================
echo. >>%#log% 2>>&1
echo.
::::::::::::::::::::::::::::
:: CHECK FOR ADMIN RIGHTS ::
::::::::::::::::::::::::::::
net session >nul 2>&1
if not %ErrorLevel% == 0 (
  color 0E
  echo %#error1% >>%#log% 2>>&1
  echo %#error1%
  echo. >>%#log% 2>>&1
  echo.
  call :endlog
  echo. >>%#log% 2>>&1
  echo.
  echo Press any key to quit or wait 15 seconds.
  timeout /T 15 >nul 2>&1
  exit /B 1
)
:::::::::::::::::::::::::::::
:: WRITE BASIC INFO TO LOG ::
:::::::::::::::::::::::::::::
echo MSI . . . . . . . . . . : %#msi% >>%#log% 2>>&1
echo MSI . . . . . . . . . . : %#msi%
echo Install x86 . . . . . . : %#installx86% >>%#log% 2>>&1
echo Install x86 . . . . . . : %#installx86%
echo Install x64 . . . . . . : %#installx64% >>%#log% 2>>&1
echo Install x64 . . . . . . : %#installx64%
echo Flags . . . . . . . . . : %#flags% >>%#log% 2>>&1
echo Flags . . . . . . . . . : %#flags%
echo Verify Architecture . . : %#verifyarchitecture% >>%#log% 2>>&1
echo Verify Architecture . . : %#verifyarchitecture%
echo Architecture Detected . : %processor_architecture% >>%#log% 2>>&1
echo Architecture Detected . : %processor_architecture%
echo. >>%#log% 2>>&1
echo.
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Checks to see if the #install variables exists. If they    ::
:: don't, we need to write an error and close the batch file. ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if not exist "%#installx86%" (
  if not exist "%#installx64%" (
    color 0E
    echo %#error2% >>%#log% 2>>&1
    echo %#error2%
    echo. >>%#log% 2>>&1
    echo.
    call :endlog
    echo Press any key to quit or wait 15 seconds.
    timeout /T 15 >nul 2>&1
    exit /B 2
    )
)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Checks the #msi variable to see if it equals a valid       ::
:: number. If it doesn't equal 0 or 1, we need to write an    ::
:: error and close out the batch file. If it equals 0, run    ::
:: the install without msiexec. If it equals 1, we need to    ::
:: run #install with msiexec.                                 ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if not [%#msi%] equ [0] if not [%#msi%] equ [1] (
  color 0E
  echo %#error3% >>%#log% 2>>&1
  echo %#error3%
  echo. >>%#log% 2>>&1
  echo.
  call :endlog
  echo Press any key to quit or wait 15 seconds.
  timeout /T 15 >nul 2>&1
  exit /B 3
  )
::::::::::::::::::::::::::::::::
:: BEGIN BEFORE INSTALLATIONS ::
::::::::::::::::::::::::::::::::
echo Beginning before installations (if any) . . . >>%#log% 2>>&1
echo Beginning before installations (if any) . . .
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Place your extra commands below this comment. It's up to   ::
:: you to set the logging for these commands. If you want to  ::
:: have extra commands logged to the logfile, at the end of   ::
:: the command, add ">>%#log% 2>>&1" (without quotes).        ::
:: Without the log set, you'll see the results in the command ::
:: window and not the logfile. With it set, you'll see the    ::
:: results in the logfile and not the command window.         ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::
:: BEGIN INSTALLATION ::
::::::::::::::::::::::::
echo Beginning installation . . . >>%#log% 2>>&1
echo Beginning installation . . .
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: If #installx86 is filled in, start the installation.       ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:installx86
if not [%#installx86%] equ [] (
  if %#verifyarchitecture% equ 1 (
    if %processor_architecture% equ AMD64 (
      echo Not installing x86 variant due to processor architecture verification. Skipping. >>%#log% 2>>&1
      echo Not installing x86 variant due to processor architecture verification. Skipping.
      goto :installx64
      )
    )
  if %#msi% equ 0 %#installx86% %#flags% >>%#log% 2>>&1
  if not %errorlevel% equ 0 (
    color 0E
    echo %#errorX% >>%#log% 2>>&1
    echo %#errorX%
    echo. >>%#log% 2>>&1
    echo.
    call :endlog
    echo Press any key to quit or wait 15 seconds.
    timeout /T 15 >nul 2>&1
    exit /B 3
    )
  if %#msi% equ 1 msiexec /i %#installx86% %#flags% >>%#log% 2>>&1
  if not %errorlevel% equ 0 if not %errorlevel% equ 3010 (
    color 0E
    echo %#errorX% >>%#log% 2>>&1
    echo %#errorX%
    echo. >>%#log% 2>>&1
    echo.
    call :endlog
    echo Press any key to quit or wait 15 seconds.
    timeout /T 15 >nul 2>&1
    exit /B 3
    )
)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: If #installx64 is filled in, start the installation.       ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:installx64
if not [%#installx64%] equ [] (
  if %#verifyarchitecture% equ 1 (
    if %processor_architecture% equ x86 (
      echo Not installing x86 variant due to processor architecture verification. Skipping. >>%#log% 2>>&1
      echo Not installing x86 variant due to processor architecture verification. Skipping.
      goto :after-install
      )
    )
  if %#msi% equ 0 %#installx64% %#flags% >>%#log% 2>>&1
  if not %errorlevel% equ 0 (
    color 0E
    echo %#errorX% >>%#log% 2>>&1
    echo %#errorX%
    echo. >>%#log% 2>>&1
    echo.
    call :endlog
    echo Press any key to quit or wait 15 seconds.
    timeout /T 15 >nul 2>&1
    exit /B 3
    )
  if %#msi% equ 1 msiexec /i %#installx64% %#flags% >>%#log% 2>>&1
  if not %errorlevel% equ 0 if not %errorlevel% equ 3010 (
    color 0E
    echo %#errorX% >>%#log% 2>>&1
    echo %#errorX%
    echo. >>%#log% 2>>&1
    echo.
    call :endlog
    echo Press any key to quit or wait 15 seconds.
    timeout /T 15 >nul 2>&1
    exit /B 3
    )
)
:::::::::::::::::::::::::::::::
:: BEGIN AFTER INSTALLATIONS ::
:::::::::::::::::::::::::::::::
:after-install
echo Beginning after installations (if any) . . . >>%#log% 2>>&1
echo Beginning after installations (if any) . . .
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Place your extra commands below this comment. It's up to   ::
:: you to set the logging for these commands. If you want to  ::
:: have extra commands logged to the logfile, at the end of   ::
:: the command, add ">>%#log% 2>>&1" (without quotes).        ::
:: Without the log set, you'll see the results in the command ::
:: window and not the logfile. With it set, you'll see the    ::
:: results in the logfile and not the command window.         ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::
:: WRAP UP ::
:::::::::::::
echo %#error0% >>%#log% 2>>&1
echo %#error0%
echo. >>%#log% 2>>&1
echo.
call :endlog
popd
timeout /T 15 >nul 2>&1
exit /B 0

:endlog
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: This section is called when either an error prevents this  ::
:: batch file from running or the end of the batch file is    ::
:: reached.                                                   ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo ================================================================ >>%#log% 2>>&1
echo ================================================================
echo Logfile for %~nx0 >>%#log% 2>>&1
echo Logfile for %~nx0
echo Running on %computername% >>%#log% 2>>&1
echo Running on %computername%
echo Ended on %date% @ %time% >>%#log% 2>>&1
echo Ended on %date% @ %time%
echo ================================================================ >>%#log% 2>>&1
echo ================================================================
