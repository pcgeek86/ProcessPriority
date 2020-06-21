## ProcessPriority

A simple PowerShell module with one purpose: to simplify setting process priority on Windows.

## Installation

```powershell
Install-Module -Name ProcessPriority -Scope CurrentUser -Force
```

## Usage

### Set Process Priority

You can set process priority by process name.

```powershell
Set-ProcessPriority -Name blender.exe -Priority BelowNormal
```

### Set Process Affinity

You can limit which CPU cores (including Symmetric Multi-threading (SMT) threads) a process is allowed to run on.

```powershell
Set-ProcessAffinity -Name blender -Cores 2,20
```

