$OriginSiteURL = "https://<company-domain>.sharepoint.com/sites/ProjectShareFolder" 

$DestinationSiteURL = "https://<company-domain>.sharepoint.com/sites/Archive-ProjectShareFolder"

Write-host "========================"
Write-Host "Please specify the source folder you would like to move the items from. Please note, that the folder provided will have all items that match the specified date moved from it." -Foregroundcolor Cyan 
Write-host "========================"

$SourceFolder = Read-Host "Source Folder:"
Write-Host "Please specify the destination folder (name of the folder the item wises to be moved to on the other site)"
$DestinationFolder = Read-Host "Destination Folder:" 

Write-Host "================================================" -Foregroundcolor Green
Write-Host "		Gathering Items....		    " -Foregroundcolor Yellow
Write-Host "================================================" -Foregroundcolor Green



$Files = Get-pnpfolder -url "Shared Documents/Project Share Folder" | get-pnpfolderItem |
Where-object { $_.TimeLastModified -lt [DateTime]"12-31-2024"} | Select-object -ExpandProperty Name
	ForEach ($File in $Files) {
		Move-PnPFile -SourceURL "Shared Documents/Project Share Folder/$File" -TargetURL "/sites/Archive-ProjectShareFolder/Shared Documents/Project Share Folder" -Overwrite -Force
		Write-Host "Item $($File.LeafName) successfully moved to Archive Sharepoint site"
		Start-sleep -seconds 3
		$DeletedItem = get-pnprecycleBinItem | Where-object { $_.DeletedByName -like "*TANET Inc*" }
		Write-Host "Found $($DeletedItems.Count) item(s) in recycle bin for TANET Inc." -ForegroundColor Yellow
		ForEach ($Item in $DeletedItem) {
 			Clear-PnPRecycleBinItem -Identity $Item.ID -Force
 			Write-Host "Deleting item $($Item.LeafName) which was deleted on $($Item.DeletedDate)..." -ForegroundColor Cyan 
}
}

Write-Host "================================================" -ForegroundColor Green
Write-Host "All items successfully moved!" -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Green

disconnect-pnponline
