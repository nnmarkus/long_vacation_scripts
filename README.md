References: 
Adapted the Graphical Date popup (Show-DateTimePickerForm function) from following MS forum. 
https://learn.microsoft.com/en-us/powershell/scripting/samples/creating-a-graphical-date-picker?view=powershell-7.4


This script will
1. Set the AD Users account expire at a specific time. 
This is set via the Set-ADAccountExpiration function.
2. Create a scheduled task that removes the account expiration
This creates a scheduled task, that calls a script, with a -user parameter.



Scheduled task to disable account expiration
!!! this runs with the following settings so it MUST be set on a domain controller. 
1. "Run whether user is logged on or not"
2. Run as SYSTEM
3. Run with highest privileges




POTENTIAL TO DO LIST:
1.  Add SMTP notifications for when the set script is ran and when the end/start scripts are ran. 
    Maybe a new distro like "longvacationnotifications@"