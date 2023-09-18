import os
import subprocess
import datetime

def es2k_get_sysinfo():

    timestamp = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
    computer_name = os.environ.get("COMPUTERNAME", "UNKNOWN")
    sysinfo_filename = f"{computer_name}_sysinfo.txt"
    
    with open(sysinfo_filename, 'w') as f:

        # Current Date/Time
        f.write(f"DATE: {datetime.datetime.now().strftime('%Y-%m-%d')}\n")
        f.write(f"TIME: {datetime.datetime.now().strftime('%H:%M:%S')}\n\n")
        
        # Environment Variables
        f.write("Environment Variables\n")
        f.write("-------------------------\n")
        for key, value in os.environ.items():
            f.write(f"{key}={value}\n")
        f.write("\n\n")
        
        # system info commands
        commands = [
            ("System Information", "systeminfo"),
            ("MAC Addresses", "getmac /FO LIST /V"),
            ("IP Addresses", "ipconfig /ALL"),
            ("Processor ID", "wmic cpu get processorid"),
            ("Hard Disk Status", "wmic diskdrive get serialnumber, size")
        ]
        
        for title, cmd in commands:
            f.write(f"{title}\n")
            f.write("-------------------------\n")
            result = subprocess.check_output(cmd, shell=True, text=True, errors='ignore')
            f.write(result)
            f.write("\n\n")
        
        # Get User/Group Information
        f.write("User/Group Information\n")
        f.write("-------------------------\n")
        user_info = subprocess.check_output("whoami /USER /GROUPS", shell=True, text=True, errors='ignore')
        f.write(user_info)
        f.write("\n\n")
        
        # Get User Account
        f.write("User Account\n")
        f.write("-------------------------\n")
        user_account = subprocess.check_output("wmic useraccount get fullname, name, sid", shell=True, text=True, errors='ignore')
        f.write(user_account)
        f.write("\n\n")

        # Get Version Information for the DLL and EXE files in EBIScreen2000 folder
        f.write("EBIScreen2000 Files\n")
        f.write("-------------------------\n")
        
        powershell_cmd = "Get-ChildItem \EBIScreen2000\* -recurse -include *.dll,*.exe | ForEach-Object {$_.VersionInfo} | Format-Table -AutoSize @{n='File';e={$_.FileName}}, @{n='Product Version';e={$_.ProductVersion}}"
        result = subprocess.check_output(["powershell", "-command", powershell_cmd], text=True, errors='ignore')
        f.write(result)
        f.write("\n\n")

        powershell_cmd = "Get-ChildItem \EBIScreen2000\* -recurse -include *.dll,*.exe | ForEach-Object {$_.VersionInfo} | Format-Table -AutoSize @{n='File';e={$_.FileName}}, @{n='File Version';e={$_.FileVersion}}"
        result = subprocess.check_output(["powershell", "-command", powershell_cmd], text=True, errors='ignore')
        f.write(result)
        f.write("\n\n")

        f.write("-------------------------\n")
        f.write("System information saved")


    # Exporting registry
    adt_filename = f"{computer_name}_ADT.reg"
    subprocess.run(f'reg export "HKLM\\SOFTWARE\\WOW6432Node\\Adtranz Finland" {adt_filename} /Y', shell=True)
    
    odbc_filename = f"{computer_name}_ODBC.reg"
    subprocess.run(f'reg export "HKLM\\SOFTWARE\\WOW6432Node\\ODBC" {odbc_filename} /Y', shell=True)

    print(f"System information saved to {sysinfo_filename}")
    print(f"Registry Adtranz Finland exported to {adt_filename}")
    print(f"Registry ODBC exported to {odbc_filename}")

es2k_get_sysinfo()
