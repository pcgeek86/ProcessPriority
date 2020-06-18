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

Register-ArgumentCompleter -CommandName Set-ProcessPriority -ParameterName Name -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $ProcessList = (Get-CimInstance -ClassName Win32_Process).Name | Select-Object -Unique

    # Update array with quoted process names, if it has spaces
    foreach ($Process in $ProcessList) {
        $ProcessList[$ProcessList.IndexOf($Process)] = ($Process -match '\s') ? "'$Process'" : $Process
    }
    
    $wordToComplete ? $ProcessList -match $wordToComplete : $ProcessList
}
