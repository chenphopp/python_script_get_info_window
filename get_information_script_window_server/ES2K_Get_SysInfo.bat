::==============================================================================
:: File:    ES2K_Get_SysInfo.bat
::
:: Purpose: Collect the Windows machine information
::
:: Author: Sumet Ketsri (sumet.ketsri@alstomgroup.com)
::
:: DATE        AUTHOR            CHANGES
:: ==========  ================  ===============================================
:: 2023-09-04  Sumet Ketsri      First Release
::==============================================================================

@echo off

set SYSINFO=%COMPUTERNAME%_sysinfo.txt
if exist C:\EBIScreen2000 (
	set EBIScreen2000_DIR=C:\EBIScreen2000
	set EBIScreen2000_DIR_LINUX=C:/EBIScreen2000
) else (
	set EBIScreen2000_DIR=D:\EBIScreen2000
	set EBIScreen2000_DIR_LINUX=D:/EBIScreen2000
)

echo.
echo Create System Information File at '%SYSINFO%'
echo Please wait for the result...
echo.

echo. > %SYSINFO%
echo DATE: %date% >> %SYSINFO%
echo TIME: %time% >> %SYSINFO%
echo. >> %SYSINFO%

echo ------------------------- >> %SYSINFO%
echo Environment Variables     >> %SYSINFO%
echo ------------------------- >> %SYSINFO%
set >> %SYSINFO%
echo. >> %SYSINFO%
echo. >> %SYSINFO%

echo ------------------------- >> %SYSINFO%
echo System Information        >> %SYSINFO%
echo ------------------------- >> %SYSINFO%
systeminfo >> %SYSINFO%
echo. >> %SYSINFO%
echo. >> %SYSINFO%

echo ------------------------- >> %SYSINFO%
echo MAC Addresses             >> %SYSINFO%
echo ------------------------- >> %SYSINFO%
getmac /FO LIST /V >> %SYSINFO%
echo. >> %SYSINFO%
echo. >> %SYSINFO%

echo ------------------------- >> %SYSINFO%
echo IP Addresses              >> %SYSINFO%
echo ------------------------- >> %SYSINFO%
ipconfig /ALL >> %SYSINFO%
echo. >> %SYSINFO%
echo. >> %SYSINFO%

echo ------------------------- >> %SYSINFO%
echo Processor ID              >> %SYSINFO%
echo ------------------------- >> %SYSINFO%
wmic cpu get processorid | more >> %SYSINFO%
echo. >> %SYSINFO%
echo. >> %SYSINFO%

echo ------------------------- >> %SYSINFO%
echo Hard Disk Status          >> %SYSINFO%
echo ------------------------- >> %SYSINFO%
wmic diskdrive get serialnumber, size | more >> %SYSINFO%
echo. >> %SYSINFO%
powershell -command "Get-WmiObject -Class win32_logicaldisk | Format-Table DeviceId, VolumeName, @{n='Size (GB)';e={[math]::Round($_.Size/1GB,2)}}, @{n='FreeSpace (GB)';e={[math]::Round($_.FreeSpace/1GB,2)}}" >> %SYSINFO%
echo. >> %SYSINFO%
echo. >> %SYSINFO%
 
echo ------------------------- >> %SYSINFO%
echo User/Group Information   >> %SYSINFO%
echo ------------------------- >> %SYSINFO%
whoami /USER /GROUPS >> %SYSINFO%
echo. >> %SYSINFO%
echo. >> %SYSINFO%

echo ------------------------- >> %SYSINFO%
echo User Account              >> %SYSINFO%
echo ------------------------- >> %SYSINFO%
wmic useraccount get fullname, name, sid >> %SYSINFO%
echo. >> %SYSINFO%
echo. >> %SYSINFO%

echo ------------------------- >> %SYSINFO%
echo EBIScreen2000 Files       >> %SYSINFO%
echo ------------------------- >> %SYSINFO%
REM powershell -command "Get-ChildItem \EBIScreen2000\* -recurse -include *.dll,*.exe | ForEach-Object {$_.VersionInfo} | Format-Table -AutoSize @{n='File';e={$_.FileName}}, @{n='File Version';e={$_.FileVersion}}"
REM Run twice because sometimes the versions are truncated.
echo ----------------------------------------------------------------------------------------------------------------------------- >> %SYSINFO%
powershell -command "Get-ChildItem \EBIScreen2000\* -recurse -include *.dll,*.exe | ForEach-Object {$_.VersionInfo} | Format-Table -AutoSize @{n='File';e={$_.FileName}}, @{n='Product Version';e={$_.ProductVersion}}" >> %SYSINFO%
echo. >> %SYSINFO%
echo ----------------------------------------------------------------------------------------------------------------------------- >> %SYSINFO%
powershell -command "Get-ChildItem \EBIScreen2000\* -recurse -include *.dll,*.exe | ForEach-Object {$_.VersionInfo} | Format-Table -AutoSize @{n='File';e={$_.FileName}}, @{n='Product Version';e={$_.ProductVersion}}" >> %SYSINFO%
echo. >> %SYSINFO%

echo ----------------------------------------------------------------------------------------------------------------------------- >> %SYSINFO%
powershell -command "Get-ChildItem \EBIScreen2000\* -recurse -include *.dll,*.exe | ForEach-Object {$_.VersionInfo} | Format-Table -AutoSize @{n='File';e={$_.FileName}}, @{n='File Version';e={$_.FileVersion}}" >> %SYSINFO%
echo. >> %SYSINFO%
echo ----------------------------------------------------------------------------------------------------------------------------- >> %SYSINFO%
powershell -command "Get-ChildItem \EBIScreen2000\* -recurse -include *.dll,*.exe | ForEach-Object {$_.VersionInfo} | Format-Table -AutoSize @{n='File';e={$_.FileName}}, @{n='File Version';e={$_.FileVersion}}" >> %SYSINFO%
echo. >> %SYSINFO%

echo ----------------------------------------------------------------------------------------------------------------------------- >> %SYSINFO%
REM \cygwin64\bin\find . -name "*.dll" -o -name "*.exe" -o -name "*.config" -o -name "*.cfg" -o -name "*.json" | \cygwin64\bin\xargs md5sum
REM cygwin64_find.exe %EBIScreen2000_DIR_LINUX% -name "*.dll" -o -name "*.exe" -o -name "*config*" -o -name "*cfg*" -o -name "*json*" | cygwin64_xargs.exe md5sum >> %SYSINFO%
REM \cygwin64\bin\find %EBIScreen2000_DIR_LINUX% -name "*.dll" -o -name "*.exe" -o -name "*config*" -o -name "*cfg*" -o -name "*json*" | \cygwin64\bin\xargs md5sum >> %SYSINFO%
cygwin64_find.exe %EBIScreen2000_DIR_LINUX% -name "*.dll" -o -name "*.exe" -o -name "*config*" -o -name "*cfg*" -o -name "*json*" | cygwin64_xargs.exe ./md5sum >> %SYSINFO% 2> nul
echo. >> %SYSINFO%


echo ------------------------- >> %SYSINFO%
echo Export Registry           >> %SYSINFO%
echo Adtranz Finland and ODBC  >> %SYSINFO%
echo ------------------------- >> %SYSINFO%
reg export "HKLM\SOFTWARE\WOW6432Node\Adtranz Finland" %COMPUTERNAME%_ADT.reg /Y > nul
reg export "HKLM\SOFTWARE\WOW6432Node\ODBC" %COMPUTERNAME%_ODBC.reg /Y > nul
echo DONE >> %SYSINFO%
echo. >> %SYSINFO%
echo. >> %SYSINFO%

echo Done