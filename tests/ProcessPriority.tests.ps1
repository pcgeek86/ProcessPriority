#requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0' }

#Install-Module -Name Pester -Scope CurrentUser -Force
Import-Module -Name $PSScriptRoot/../src/ProcessPriority -Force

Describe "ProcessPriority Intellisense functionality" {
    It 'Should return quoted System Idle Process' {
        $Script = 'Set-ProcessPriority -Name '
        $Result = TabExpansion2 -inputScript $Script -cursorColumn $Script.Length
        $Result.CompletionMatches.CompletionText | Should -Contain "'System Idle Process'"
    }

    It 'Should return System process' {
        $Script = 'Set-ProcessPriority -Name sys'
        $Result = TabExpansion2 -inputScript $Script -cursorColumn $Script.Length
        $Result.CompletionMatches.CompletionText | Should -Contain System
    }
}

Describe 'Set-ProcessPriority parameter validation' {
    It "Should fail on unknown process name" {
        {Set-ProcessPriority -Name unknownprocessasdfasdf.exe -Priority BelowNormal } | Should -Throw
    }
    It 'Should fail when no priority is specified, for a valid process name' {
        { 
            $ScriptBlock = {
                Import-Module -Name $args[0]
                Set-ProcessPriority -Name System
            }
            Start-Job -ScriptBlock $ScriptBlock -ArgumentList $HOME/git/ProcessPriority/src/ProcessPriority | Wait-Job | Receive-Job 
        } | Should -Throw
    }
}

Describe 'Set-ProcessAffinity tests' {
    It 'Should fail when too many cores are specified' {
        { Set-ProcessAffinity -Name blender -Cores 24..30 } | Should -Throw
    }
    It 'Should succeed when more than one core is specified' {
        { Set-ProcessAffinity -Name blender -Cores 6,3,8,9 } | Should -Not -throw
    }
    It 'Should fail when the process is not found' {
        { Set-ProcessAffinity -Name idonotexist -Cores 2,6,7 } | Should -Throw
    }
    It 'Should succeed when the highest core is selected' {
        {
            $ThreadCount = Get-CimInstance -ClassName Win32_Processor | Measure-Object -Sum -Property ThreadCount | Select-Object -ExpandProperty Sum
            Set-ProcessAffinity -Name blender -Cores $ThreadCount
        } | Should -Not -Throw
    }
    It 'Should succeed when the lowest core is selected' {
        {
            Set-ProcessAffinity -Name blender -Cores 1
        } | Should -Not -Throw
    }
}