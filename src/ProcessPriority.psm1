function Set-ProcessPriority {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'ProcessName')]
        [ValidateScript({ (Get-CimInstance -ClassName Win32_Process).Name -contains $PSItem })]
        [string] $Name,
        [Parameter(Mandatory = $true, ParameterSetName = 'ProcessName')]
        [ValidateSet('Idle', 'BelowNormal', 'AboveNormal', 'High', 'Realtime')]
        [string] $Priority
    )

    # Documentation here: https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/setpriority-method-in-class-win32-process
    $PriorityMapping = @{
        Idle = 64
        BelowNormal = 16384
        Normal = 32
        AboveNormal = 32768
        High = 128
        Realtime = 256
    }

    $ProcessList = Get-CimInstance -ClassName Win32_Process -Filter "Name = '$Name'"

    foreach ($Process in $ProcessList) {
        Invoke-CimMethod -InputObject $Process -MethodName SetPriority -Arguments @{ Priority = $PriorityMapping.$Priority }
        Write-Verbose -Message ('Set process priority to {0} for process ID {1}' -f $Priority, $Process.ProcessId)
    }
}

function Set-ProcessAffinity {
    <#
    .Synopsis
    Sets processor affinity for a given process.

    .Parameter Name
    The name of the process whose affinity will be updated.

    .Parameter Cores
    The array of processor cores that will be assigned to the process.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'ProcessName')]
        [ValidateScript({ (Get-Process).Name -contains $PSItem })]
        [string] $Name,
        [Parameter(Mandatory = $true, ParameterSetName = 'ProcessName')]
        [ValidateScript({
            foreach ($item in $PSItem) {
                $MaxCores = Get-CimInstance -ClassName Win32_Processor | Measure-Object -Sum -Property ThreadCount | Select-Object -ExpandProperty Sum
                if ($PSItem -gt $MaxCores) {
                    throw 'Not enough cores'
                }
            }
            $true
        })]
        [int[]] $Cores
    )

    $Affinity = $Cores | ForEach-Object -Begin { $Affinity = 0x0 } -Process  { $Affinity = $Affinity -bor ([Math]::Pow(2, $PSItem)-1) } -End { $Affinity }
    $ProcessList = Get-Process -Name $Name
    foreach ($Process in $ProcessList) {
        Write-Verbose -Message ('Setting process affinity for {0} to {1}' -f $Process.Id, $Affinity)
        $Process.ProcessorAffinity = [System.IntPtr]::new($Affinity)
    }
}

Register-ArgumentCompleter -CommandName Set-ProcessPriority -ParameterName Name -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $ProcessList = (Get-CimInstance -ClassName Win32_Process).Name | Select-Object -Unique

    # Update array with quoted process names, if it has spaces
    foreach ($Process in $ProcessList) {
        $ProcessList[$ProcessList.IndexOf($Process)] = ($Process -match '\s') ? "'$Process'" : $Process
    }
    
    $wordToComplete ? $ProcessList -match $wordToComplete : $ProcessList
}

Register-ArgumentCompleter -CommandName Set-ProcessAffinity -ParameterName Name -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $ProcessList = (Get-Process).Name | Select-Object -Unique

    # Update array with quoted process names, if it has spaces
    foreach ($Process in $ProcessList) {
        $ProcessList[$ProcessList.IndexOf($Process)] = ($Process -match '\s') ? "'$Process'" : $Process
    }
    
    $wordToComplete ? $ProcessList -match $wordToComplete : $ProcessList
}
