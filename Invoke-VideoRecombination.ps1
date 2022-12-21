<# 
.SYNOPSIS
    Recombines split video files.

.DESCRIPTION 
    Recombines all video files in a chosen directory and saves the result in a different directory.
 
.NOTES 
    Written by dePyro, 2022.
 
.Parameter SourcePath 
    Path to source directory with the videos to be recombined.

.Parameter DestinationPath
    Optional: Path to the destination directory for the recombined videos. By default, this is a directory called "RecombinedFiles" in the directory above the source.
#>

Param(

    [Parameter (Mandatory=$true)][String]$SourcePath
    ,[Parameter (Mandatory=$false)][String]$DestinationPath = "$SourcePath\..\RecombinedFiles"
)

if(-not $(Test-Path $SourcePath)){

    throw "Source path invalid"
}

if(-not $(Test-Path $DestinationPath)){

    try{

        New-Item -Path $DestinationPath -ItemType Directory
    }
    catch{

        throw "Error creating target directory - insufficient permissions?"
    }
}

$DestinationPath = Get-Item -Path $DestinationPath | Select-Object -ExpandProperty FullName
$videofiles = Get-ChildItem -Path $SourcePath -Filter "*.mp4" -File | Sort-Object | Select-Object -ExpandProperty FullName
$video1 = $null

foreach($video in $videofiles){

    if($null -eq $video1){

        $video1 = $video
    }
    else{

        $video2 = $video
        $targetfile = $DestinationPath + "\" + $($video1 | Split-Path -Leaf) 
        "type $video1 $video2 > $targetFile" | cmd.exe

        $video1 = $null
    }
}

Write-Host "Finished!" -BackgroundColor Green