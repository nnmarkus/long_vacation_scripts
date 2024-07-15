References: 
Adapted the Graphical Date popup (Show-DateTimePickerForm function) from following MS forum. 
https://learn.microsoft.com/en-us/powershell/scripting/samples/creating-a-graphical-date-picker?view=powershell-7.4


This script will
1. Set the AD Users account expire at a specific time. 
This is set via the Set-ADAccountExpiration function.
2. Create a scheduled task that removes the account expiration
This creates a scheduled task, that calls a script, with a -user parameter.



Scheduled task to disable account expiration
# Overview
This will create two scheduled tasks that run scripts to disable, and enable users. 
The scheduled task will call a script and pass the username you set in this script. 
b/c of this, this process/scheduled task relies on two external scripts (longVacationStart.ps1 and longVacationEnd.ps1)
Default location for these scripts is C:\scripts\long_vacation_scripts 
* can be changed by setting $rootDir in "SetLongVacationV2.PS1"

This script can be used to create scheduled tasks (preferably on a domain controller) to 
disable and re-enable users when they are known to be away for a extended period of time. 
!!! this runs with the following settings so it MUST be set on a domain controller. 
1. "Run whether user is logged on or not"
2. Run as SYSTEM
3. Run with highest privileges

References: 
Adapted the Graphical Date popup (Show-DateTimePickerForm function) from following MS forum. 
https://learn.microsoft.com/en-us/powershell/scripting/samples/creating-a-graphical-date-picker?view=powershell-7.4


To run the script, use the SetLongVacationV2 script. 