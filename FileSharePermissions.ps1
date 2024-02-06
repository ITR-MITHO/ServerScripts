$FolderPath = Get-ChildItem -Directory -Path \\Server\Share -Recurse -Force -ErrorAction SilentlyContinue
$Report = @()
Foreach ($Folder in $FolderPath) {
    $Acl = Get-Acl -Path $Folder.FullName -ErrorAction SilentlyContinue
    foreach ($Access in $acl.Access)
        {
            $Properties = [ordered]@{'FolderName'=$Folder.FullName;'ADGroup or User'=$Access.IdentityReference;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited;'LastAccess'=$Folder.LastAccessTime}

            $Report += New-Object -TypeName PSObject -Property $Properties
        }
}
$Report | Export-Csv -path "C:\Users\$ENV:USERNAME\Desktop\Sharename.csv" -NoTypeInformation -Encoding Unicode
