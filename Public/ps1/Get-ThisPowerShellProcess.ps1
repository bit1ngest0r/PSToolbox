function Get-ThisPowerShellProcess {

    [CmdletBinding()]
    Param()

    <# 
    To determine if PowerShell is running in VS code the following must be evaluated
    VS code can be identified by examining three PowerShell processes:
        Example 1: The code runner button is used to call this script to identify the PowerShell parent process
            1. First process identified: The shell that is spawned every time you press the code run button ("C:\windows\System32\WindowsPowerShell\v1.0\powershell.exe" -ExecutionPolicy ByPass -File "C:\Some\PowerShell\File.ps1"")
            2. Second process identified: The interactive shell below the code area that exists before and after code runs (powershell.exe)
            3. Third process identified: The parent VS code process which calls the interactive shell (winpty-agent)
        
        Example 2: The cmdlet or function is called directly from the interactive shell below the code screen
            1. First process identified: The interactive shell below the code area that exists before and after code runs (powershell.exe)
            2. Second process identified: The parent VS code process which calls the interactive shell (winpty-agent)
            3. Third process identified: The parent VS code process which calls the winpty-agent (code.exe)
    #>
    $shell = Get-CimInstance -ClassName Win32_Process | Where-Object { $_.ProcessId -eq $PID }
    $shellOwner = Get-CimInstance -ClassName Win32_Process | Where-Object { $_.ProcessId -eq $shell.ParentProcessId }
    $mainOwner = Get-CimInstance -ClassName Win32_Process | Where-Object { $_.ProcessId -eq  $shellOwner.ParentProcessId }
    if ($mainOwner.Name -eq 'code.exe' -or $mainOwner.Name -eq 'winpty-agent.exe') { # See note above

        if ($mainOwner.Name -eq 'winpty-agent.exe') { # Script was called using code runner, run this block to ID the code.exe process

            $vsCodeEnvProc = Get-CimInstance -ClassName Win32_Process | Where-Object { $_.ProcessId -eq  $mainOwner.ParentProcessId } # The VS code environment
            $vsCodeParentProc = Get-CimInstance -ClassName Win32_Process | Where-Object { $_.ProcessId -eq  $vsCodeEnvProc.ParentProcessId } # The actual VS code parent process
            $process = Get-Process -Id $vsCodeParentProc.ProcessId
            return $process
            
        } else { # This is the code.exe environment process, run this block

            $vsCodeParentProc = Get-CimInstance -ClassName Win32_Process | Where-Object { $_.ProcessId -eq  $mainOwner.ParentProcessId } # The actual VS code parent process
            $process = Get-Process -Id $vsCodeParentProc.ProcessId
            return $vsCodeParentProc
        
        }
        
    } elseif ($shell.Name -eq 'powershell.exe') {
        
        $process = Get-Process -Id $shell.ProcessId
        return $process
        
    } elseif ($shell.Name -eq 'powershell_ise.exe') {

        $process = Get-Process -Id $shell.ProcessId
        return $process
        
    } else {

        Write-Error "PowerShell process could not be determined using identifiable process attributes."
        
    }

}
