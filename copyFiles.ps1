Add-Type -AssemblyName PresentationFramework


function Show-Message {
    param([string]$message, [int] $type)
    
    switch ($type) {
        1 { [System.Windows.Forms.MessageBox]::Show(
            $message, 
            "Information", 
            [System.Windows.MessageBoxButton]::Ok ,  
            [System.Windows.MessageBoxImage]::Information
        )}
        2 { [System.Windows.MessageBox]::Show(
            $message, 
            "Invalid Input", 
            [System.Windows.MessageBoxButton]::Ok, 
            [System.Windows.MessageBoxImage]::Error
        )}
        
        Default { [System.Windows.MessageBox]::Show($message) }
    }
    
}


function Main {   
    # ask user for file to copy, can drag and drop the file
    try {
        $copyFilePath = Read-Host "( Enter path of file to copy from) "
        $copyFilePath = $copyFilePath -replace '"', ''

        #check if file path is valid
        if(-Not (Test-Path -Path $copyFilePath -PathType Leaf)){
            throw "Filepath not valid, make sure to provide a valid file path."
        }
        
        # ask user for number of copies with 10 being default
        $numOfCopies = Read-Host "(Enter number of copies to make)(default: 10) "
        
        if(-not ($numOfCopies -match "^\d+$")){
            Write-Output "(!) Invalid number passed, using default 10 instead."
            $numOfCopies = 10
        }
        else {
            $numOfCopies = $numOfCopies -as [int]
        }
        Start-Sleep -Milliseconds 500
        #check if num of Copies is null or not an int, use default if so
        Write-Output "`n[o_o] Making $numOfCopies copies of $copyFilePath`n"
        Start-Sleep -Milliseconds 500
        
        [System.IO.FileInfo] $file = $copyFilePath

        # generate copies with sameFileName_$num
        for ($i = 0; $i -lt $numOfCopies; $i++) {
            $copy = "$($file.DirectoryName)\$($file.BaseName)_copy-$($i+1)$($file.Extension)"
            Write-Output "Creating  $copy"
            Copy-Item -Path $copyFilePath -Destination $copy
        }
        
        Show-Message -message " Done :)" -type 1
    }
    catch {
        Show-Message -message $Error[0] -type 2
    }
}

Main