function Update-PSGalleryModules {

    <#
    .SYNOPSIS

    Updates modules installed solely from PS Gallery.

    .DESCRIPTION
    
    Updates modules installed solely from PS Gallery.
    Attempts to always find a version number of every module and search for a version number greater than that one.

    .EXAMPLE

    PS>Update-PSGalleryModules
  
    .INPUTS
       
    None. Does not take pipeline input.

    .OUTPUTS
        
    Console output.
    Nothing is returned from the output stream.
    #>
        
    [CmdletBinding()]
    param(

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ExceptTheseModules

    )
    
    process{

        Write-Host "`nNow checking for updates for any modules installed from PSGallery" -ForegroundColor Green
        Write-Warning -Message "Unable to automatically update modules that weren't installed using the Install-Module API"
        
        # Get all modules installed on the system and sort them by version and grab the latest version number for each
        $userScopeBase = $env:PSModulePath.Split(";") | Where-Object { $_ -like "$env:USERPROFILE*" }
        $modulesFromPSGallery = @()
        Get-Module -Refresh -ListAvailable |
        Where-Object { $_.ModuleBase -like "$userScopeBase*" -and $_.RepositorySourceLocation -eq 'https://www.powershellgallery.com/api/v2' } |
        Sort-Object Version -Descending | 
        ForEach-Object { if ($_.Name -notin $modulesFromPSGallery.Name) { $modulesFromPSGallery += $_ } }

        if ($ExceptTheseModules) {

            $ExceptTheseModules.ForEach({ $modulesFromPSGallery = $modulesFromPSGallery | Where-Object { $_.Name -ne "$_" -or $_.Name -notlike "$_.*" } })

        }

        $modulesFromPSGallery = $modulesFromPSGallery | Sort-Object Name
       
        $scriptBlock = { # Define script block to be used with jobs below

            $module = $args
            $newerModule = Find-Module -Name $module.Name -ErrorAction SilentlyContinue | 
                Where-Object { [version]$_.Version -gt [version]$module.Version } | 
                    Sort-Object Version -Descending | 
                        Select-Object -First 1

            if ($newerModule) {
                
                try {
                        
                    Install-Module `
                    -Name $module.Name `
                    -RequiredVersion $newerModule.Version.ToString() `
                    -Scope CurrentUser `
                    -AllowClobber `
                    -Force `
                    -WarningAction SilentlyContinue `
                    -ErrorAction Stop
                    
                    Write-Output "Updated $($module.Name) to version: $($newerModule.Version.ToString())"

                }
                catch {

                    $_ | Write-Error

                }

                

            }

        }
        
        $allUpdateModuleJobs = @()
        $completed = @()
        $workingSet = $modulesFromPSGallery | Select-Object -First 10
        Write-Progress -Activity "Waiting for all module update jobs to complete before proceeding." -PercentComplete 0
        While ($completed.Count -ne $modulesFromPSGallery.Count) {
            
            $workingSet | ForEach-Object {

                $currentJobSet = @()

                $module = $_
                $moduleName = $_.Name
                Write-Host "Starting a background job to update module: " -NoNewline
                Write-Host $moduleName -ForegroundColor Green

                $newJob = Start-Job -Name "Updating $moduleName" -ScriptBlock $scriptBlock -ArgumentList $module
                $currentJobSet += $newJob
                $allUpdateModuleJobs += $newJob

            }

            $currentJobSet | Wait-Job | Out-Null
            $completed += $workingSet

            $percentComplete = ($completed.Count / $modulesFromPSGallery.Count) * 100
            Write-Progress -Activity "Waiting for all module update jobs to complete before proceeding." -PercentComplete $percentComplete
            
            $workingSet = $modulesFromPSGallery | Where-Object { $_.Name -notin $completed.Name } | Select-Object -First 10

        }

        Write-Progress -Activity "Waiting for all module update jobs to complete before proceeding." -Completed
        
        $jobResults = $allUpdateModuleJobs | Receive-Job
        if ($jobResults) {

            Write-Host $jobResults -Separator "`n" -ForegroundColor Green

        }
        else {

            Write-Host "All modules up to date!" -ForegroundColor Green

        }
        
    }

}
