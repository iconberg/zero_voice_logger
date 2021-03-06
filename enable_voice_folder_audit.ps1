function AddAuditToFile {
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$path
    )

    Write-Host "Enable audit for ", $path
    $everyone_sid = New-Object System.Security.Principal.SecurityIdentifier("S-1-1-0")
    $PropagationFlag = [System.Security.AccessControl.PropagationFlags]::InheritOnly
    $File_ACL = Get-Acl $path
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAuditRule($everyone_sid,"ReadData”,"ObjectInherit","InheritOnly, NoPropagateInherit","Success")
    $File_ACL.AddAuditRule($AccessRule)
    $File_ACL | Set-Acl $path
}

function GetZeroFolder {
    $file = "user_config.json"
    $path = ""
    
    if (Test-Path $file)
    {
        $config = Get-Content -Path $file
        $path = $config -split('zero_path": ')
        $path = $path[2]
    }
    else
    {
        $path = Read-Host -Prompt 'Input your game path (example "c:\games\ed_zero")'
    }
    return $path.Replace('"', '') + "\\data\\se"
}


$path = GetZeroFolder
AddAuditToFile($path)
