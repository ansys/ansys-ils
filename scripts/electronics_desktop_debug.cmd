@ECHO OFF
setlocal ENABLEEXTENSIONS

REM Set version information
REM Then VERSION=19,  MINORVERSION=0

:start
cls
REM echo What version AnsysEM would you like to gather debug information for:
echo 1. AnsysEM2020R1
echo 2. AnsysEM2020R2
echo 3. AnsysEM2021R1
echo 4. AnsysEM2021R2
echo 5. AnsysEM2022R1
echo 6. AnsysEM2022R2
choice /C 123456 /D 4 /T 30 /M "What version AnsysEM would you like to gather debugs for: "

if ErrorLevel 6 (
set VERSION=22
set MINORVERSION=2
goto GotVersion
)
if ErrorLevel 5 (
set VERSION=22
set MINORVERSION=1
goto GotVersion
)
if ErrorLevel 4 (
set VERSION=21
set MINORVERSION=2
goto GotVersion
)
if ErrorLevel 3 (
set VERSION=21
set MINORVERSION=1
goto GotVersion
)
if ErrorLevel 2 (
set VERSION=20
set MINORVERSION=2
goto GotVersion
)
if ErrorLevel 1 (
set VERSION=20
set MINORVERSION=1
goto GotVersion
)
goto start
:GotVersion

REM Reset ErrorLevel
ver > nul

:GetDebugLevel
echo .
echo .
REM DBGLEVEL - Debug level is normally set to 2
echo What level debugs would you like to gather? 
echo Level 1 
echo Level 2 
echo Level 6
choice /C 126 /D 2 /T 15 /M "Please select 2 unless otherwise requested: "
if ErrorLevel 3 (
set DBGLEVEL=6
goto GotDebugLevel
)
if ErrorLevel 2 (
set DBGLEVEL=2
goto GotDebugLevel
)
if ErrorLevel 1 (
set DBGLEVEL=1
goto GotDebugLevel
)
goto GetDebugLevel
:GotDebugLevel


REM Reset ErrorLevel
ver > nul
echo .
echo .
:GetClearPrefs
choice /C yn /D n /T 15 /M "Would you like to clear user preferences: "
if ErrorLevel 2 (
set CLEARPREFS=N
goto GotClearPrefs
)
if ErrorLevel 1 (
set CLEARPREFS=Y
goto GotClearPrefs
)
goto GetClearPrefs
:GotClearPrefs


REM CLEARPREFS=  N - do not clear user preferences, Y - clear user preferences
REM set CLEARPREFS=N

REM !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
REM !!!!! No Changes below this line !!!!
REM !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
set BINARY=ansysedt.exe
set /a RELEASE=%VERSION%
set RELEASE=20%RELEASE%.%MINORVERSION%
FOR /F "usebackq tokens=3*" %%A IN (`REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Ansoft\ElectronicsDesktop\%RELEASE%\Desktop" /v InstallationDirectory`) DO (
    set BASEPATH=%%A %%B
    )

set EXECUTABLE=%BASEPATH%\%BINARY%

ECHO Exec: %EXECUTABLE%
ECHO Base: %BASEPATH%

set day=%date:~7,2%
set month=%date:~4,2%
set year=%date:~10,4%
set hour=%time:~0,2%
set min=%time:~3,2%


REM Set debug env vars
echo Setting Debug variables
set ANS_FLEXLM_DEBUG=2
set ANSOFT_DEBUG_MODE=%DBGLEVEL%
set EM2D_SOLVER_DO_LOG=%DBGLEVEL%
set ANSOFT_DEBUG_LOG_TIMESTAMP=%DBGLEVEL%
set ANSOFT_DEBUG_LOG=c:\temp\EBUdbg\dbg.log
set ANSOFT_DEBUG_LOG_SEPARATE=1
set ANSOFT_DEBUG_LOG_THREAD_ID=1
set ANSOFT_DEBUG_LOG_TIMESTAMP=1
set ANSOFT_PASS_DEBUG_ENV_TO_REMOTE_ENGINES=1
set MPIRUN_OPTIONS=-d -v
set I_MPI_DEBUG=5
set ANSOFT_MPI_DEBUG_LOG=c:\temp\EBUdbg\impi_


REM future
REM grab registry to confirm version/locations
REM C:\Windows\System32>reg query HKEY_LOCAL_MACHINE\SOFTWARE\Ansoft\ElectronicsDesktop\2016.1\Desktop /v InstallationDirectory
REM result
REM HKEY_LOCAL_MACHINE\SOFTWARE\Ansoft\ElectronicsDesktop\2016.1\Desktop
REM    InstallationDirectory    REG_SZ    C:\Program Files\AnsysEM\AnsysEM17.1\Win64
REM set KEY_NAME=HKEY_LOCAL_MACHINE\SOFTWARE\Ansoft\ElectronicsDesktop\2016.1\Desktop
REM set VALUE_NAME=InstallationDirectory
REM for /F "usebackq tokens=3" %%A IN (`reg query "%KEY_NAME%" /v "%VALUE_NAME%" 2^>nul ^| find "%VALUE_NAME%"`) do (echo %%A)



:start
IF NOT EXIST c:\temp\EBUdbg goto createfolder
echo Renaming prior debug logs
move /Y c:\temp\EBUdbg c:\temp\EBUdbg%month%%day%%year%%hour%%min%

:createfolder
REM Create Debug folder c:\temp\EBUdbg
IF EXIST c:\temp GOTO DBGDIRCREATE
echo creating temp directory c:\temp
mkdir c:\temp

:DBGDIRCREATE
IF EXIST c:\temp\EBUdbg GOTO runapp
echo creating debug directory c:\temp\EBUdbg
mkdir c:\temp\EBUdbg


:runapp
REM reset user preferences
IF %CLEARPREFS%==Y (
move /Y "%USERPROFILE%\Documents\Ansoft\ElectronicsDesktop%RELEASE%"  "%USERPROFILE%\Documents\Ansoft\ElectronicsDesktop%RELEASE%.%month%%day%%year%_%hour%%min%.bak"
)

REM Gather DXDIAG INFO
start dxdiag /t c:\temp\EBUdbg\_dxdiag.log
REM Gather IP info
start ipconfig /all > c:\temp\EBUdbg\_ipinfo.log
REM Gather Env var info
set > c:\temp\EBUdbg\_envvars.log
REM Gather CPU cores info (to determin if HT enabled)
WMIC CPU Get DeviceID,NumberOfCores,NumberOfLogicalProcessors /format:list > c:\temp\EBUdbg\_cpuList.txt
REM Gather  Process List
start WMIC /OUTPUT:c:\temp\EBUdbg\_WMICProcessList.txt PROCESS get Caption,Commandline,Processid,workingsetsize /format:list
REM Gather  list of installed software:
start WMIC /OUTPUT:c:\temp\EBUdbg\_WMICsoftware.log product get name,version /format:list
REM start WMIC /OUTPUT:c:\temp\EBUdbg\_WMICsoftware.log product, version get name
REM MS Info 
start msinfo32 /nfo c:\temp\EBUdbg\_MSinfo.NFO
start msinfo32 /report c:\temp\EBUdbg\_MSinfo_report.NFO
REM Capture Event Viewer logs
start wevtutil epl Security c:\temp\EBUdbg\_EventSecurityLog.evtx
start wevtutil epl System c:\temp\EBUdbg\_EventSystemLog.evtx
start wevtutil epl Application c:\temp\EBUdbg\_EventApplicationLog.evtx

REM copy redirect files
copy "%BASEPATH%\admin\*"  c:\temp\EBUdbg\
echo starting Application: %EXECUTABLE%
call "%EXECUTABLE%"

for /l %%x in (10, -1, 0) do (
   echo wait till all processes are finished, %%x s left
   SLEEP 1
)
xcopy /E /I /Y "%temp%\.ansys" c:\temp\EBUdbg\.ansys

:end
echo "exiting script"
REM open Windows Explorer to the debug files location after application close
explorer c:\temp\EBUdbg\
