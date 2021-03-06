function Set-Countdown {
    
    <#
    .SYNOPSIS

    Prints a countdown interface to the console.

    .DESCRIPTION
    
    Prints an animated or simple countdown interface to the console.

    .PARAMETER Seconds
        
    This parameter is mandatory. It will be an integer of the number at which to start the countdown.

    .PARAMETER NoAnimation

    If this parameter is switched on, the countdown interface changes to just numbers written to the console.

    .EXAMPLE

    PS>Set-Countdown -Seconds 10

    ><((('> ><> <'(((>< <'(((>< ><> ><((('> ><> ><> <>< ><((('>

    .EXAMPLE

    PS>Set-Countdown -Seconds 10 -NoAnimation

    10 9 8 7 6 5 4 3 2 1

    .INPUTS
       
    None. Does not take pipeline input.

    .OUTPUTS
        
    Console output.
    Nothing is returned from the output stream.
    #>

    [CmdletBinding(DefaultParameterSetName = 'Spinner')]
    Param
    (
        
        [Parameter(
            Mandatory = $true,
            Position = 0    
        )]
        [Int32]
        $Seconds,

        [Parameter(ParameterSetName = 'Numbers')]
        [Switch]
        $Numbers,

        [Parameter(ParameterSetName = 'Spinner')]
        [Switch]
        $Spinner,

        [Parameter(ParameterSetName = 'Fish')]
        [Switch]
        $Fish
    )
    begin {

        [Int32]$count = 0 # Count increments by 1 after Start-Sleep -seconds 1
        $colors = @("red", "green", "yellow", "cyan", "magenta", "white") # list of colors to randomize with -foregroundcolor

    }
    process {
        
        if ($PSCmdlet.ParameterSetName -eq 'Spinner') {

            $spinnerElements = @('|', '/', '-', '\')
            $spinnerIndex = 0
            do 
            {

                $spinnerTimer = New-Object System.Double
                while ([System.Math]::Floor($spinnerTimer) -ne 1) {

                    [String]$fgcolor = Get-Random -InputObject $colors -Count 1 # Pull a random color from $colors
                    Write-Host "`r$($spinnerElements[$spinnerIndex])" -NoNewline -ForegroundColor $fgcolor
                    Start-Sleep -Milliseconds 100
                    $spinnerTimer += 0.10
                    if ($spinnerIndex -ne 3) {

                        $spinnerIndex++

                    }
                    else {

                        $spinnerIndex = 0
                        
                    }
                    
                    if ([System.Math]::Floor($spinnerTimer) -eq 1) {

                        $Seconds--

                    }

                }

            }
            until ($Seconds -eq $count)

            Write-Host "`r" -NoNewline

        }
        elseif ($PSCmdlet.ParameterSetName -eq 'Numbers') {
            
            [Int32]$initialValue = $Seconds
            do {
                
                if ($Seconds -eq $initialValue -or $Seconds -gt ($initialValue - 10)) {

                    <# Since $Seconds % 10 -eq 0 could be true from the onset
                    Set $initialValue to $Seconds to ensure we don't evaluate to true
                    And, prevent $Seconds % 10 -eq 0 from evaluating to true
                    until a full line of 10 has been processed
                    Eg. If $Seconds -eq 21
                    #>
                    Write-Host "$Seconds " -NoNewline
                    Start-Sleep -Seconds 1
                    $Seconds--

                } 
                elseif ($Seconds % 10 -eq 0) {
                    
                    Write-Host "$Seconds "
                    Start-Sleep -Seconds 1
                    $Seconds--

                } 
                else {
                
                    Write-Host "$Seconds " -NoNewline
                    Start-Sleep -Seconds 1
                    $Seconds--

                }

            } 
            Until ($Seconds -eq $count)

            Write-Host "" # Line break at end

        } 
        else {
            
            $fishPics = ("><((('> ", "><> ", "<'(((>< ", "<>< ")
            do
            {
                
                [String]$fgcolor = Get-Random -InputObject $colors -Count 1 # Pull a random color from $colors
                [String]$write = Get-Random -InputObject $fishPics -Count 1 # Pull a random fish from $fishPics
                if ($count -ne 0 -and $count % 10 -eq 0) { 
            
                    # 0 mod 10 does equal 0, so had to add $count not equal to 0
                    # to allow the counter animation to increment to a number that is not 0 but still equals 0 when mod 10
                    Write-Host "" # Line break

                } 
                else {

                    Write-Host "$write" -NoNewline -ForegroundColor $($fgcolor) 

                }
        
                Start-Sleep -Seconds 1 # Stop execution for 1 second

                $count++ # Increment $count by 1
            }
            Until ($count -eq $Seconds) # Run this code block until until $count is equal to 180 (3 minutes, since the start-sleep function sleeps 1 second)

            Write-Host "" # Line break at end

        }

    }

}
