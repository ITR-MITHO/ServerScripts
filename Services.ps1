<#

Checks the startup type for all windows services corrosponding to a freshly installed Windows Server 2019
List of services and state can be found here: https://raw.githubusercontent.com/ITR-MITHO/ServerScripts/main/Services.csv

#>
# Create CSV based on Windows Server 2019
$CSVURL = "https://raw.githubusercontent.com/ITR-MITHO/ServerScripts/main/Services.csv"
$fileContent = Invoke-RestMethod -Uri $CSVURL
$fileContent | Out-File -FilePath "$home\desktop\Services.csv"

timeout 5 | Out-Null
$Data = Import-csv $home\desktop\Services.csv
Foreach ($D in $Data)
{
$Service = $D.Servicename
$Startup = $D.Startup
$DisplayName = $D.Name
If (-not (Get-Service $Service -ErrorAction SilentlyContinue | Where {$_.StartType -EQ "$Startup"}))
{
Write-host "$DisplayName - IS NOT -  $Startup" -ForegroundColor Red
}
    }
