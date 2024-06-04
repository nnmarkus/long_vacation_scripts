Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$rootDir="C:\scripts\long_vacation_scripts\"
$username

function Show-DateTimePickerForm {
    param (
        [string]$title
    )

    $form = New-Object Windows.Forms.Form -Property @{
        StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
        Size          = New-Object Drawing.Size 275, 350
        Text          = $title
        Topmost       = $true
    }

    $datePicker = New-Object Windows.Forms.MonthCalendar -Property @{
        ShowTodayCircle   = $false
        MaxSelectionCount = 1
        Location          = New-Object Drawing.Point 10, 10
    }
    $form.Controls.Add($datePicker)

    $timePicker = New-Object Windows.Forms.DateTimePicker -Property @{
        Format    = [Windows.Forms.DateTimePickerFormat]::Time
        ShowUpDown = $true
        Location  = New-Object Drawing.Point 10, 200
    }
    $form.Controls.Add($timePicker)

    $okButton = New-Object Windows.Forms.Button -Property @{
        Location     = New-Object Drawing.Point 38, 240
        Size         = New-Object Drawing.Size 75, 23
        Text         = 'OK'
        DialogResult = [Windows.Forms.DialogResult]::OK
    }
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $cancelButton = New-Object Windows.Forms.Button -Property @{
        Location     = New-Object Drawing.Point 113, 240
        Size         = New-Object Drawing.Size 75, 23
        Text         = 'Cancel'
        DialogResult = [Windows.Forms.DialogResult]::Cancel
    }
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)

    $result = $form.ShowDialog()

    if ($result -eq [Windows.Forms.DialogResult]::OK) {
        $selectedDate = $datePicker.SelectionStart
        $selectedTime = $timePicker.Value.TimeOfDay
        $selectedDateTime = [DateTime]::new($selectedDate.Year, $selectedDate.Month, $selectedDate.Day, $selectedTime.Hours, $selectedTime.Minutes, $selectedTime.Seconds)
        return $selectedDateTime.ToString('MM/dd/yyyy HH:mm:ss')
    } else {
        return $null
    }
}

function Check-AD-Username {
    param (
        [string]$username
    )

    # Check if the username is null or empty
    if ([string]::IsNullOrEmpty($username)) {
        Write-Host "Username cannot be blank. Please re-enter username"
        exit;
    }

    try { 
        Get-ADUser -Identity $username -ErrorAction Stop
        Write-Host "Valid user: $username"
    } catch {
        Write-Host "Invalid username. Please verify this is the logon id / username for the account"
        exit;
    }
}


# Gets the first date/time via GUI popup (Start of long vacation)
$form1Result = Show-DateTimePickerForm -title 'Start of long vacation.'
if ($form1Result) {
    Write-Output "Start of long vacation: $form1Result"
    
    # Gets the second date/time via GUI popup (End of long vacation)
    $form2Result = Show-DateTimePickerForm -title 'End of long vacation.'
    if ($form2Result) {
        Write-Output "End of long vacation: $form2Result"


        # Validates username is valid. 
        try {
            # Get the username for the person going on the long vacation.
            $username = Read-Host "Enter Active Directory username"
            Check-AD-Username -user $username

            # Gets the RSM Case number for scheduled task name
            try {
                $csNumber = Read-Host "Enter RSM Case number"
                Write-Output "Case number: $csNumber"

                # Gets confirmation on the information entered. 
                Write-Output "************************************************************"
                Write-Output "*     Please review for accuracy before proceeding         *"
                Write-Output "*         To cancel, enter 'N' or press CTRL+C             *"
                Write-Output "************************************************************"
                $confirmation = Read-Host "You are about to schedule an account lockout for:`nAD User:`t`t$username`nStarting:`t`t$form1Result`nEnding:`t`t`t$form2Result.`nCase:`t`t`t$csNumber`n`nAre you sure you want to proceed (Y/N)?"
                
                # If confirmation was yes, continue. 
                if ($confirmation -eq 'Y' -or $confirmation -eq 'y') {
                    Write-Output "Confirmation dialog confirmed, setting account expiration and scheduled task to unexpire account."
                    
                    # Set account expiration
                    try {
                        $triggerTime = Get-Date $form1Result -Format "yyyy-MM-dd HH:mm:ss"
#                        $taskFolderPath = "\LongVacation"
#                        $fullFilePath="$rootDir"+"longVacationStart.ps1"
#                        $action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-File $fullFilePath -user $username"
#                        $trigger = New-ScheduledTaskTrigger -Once -At $triggerTime
#                        $taskName = "$username"+"_"+"$csNumber"+"_"+"START"
#                        Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "$taskName" -TaskPath $taskFolderPath -User "System" -RunLevel Highest

                        $currentDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                        $timeSpan = New-TimeSpan -Start $currentDateTime -End $triggerTime
                        Set-ADAccountExpiration -Identity $username -TimeSpan $timeSpan

                        Write-Host "Set account expiration"

                        # Create the sceduled task to re-enable the user
                        try {
                            $taskFolderPath = "\LongVacation"
                            $fullFilePath="$rootDir"+"longVacationEnd.ps1"
                            $action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-File $fullFilePath -user $username"
                            $triggerTime = Get-Date $form2Result -Format "yyyy-MM-dd HH:mm:ss"
                            $trigger = New-ScheduledTaskTrigger -Once -At $triggerTime
                            $taskName = "$username"+"_"+"$csNumber"+"_"+"END"
                            Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "$taskName" -TaskPath $taskFolderPath -User "System" -RunLevel Highest


                            
                            # Script finished
                            Write-Host "Finished setting account expiration and scheduled task."
                            Write-Output "************************************************************"
                            Write-Output "*     Please take a screenshot of this page exiting        *"
                            Write-Output "*            Upload screenshot to DASH case                *"
                            Write-Output "************************************************************"
                            Read-Host "Press any key to exit......"
                            Exit;



                            
                        } catch { Write-Output "FAILURE - Failed to set scheduled task to re-enable user." }
                    } catch { Write-Output "FAILURE - Failed to set account expiration." }
                } else { Write-Output "FAILURE - Confirmation dialog Cancelled" }
            } catch { Write-Output "FAILURE - Failed to get case number." }
        } catch { Write-Output "FAILURE - Failed to get AD username." }
    } else { Write-Output "FAILURE - Second Form - Operation Cancelled" }
} else { Write-Output "FAILURE - First Form - Operation Cancelled" }