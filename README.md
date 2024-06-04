This will create two scheduled tasks that run scripts to disable, and enable users. 
The scheduled task will call a script and pass the username you set in this script. 
b/c of this, this process/scheduled task relies on two external scripts (longVacationStart.ps1 and longVacationEnd.ps1)
Default location for these scripts is C:\scripts\long_vacation_scripts 
* can be changed by setting $rootDir in "SetLongVacationV2.PS1"

Creates the scheduled tasks in LongVacation folder within TaskScheduler
See task_schedule_folder_location.png
Please create this folder if it does not exist yet. 

References: 
Adapted the Graphical Date popup (Show-DateTimePickerForm function) from following MS forum. 
https://learn.microsoft.com/en-us/powershell/scripting/samples/creating-a-graphical-date-picker?view=powershell-7.4


To run the script, use the SetLongVacationV2 script. 