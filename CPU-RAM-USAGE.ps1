# Static variables
$Computername = Hostname
$Date = (Get-Date -Format "dd/MM/yyyy HH:mm:ss")

# CPU Measurement / Threshhold = 85%
$Processor = (Get-WmiObject -Class win32_processor -ErrorAction Stop | Measure-Object -Property LoadPercentage -Average | Select-Object Average).Average
If ($Processor -GT 85)
{
$CPUFile = Test-Path "\\domain.com\SHARE\CPU.csv"
If (-Not $CPUFile)
{
Echo "Timestamp, Server, CPULoad, Process, User"
}

$CPUProcesses = Get-Process | Sort-Object CPU -Descending | Select-Object -First 3
$CPUProcesses | ForEach-Object {
$CPUOwner = (Get-WmiObject -Query "SELECT * FROM Win32_Process WHERE ProcessId=$($_.Id)").GetOwner()
$TopCPUProcess =  $($_.ProcessName) 
$TopCPUUser = $($CPUowner.User)
Echo "$Date, $Computername, $Processor%, $TopCPUprocess, $TopCPUUser"

}
    }

    # RAM Measurement / Threshold = 85%
$RAMProcesses = Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 3
$ComputerMemory = Get-WmiObject -Class win32_operatingsystem -ErrorAction Stop
$Memory = ((($ComputerMemory.TotalVisibleMemorySize - $ComputerMemory.FreePhysicalMemory)*100)/ $ComputerMemory.TotalVisibleMemorySize)
$RoundMemory = [math]::Round($Memory, 2)

If ($RoundMemory -GT 85)
{
$RAMFile = Test-Path "\\domain.com\SHARE\RAM.csv"
If (-Not $RAMFile)
{
Echo "Timestamp, Server RAMLoad, Process, User"
}

$RAMProcesses | ForEach-Object {
$RAMOwner = (Get-WmiObject -Query "SELECT * FROM Win32_Process WHERE ProcessId=$($_.Id)").GetOwner()
$TopRAMProcess =  $($_.ProcessName)
$TopRAMUser = $($RAMowner.User)
Echo "$Date, $Computername, $RoundMemory%, $TopRAMProcess, $TopRamUser"
}
    }
