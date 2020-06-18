#requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0' }

#Install-Module -Name Pester -Scope CurrentUser -Force
Import-Module -Name $PSScriptRoot/../src/ProcessPriority

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

