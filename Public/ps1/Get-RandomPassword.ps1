function Get-RandomPassword {

    <#
    .SYNOPSIS

    Generates a random password string of variable length.

    .DESCRIPTION
    
    Generates a random password string between 8 - 32 characters long.
    Can specify whether or not to use special characters in the string.

    .PARAMETER Length

    This parameter is mandatory.
    Takes an integer between 8 - 32 to determine the string length.

    .PARAMETER NoSpecialCharacters

    If switched on, will only return a string of uppercase, lowercase, and number characters
            
    .EXAMPLE

    PS>Get-RandomPassword -Length 15

    !XkTd7wG9P5XJL#

    .EXAMPLE

    PS>Get-RandomPassword -Length 15 -NoSpecialCharacters

    GO8pUoppUUCLhY5

    .INPUTS
       
    None. Does not take pipeline input.

    .OUTPUTS
        
    System.String
    #>

    [CmdletBinding()]
    [alias("password", "grpw")]
    Param (

        [Parameter(Mandatory = $true)]
        [ValidateRange(8,32)]
        [int]
        $Length,

        [switch]
        $NoSpecialCharacters

    )
    begin {

        $lowerLetters = 97..122 | ForEach-Object { [char][byte]$_ -as [string] }
        $upperLetters = $lowerLetters | ForEach-Object { $_.ToUpper() }
        $numbers = 0..9 | ForEach-Object { $_.ToString() }
        $specialCharacters = ('!', '@', '#', '$', '%', '^', '&', '*')

    }
    process {

        if ($NoSpecialCharacters) { 
            
            [Array]$characterSet = $lowerLetters + $upperLetters + $numbers
            do {
            
                $password = @()
                while ($password.Length -ne $Length) {
                    do { $char = $characterSet | Get-Random } until ($char -cne $password[-1]) # Don't want the same char back to back
                    $password += $char
                }
                $lowerCheck = ($password | Where-Object { $_ -cin $lowerLetters }).Count -ge 2
                $upperCheck = ($password | Where-Object { $_ -cin $upperLetters }).Count -ge 2
                $numbersCheck = ($password | Where-Object { $_ -in $numbers }).Count -ge 2

            } until ($lowerCheck -and $upperCheck -and $numbersCheck)
        
        }
        else {

            [Array]$characterSet = $lowerLetters + $upperLetters + $numbers + $specialCharacters
            do {
            
                $password = @()
                while ($password.Length -ne $Length) {
                    do { $char = $characterSet | Get-Random } until ($char -cne $password[-1]) # Don't want the same char back to back
                    $password += $char
                }
                $lowerCheck = ($password | Where-Object { $_ -cin $lowerLetters }).Count -ge 2
                $upperCheck = ($password | Where-Object { $_ -cin $upperLetters }).Count -ge 2
                $numbersCheck = ($password | Where-Object { $_ -in $numbers }).Count -ge 2
                $specialCheck = ($password | Where-Object { $_ -in $specialCharacters }).Count -ge 2

            } until ($lowerCheck -and $upperCheck -and $numbersCheck -and $specialCheck)

        }        

    }
    end {

        return $password -join ''

    }

}
