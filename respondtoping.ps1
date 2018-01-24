# use a notepad doc with a new computer on each line, point the script to that file and change your out-file path and run script.

GC C:\somedirectory\placeholder | %{
    if (Test-Connection -computer $_ -Quiet -count 1) {
        "$_ is UP" 
        }
        Else {
        "$_ is Down"
        }
    } | #out-file C:\some\directory\pingresults.txt