<#
.SYNOPSIS

Get-FileSize gets nested folder sizes to look for large files in Windows

.DESCRIPTION

Takes a folder as an input and returns folder sizes (child items)

.PARAMETER Name
Specifies the start directory you want to search

.INPUTS

System.String.

.OUTPUTS

System.String. Get-FileSize will return a list of string outputs

.EXAMPLE

PS> Get-FileSize -startFolder "D:\docs" 

D:\docs\Documents\2005 -- 0.09 MB
D:\docs\Documents\2006 -- 0.40 MB
D:\docs\Documents\2007 -- 5.91 MB
D:\docs\Documents\2008 -- 2.88 MB

.LINK

Get-FileSize
#>

function Get-FileSize([string]$startFolder) {

    $colItems = Get-ChildItem $startFolder | Where-Object {$_.PSIsContainer -eq $true} | Sort-Object
    foreach ($i in $colItems) {
        try {
            $subFolderItems = Get-ChildItem $i.FullName -recurse -force -ErrorAction SilentlyContinue | Where-Object {$_.PSIsContainer -eq $false} | Measure-Object -property Length -sum | Select-Object Sum
            $i.FullName + " -- " + "{0:N2}" -f ($subFolderItems.sum / 1MB) + " MB"
        }
        catch {
            Write-Host "Caught Exception."
        }
    }
}