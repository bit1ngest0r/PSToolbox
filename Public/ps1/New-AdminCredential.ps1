function New-AdminCredential { # Get adm-XX credentials for use during script runtime

    <#
    .SYNOPSIS

    Prompts the user to enter a username and password and caches the credential.

    .DESCRIPTION
    
    Prompts the user to enter a username and password and caches the credential in a .clixml file in a local directory.
    
    .EXAMPLE

    PS>New-AdminCredential

    UserName                               Password
    --------                               --------
    username@domain.com System.Security.SecureString
    
    .INPUTS
       
    None. Does not take pipeline input.

    .OUTPUTS
        
    System.Management.Automation.PSCredential
    #>


    [CmdletBinding()]
    [Alias("ncred")]
    param()

    $cacheCredential = "$env:LOCALAPPDATA\Microsoft\PowerShell\AdminCredentials\AdminCredentials.clixml"
    
    if (-not(Test-Path -Path $cacheCredential)) { 
        
        Write-Verbose -Message "Cached credential file not found. Creating now."
        New-Item -ItemType File -Path $cacheCredential -Force | Out-Null

    }

    $credentials = Get-Credential -Message "Enter your admin credentials"
    Write-Verbose "Caching new set of admin credentials to: $cacheCredential"
    $credentials | Export-Clixml -Path $cacheCredential
    return $credentials

}
