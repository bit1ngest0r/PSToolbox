function Get-PSElevationStatus {

    $os = Get-HostOperatingSystem -ErrorAction SilentlyContinue
    if ($os.OS -eq 'Windows') {

        $administratorRole = [Security.Principal.WindowsBuiltInRole]::Administrator
        $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
        $windowsPrincipal = New-Object Security.Principal.WindowsPrincipal($currentUser)
        
        if ($windowsPrincipal.IsInRole($administratorRole)) { return "Elevated" } 
        else { return "NotElevated" }

    }
    else {

        if ($(whoami) -eq 'root') { return "Elevated" }
        else { return "NotElevated" }

    }

}
