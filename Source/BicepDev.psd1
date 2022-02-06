#
# Module manifest for module 'BicepDev'
#
# Generated by: Alex Curley
#
# Generated on: 1/17/2022
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule        = 'BicepDev.psm1'

    # Version number of this module.
    ModuleVersion     = '1.0.7'

    # ID used to uniquely identify this module
    GUID              = 'e7b7ad99-9a19-4e02-b062-edc7121103f8'

    # Author of this module
    Author            = 'Alex Curley'

    # Company or vendor of this module
    CompanyName       = 'Unknown'

    # Copyright statement for this module
    Copyright         = 'Copyright (c) 2021 by Alex Curley, all rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'A module for converting parameters and variables in Bicep templates to outputs'

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = '*'

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport   = '*'

    # Variables to export from this module
    VariablesToExport = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport   = '*'

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('Bicep', 'ARM', 'Azure', 'Powershell')

            # A URL to the license for this module.
            LicenseUri   = 'https://opensource.org/licenses/GPL-3.0'

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/justacurley/BicepDev'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes = ''

            # Prerelease string of this module
            Prerelease   = ''

        }
    }
}

