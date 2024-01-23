<#
Run locally on the server you want to perform the check upon. It will find the Top 3 users and processes that uses your CPU and RAM.
Requires elevated permissions, and permissions to write on the fileshare
#>

Echo "Timestamp, Server, CPUinUse, TopCPUProccess, TopCPUUser, RAMinUse, TopRAMProccess, TopRAMUser" | Out-File \\Server\Share\Performance.csv -Encoding unicode
$Processor = (Get-WmiObject -Class win32_processor -ErrorAction Stop | Measure-Object -Property LoadPercentage -Average | Select-Object Average).Average
$ComputerMemory = Get-WmiObject -Class win32_operatingsystem -ErrorAction Stop
$Memory = ((($ComputerMemory.TotalVisibleMemorySize - $ComputerMemory.FreePhysicalMemory)*100)/ $ComputerMemory.TotalVisibleMemorySize)
$RoundMemory = [math]::Round($Memory, 2)

$Computername = Hostname
$Date = (Get-Date -Format "dd/MM/yyyy HH:mm:ss")
        
$CPUProcesses = Get-Process | Sort-Object CPU -Descending | Select-Object -First 3
$RAMProcesses = Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 3

$CPUProcesses | ForEach-Object {
$CPUOwner = (Get-WmiObject -Query "SELECT * FROM Win32_Process WHERE ProcessId=$($_.Id)").GetOwner()
$TopCPUProcess =  $($_.ProcessName) 
$TopCPUUser = $($CPUowner.User)


$RAMowner = (Get-WmiObject -Query "SELECT * FROM Win32_Process WHERE ProcessId=$($_.Id)").GetOwner()
$TopRAMProcess =  $($_.ProcessName)
$TopRAMUser = $($RAMowner.User)

Echo "$Date, $Computername, $Processor, $TopCPUprocess, $TopCPUUser, $RoundMemory, $TopRAMProcess, $TopRamUser" | Out-File \\Server\Share\Performance.csv -Encoding unicode -Append}
