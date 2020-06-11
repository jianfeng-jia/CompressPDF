<#
    .SYNOPSIS 
       Copmpress PDF via GhostScript. https://www.ghostscript.com/
        
    .DESCRIPTION 
       Be care if you have many PDFs. It will deal with files parallel.
    
    .NOTES  
    Author     : Jijia
    Version    : 0.1
 
#>
 
$Script = "$env:TEMP\GhostScript.bat"
'echo off
set arg1=%1
set arg2=%2
"C:\Program Files\gs\gs9.50\bin\gswin64c.exe" -sDEVICE=pdfwrite -dPDFSETTINGS=/screen -dCompatibilityLevel=1.4 -dNOPAUSE -dBATCH -sOutputFile=%arg2%  %arg1%
exit
' | Out-File -Encoding ascii $Script  -Force

#start-process cmd -ArgumentList "/k $env:TEMP\GhostScript.bat"

$PDFFolders = "E:\1","E:\2"

function Compress-PDF {
    Param(
        [string[]]$PDFFolder,
        [string]$GhostScript
    )


    foreach ($folder in $PDFFolder){
        $files = Get-ChildItem $folder | Where-Object {$_.Extension -match "pdf"}
        #$targetFolder = new-item -ItemType Directory (-join($folder,"\","formatted")) -Force
        foreach ($file in $files ){
            $InputFilename = $file.FullName
            $OututFilename = -join ($file.FullName,".formatted")
            $Quota = "`""
            $Space = " "
            $argument = -join($script,$Space,$Quota,$InputFilename,$Quota,$Space,$Quota,$OututFilename,$Quota)
            Start-Process cmd  -ArgumentList  "/k $argument"
        }

    }
}


function Remove-FormattedPDF(){
    Param(
        [string[]]$PDFFolder,
        [string]$FormatKeyWord
    )
    foreach ($folder in $PDFFolder){
        $files = Get-ChildItem $folder -Recurse | Where-Object{$_.Name -like "*$FormatKeyWord*"}
        $files | Remove-Item
    }
}


Compress-PDF -PDFFolder $PDFFolders -GhostScript $Script
