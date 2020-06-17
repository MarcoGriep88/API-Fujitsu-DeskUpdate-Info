#
#	RUN THIS SCRIPT ON EACH WINDOWS FUJITSU COMPUTER WITH ADMIN PRIVILEGES (GPO, LANSWEEPER ETC)
#	THIS WILL IDENTIFY THE POSSIBLE DRIVER UPDATES FOR THIS MACHINE AND REPORT THEM TO
#	THE API-FUJITSU-DESKUDATE SERVER (YOU NEED FUJITSU DESKUPDATE MANAGER INSTALLED)
#

param( 
    [string]$DeskUpdate = "\\server.intranet.int\DriverDepot$\Projects\DeskupUpdate-2020-02\DeskUpdate\ducmd.exe"
)

class DUMInfo {
    [string]$Hostname
    [string]$Driver
    [string]$UpgradeVersion
}

$apiServer = "https://apiServer.intranet.int"
$hostname = & hostname
$Driver=""
$Version=""
$obj = @([DUMInfo]@{Hostname=$hostname;Driver=$Driver;UpgradeVersion=$Version})
$json = $obj | ConvertTo-Json


Invoke-RestMethod -Method Post -Uri "$($apiServer)/clear" -Body $json -ContentType "application/json"

if ($PSVersionTable.PSVersion.Major -lt 4) {
    Write-Error "Powershell Version 4 required"
    exit 9000
}

if (! (Test-Path $DeskUpdate) ) 
{
    Write-Error "Deskupdate not found"
    exit 9001
}
else
{
    $content = (cmd /c $DeskUpdate' /WEB /LIST')
    
    if ($LASTEXITCODE -eq 0) 
    {
        # extract only installable packages
        $content = ($content.Where({$_ -like "Installable packages:"}, 'SkipUntil').Trim()) | Select-Object -Skip 1
        
        if ($content.Count -gt 0) {
            foreach($e in $content) {
                $IDsplit = $e -Split " - "
                $SoftSplit = $IDsplit[1] -Split ","
                $Driver = $SoftSplit[0].Trim()
                $Version = $SoftSplit[1].Trim().Replace("[version] ", "")

                $obj = @([DUMInfo]@{Hostname=$hostname;Driver=$Driver;UpgradeVersion=$Version})
                $json = $obj | ConvertTo-Json
                Invoke-RestMethod -Method Post -Uri "$($apiServer)/create" -Body $json -ContentType "application/json"
            }            
        }
    } else {
        # return code deskupdate
        Write-Error "Program terminated with errorcode $($LASTEXITCODE) - check Ducmd.exe /E for more information"
        exit $LASTEXITCODE
    }
}
