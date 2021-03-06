function Remove-InvalidCharacters {

    <#
    .SYNOPSIS

    Removes prohibited characters from an input string.

    .DESCRIPTION
    
    Removes prohibited characters from an input string based on selected output type.

    .PARAMETER String
        
    This parameter is mandatory. It can be passed down the pipeline or to the parameter.

    .PARAMETER FileNameFormat

    Removes characters from a string, making it compatible for use as a file name.

    .PARAMETER EmailAddressFormat

    Removes characters from a string, making it compatible for use as an email address.

    .PARAMETER PhoneNumberFormat

    Removes characters from a string, making it compatible for use as a phone number.

    .EXAMPLE

    PS>Remove-InvalidCharacters -String "This !@#$%^&*()-_=+[{}]\|;:',<.>/?0123456789 is my string" -FileNameFormat

    This!@#$%^&()-_=+[{}]\',.0123456789ismystring

    .EXAMPLE

    PS>Remove-InvalidCharacters -String "ThisIsMyEmail!#$%^&*()-_=+[{}]\|;:',<.>/?0123456789@testemail.com" -EmailAddressFormat
    
    ThisIsMyEmail-_.0123456789@testemail.com

    .EXAMPLE

    PS>Remove-InvalidCharacters -String "1?555?444?3121" -PhoneNumberFormat

    15554443121

    .INPUTS
       
    System.String

    .OUTPUTS
        
    System.String
    #>

    [CmdletBinding()]
    Param (

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true)]
        [string]
        $String,

        [Parameter(ParameterSetName = 'File')]
        [switch]
        $FileNameFormat,

        [Parameter(ParameterSetName = 'Email')]
        [switch]
        $EmailAddressFormat,

        [Parameter(ParameterSetName = 'Phone')]
        [switch]
        $PhoneNumberFormat

    )
    process {
        
        <# The regex pattern in the square brackets defines which characters will be allowed

            '[^\w\.@-]'
            
            Inside the square brackets the following is defined:
            ----------------------------------------------------
            ^ = not
            \w = a word character: a-z, A-Z, 0-9, _
            \. = literal period (escaped by a backslash to be interpreted literally)
            @ = at sign

            Effectively, replace anything that is NOT these

            To allow additional characters in user input, 
            add those characters to the regular expression pattern. 
            For example, the regular expression pattern [^\w\.@-\\%] 
            also allows a percentage symbol and a backslash in an input string.    

        #>

        if ($FileNameFormat) {

            [string]$Output = $String -replace "[^\w\.\@\-\!\#\$\%\^\&\(\)\=\+\[\]\{\}\,\`\~\']", ''   

        } elseif ($EmailAddressFormat) {

            [string]$Output = $String -replace '[^\w\.@-]', ''

        } elseif ($PhoneNumberFormat) {
            
            [string]$Output = $String -replace '[^ \(\)\w\d\.\-\+]', '' -replace '^ ','' -replace ' $', '' # Replace spaces if the string begins or ends with one

        }

        return $Output

    }

}
