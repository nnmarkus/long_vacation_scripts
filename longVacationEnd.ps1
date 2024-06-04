# Disable-ADUser.ps1

# Example: .\longVacationEnd.ps1 -user "example_user"


param(
    [Parameter(Mandatory=$true)]
    [string]$user
)

# Import the Active Directory module
Import-Module ActiveDirectory

# Disable the user account
Enable-ADAccount -Identity $user

Write-Output "User $user has been disabled."