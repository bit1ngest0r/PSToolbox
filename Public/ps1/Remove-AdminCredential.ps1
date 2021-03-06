function Remove-AdminCredential { # Get adm-XX credentials for use during script runtime 

    <#
    .SYNOPSIS

    Removes the locally cached administrator credential.

    .DESCRIPTION
    
    Removes the locally cached administrator credential stored in a .clixml file.
    
    .EXAMPLE

    PS>Remove-AdminCredential
    
    .INPUTS
       
    None. Does not take pipeline input.

    .OUTPUTS
        
    None.
    #>

    [CmdletBinding()]
    [Alias("rcred")]
    Param()
    
    $cacheCredential = "$env:LOCALAPPDATA\Microsoft\PowerShell\AdminCredentials\AdminCredentials.clixml"
    
    Write-Verbose "Removing cached admin credentials from: $cacheCredential"
    Remove-Item $cacheCredential -Force -Confirm:$false -ErrorAction SilentlyContinue
    
}
