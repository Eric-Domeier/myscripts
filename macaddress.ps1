# create a list of computers in notepad with a computer in each line to import and point
# variable to that list and run script.


$COMPUTER = Get-Content "c:\some\directory" 

Get-WmiObject -Class win32_networkadapterconfiguration -ComputerName $COMPUTER -ErrorAction SilentlyContinue | select-object DNSHostName, macaddress, IP |  export-csv "c:\some\directory" 