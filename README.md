## ProcessPriority

A simple PowerShell module with one purpose: to simplify setting process priority on Windows.

## Installation

```powershell
Install-Module -Name ProcessPriority -Scope CurrentUser -Force
```

## Usage

There is a single command in this module, which sets process priority by process name.

```powershell
Set-ProcessPriority -Name blender.exe -Priority BelowNormal
```

