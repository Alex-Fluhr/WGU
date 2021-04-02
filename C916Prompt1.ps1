# Alexander Fluhr 001354345

clear


Try {
        # The do statement loops the program, until the user input is 5
        Do {

                # Reads the user input for a number 1-5
                $userinput = Read-Host "
    
                Please select 1-5
    
                1. List files within the Requirements1 Folder.
                2. List Files within the Requirements1 Folder in Tabular format, sorted in ascending alphabetical Order.
                3. Use counters to list the current CPU % Processor Time.
                4. List all the diferent running processes inside your system.
                5. Exit the Script Execution.
                "

                Switch ($userinput){
    
                1 {   
                      Write-Host Writing data to mylog.txt!

                      # Gets the date and adds it to mylog.txt
                      Get-Date | Out-File -FilePath $PSScriptRoot\mylog.txt -Append
                      # Gets all files in the folder matching the filter .log and appends it to the mylog.txt in the directory the script ran in.
                      Get-ChildItem $PSScriptRoot -Filter *.log | Out-File -FilePath $PSScriptRoot\mylog.txt -Append
                  }

                2 {   
                      Write-Host Writing data to C916contents.txt!
                      # Gets a list of files in ascending alphabetical order
                      Get-ChildItem $PSScriptRoot | Out-File -FilePath $PSScriptRoot\C916contents.txt -Append | Sort-Object -Descending | Format-Table
                  }
    
                3 {   
                      Write-Host Getting CPU % and Memory usage!
                      # Uses counter to list the current cpu % processor time, and memory usage, For list of memory sets: (Get-Counter -ListSet Memory).Paths
                      Get-Counter -Counter "\Processor(_Total)\% Processor Time","\Memory\Available MBytes" -SampleInterval 5 -MaxSamples 4
                  }
    
                4 {
                      # List all running processes inside system
                      Get-Process | sort CPU -descending | out-gridview
                  }
    
                5 { 
                    # Exits the script with the Until statement
                    write-host Exiting the script execution
                  }
           }
        }Until ($userinput -eq 5)
}
catch [System.OutOfMemoryException] {
    WriteHost "A system out of Memory exception has oocured."
}


