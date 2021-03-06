function Restart-ProcessAsAdmin {

    [CmdletBinding()]
    [Alias("RunAsAdmin")]
    Param(

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true            
        )]
        [System.Diagnostics.Process]
        $Process

    )

    Start-Process $Process.Path -Verb RunAs
    Stop-Process -Id $Process.Id -Force

}
