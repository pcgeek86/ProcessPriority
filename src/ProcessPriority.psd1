@{
    # If authoring a script module, the RootModule is the name of your .psm1 file
    RootModule = 'ProcessPriority.psm1'

    Author = 'Trevor Sullivan <trevor@trevorsullivan.net>'

    CompanyName = 'Art of Shell'

    ModuleVersion = '0.2'

    # Use the New-Guid command to generate a GUID, and copy/paste into the next line
    GUID = '4cac7623-984f-4614-b6e6-8fe23049b58d'

    Copyright = '2020 Trevor Sullivan'

    Description = 'Sets process priority on a Windows system'

    # Minimum PowerShell version supported by this module (optional, recommended)
    PowerShellVersion = '5.1'

    # Which PowerShell Editions does this module work with? (Core, Desktop)
    CompatiblePSEditions = @('Desktop', 'Core')

    # Which PowerShell functions are exported from your module? (eg. Get-CoolObject)
    FunctionsToExport = @(
        'Set-ProcessPriority'
        'Set-ProcessAffinity'
        )

    # Which PowerShell aliases are exported from your module? (eg. gco)
    AliasesToExport = @('')

    # Which PowerShell variables are exported from your module? (eg. Fruits, Vegetables)
    VariablesToExport = @('')

    # PowerShell Gallery: Define your module's metadata
    PrivateData = @{
        PSData = @{
            # What keywords represent your PowerShell module? (eg. cloud, tools, framework, vendor)
            Tags = @('Windows')

            # What software license is your code being released under? (see https://opensource.org/licenses)
            LicenseUri = ''

            # What is the URL to your project's website?
            ProjectUri = ''

            # What is the URI to a custom icon file for your project? (optional)
            IconUri = ''

            # What new features, bug fixes, or deprecated features, are part of this release?
            ReleaseNotes = @'
'@
        }
    }

    # If your module supports updateable help, what is the URI to the help archive? (optional)
    # HelpInfoURI = ''
}