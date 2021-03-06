function ConvertTo-ProperNounFormat {
    
    <#
    .SYNOPSIS

    Converts a string to proper noun format.

    .DESCRIPTION
    
    Converts a string to proper noun format, capitalizing the first letter of each word.

    .PARAMETER Name

    This parameter is mandatory. This is the string to be manipulated.
            
    .EXAMPLE

    PS>ConvertTo-ProperNounFormat -Name 'john smith'

    John Smith

    .EXAMPLE

    PS>'john jacob jingleheimer schmidt' | ConvertTo-ProperNounFormat

    John Jacob Jingleheimer Schmidt

    .INPUTS
       
    System.String
    Can be passed down the pipeline.

    .OUTPUTS
        
    System.String
    #>

    [CmdletBinding()]
    Param(

        [Parameter(
            Mandatory = $true, 
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string]
        $InputString

    )
    begin {

        $culture = Get-Culture

    }
    process {

        $InputString | ForEach-Object {

            $culture.TextInfo.ToTitleCase($_)

        }

    }

}
