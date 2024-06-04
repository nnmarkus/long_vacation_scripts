<# 
Directions:
    1. Enter information when prompted.
    2. Confirm information before proceeding.
#>

$adUsername = Read-Host "Enter Active Directory username"
$startDate = Read-Host "Enter start date and time (use the format: 'MM/dd/yyyy HH:mm:ss', eg.06/13/2022 09:30:00)"
$endDate = Read-Host "Enter end date and time (use the format: 'MM/dd/yyyy HH:mm:ss', eg.06/13/2022 09:30:00)"
$csNumber = Read-Host "Enter RSM Case number"

$confirmation = Read-Host "You are about to schedule an account lockout for $adusername between $startdate and $enddate. Are you sure you want to proceed (Y/N)?"

if ($confirmation -eq 'Y' -or $confirmation -eq 'y') {
Set-ADAccountExpiration -Identity $adUsername -DateTime $startdate # Make sure to set the date for script implementation here

$endTrigger = New-JobTrigger -Once -At $endDate # Make sure to set the date for script expiration here

$taskName = "$adUsername"+"_"+"$csNumber"

Register-ScheduledJob -Name $taskName -Trigger $endTrigger -ScriptBlock {Clear-ADAccountExpiration -Identity $adUsername} 

} else {
    Write-Host "Script execution aborted."
}