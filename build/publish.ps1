# NOTE: Run this script to publish a new version of the module

Copy-Item -Path $PSScriptRoot/../src -Destination ./ProcessPriority -Recurse

$NUGET_API_KEY = Read-Host -Prompt 'Enter NuGet API key: '

Publish-Module -Path ./ProcessPriority -NuGetApiKey $NUGET_API_KEY

Remove-Item -Recurse -Force ./ProcessPriority