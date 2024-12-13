Param(
    #The path that contains the comic folders
    [Parameter(Mandatory)]
    [string]
    $Path,
    # The compression type
    [Parameter(Mandatory)]
    [string]
    $Type
)


$folders = Get-ChildItem -Path $Path -Directory | Select-Object FullName

Write-Host "You are about to compress all sub folders of $Path to the type $Type"
Write-Host "There are $($folders.count ) folders in the path"

If (-Not $folders.count -eq 0) {
    $confirmation = Read-Host "Ready? [y/n]"

    while ($confirmation -ne "y") {
        if ($confirmation -eq 'n') { exit }
        $confirmation = Read-Host "Ready? [y/n]"
    }
}

foreach ($folder in $folders) {
    [string]$folderName = $folder.FullName
    Write-Host $folderName
    [string]$compressedName = $($folderName + ".zip")
    [string]$convertedName = $($folderName + "." + $Type)

    [bool]$isFolderConverted = Test-Path -Path $convertedName

    If ($isFolderConverted) {
        Write-Host "Folder already converted."
    }
    else {
        Write-Host "Compressing ..."
        Compress-Archive -Path $folderName -DestinationPath $compressedName
        Write-Host "Successfully compressed file to: $compressedName"
        Write-Host "Converting $compressedName to the type: $Type ..."
        Move-Item -Path $compressedName -Destination $convertedName
        Write-Host "Successfully saved the file: $convertedName"
    }
}

