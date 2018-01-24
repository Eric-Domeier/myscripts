# Get quick information from computer

# Array of entered computers

$ComputerArray = New-Object System.Collections.ArrayList
$FunctionArray = New-Object System.Collections.ArrayList
$CSVFORMATTED = $null
$FINALPATH = ""





function questionfunction  {
 Param(
    [parameter(Mandatory=$false)]
    [string]
    $RETURNED
    )

if ($RETURNED -ne $true) {

    Do {$QUESTION = Read-Host "==Want to add more options? [y][n]"}
        while(($QUESTION -notcontains "y") -and ($QUESTION -notcontains "n"))

        if($QUESTION -eq "y") {A3}

        elseif($QUESTION -eq "n") {echo "okay proceeding"}

        elseif($QUESTION -eq "") {echo "enter [y] or [n]"
        questionfunction
        }

        elseif(($QUESTION -ne "y") -and ($QUESTION -ne "n") -and ($QUESTION -ne "")) { 
        echo "enter [y] or [n]"
        questionfunction
        }
        }

if (($QUESTION -eq "n") -or ($RETURNED -eq $true))    {
    Do {$QUESTION2 = Read-Host "==File Name? [Do not add a file extension or path]"  } 
        while($QUESTION2 -eq "")

        
$PATH = Get-Location
echo "Checking to see if ${PATH}\${QUESTION2}.csv already exists..."

try {
$PATHTEST = Test-Path ${PATH}\${QUESTION2}.csv

if ($PATHTEST -eq $false) {
echo "==CSV will be saved to ${PATH}\${QUESTION2}.csv" 
$CSVFORMATTED = "yes"
$FINALPATH = "${PATH}\${QUESTION2}.csv"
ImprovedFunctionStart }

if ($PATHTEST -eq $true) {
echo "File already exists, use another name."
questionfunction($true)


}

}

catch {

$ERRORMSG = $_.Exception.Message
$FAILEDITEM = $_.Exception.ItemName
echo "====================================="
echo "$ERRORMSG"
echo "$FAILEDITEM"
echo "Maybe try another name?"
echo "====================================="
questionfunction($true)

}
        
              

        }
        }

#START THE INFO GATHER FUNCTIONS 


###########################################################################
###Takes each function in array and runs them for each computer in array###
###########################################################################


function ImprovedFunctionStart {

$PATH = Get-Location

if($CSVFORMATTED -eq "yes") {
foreach ($comp in $ComputerArray) {

$FINALKEYS = New-Object System.Collections.ArrayList
$FINALVALUES = New-Object System.Collections.ArrayList


       foreach ($f in $FunctionArray) {       
       
       $KEY = New-Object System.Collections.ArrayList
       $VALUE = New-Object System.Collections.ArrayList


       echo "running function $f on $comp"
       if ($f -eq "B1") {$KEY, $VALUE = B1($comp)
       echo "successfully ran $f on $comp"
       $FINALKEYS += $KEY
       $FINALVALUES += $VALUE
       }

       elseif ($f -eq "B2") {$KEY, $VALUE = B2($comp)
       echo "successfully ran $f on $comp"
       $FINALKEYS += $KEY
       $FINALVALUES += $VALUE
       }

       elseif ($f -eq "B3") {$KEY, $VALUE = B3($comp)
       echo "successfully ran $f on $comp"
       $FINALKEYS += $KEY
       $FINALVALUES += $VALUE
       }

       elseif ($f -eq "B4") {$KEY, $VALUE = B4($comp)
       echo "successfully ran $f on $comp"
       $FINALKEYS += $KEY
       $FINALVALUES += $VALUE
       }

       elseif ($f -eq "B5") {$KEY, $VALUE = B5($comp)
       echo "successfully ran $f on $comp"
       $FINALKEYS += $KEY
       $FINALVALUES += $VALUE
       }
            


            }

$count = $FINALKEYS.count

$NewCustomObject = New-Object -TypeName PSObject
$NewCustomObject | Add-Member -MemberType NoteProperty -Name Hostname -Value $comp 



For ($i = 0; $i -lt $count; $i++) {


$NewCustomObject | Add-Member @{$FINALKEYS[$i] = $FINALVALUES[$i] -join ',';}


}              



Export-Csv -InputObject $NewCustomObject -Path $FINALPATH -NoTypeInformation -Append
echo "==============================================="
echo "Added $C to $FINALPATH, moving on."
echo "==============================================="


        }
    }

exit

}


##########################################
###LIST OF FUNCTIONS THAT GRAB THE INFO###
##########################################

# "1. ADUC Location (Distinguised name) ."
# "2. Get operating system info."
# "3. Network configuration. (MAC, IP, DNS, DHCP etc.)"
# "4. Current time settings."
# "5. Get McAfee Information"


#Grabs computers ADUC information
function B1 {
 Param(
    [parameter(Mandatory=$true)]
    [string]
    $COMPUTER_NAME
    )

        Try {
        Write-Host -BackgroundColor Gray "Retrieving ADUC Info for $COMPUTER_NAME"
        $INFO = Get-ADComputer $COMPUTER_NAME
        Write-Host -ForegroundColor Green "Successfully retrieved ADUC info for $COMPUTER_NAME"
        $RETURNKEY = "DN", "SamAccountName"
        $RETURNVALUE = $INFO.DistinguishedName, $INFO.SamAccountName
        return $RETURNKEY, $RETURNVALUE
        }
        Catch {
        $ERRORMSG = $_.Exception.Message
        $FAILEDITEM = $_.Exception.ItemName
        Write-Host -ForegroundColor DarkYellow "$ERRORMSG"
        Write-Host -ForegroundColor DarkYellow "$FAILEDITEM"
        
        }}


#Grabs OS Info

function B2 {
Param(
    [parameter(Mandatory=$true)]
    [string]
    $COMPUTER_NAME
    )
        Try {
        Write-Host -BackgroundColor Gray "Retrieving OS Info for $COMPUTER_NAME"
        $INFO = Get-WmiObject -Class win32_Operatingsystem -ComputerName $COMPUTER_NAME
        $INFO2 = Get-WmiObject -class win32_BIOS -ComputerName $COMPUTER_NAME
        $INFO3 = Get-WmiObject -Class win32_computersystem -ComputerName $COMPUTER_NAME
        Write-Host -ForegroundColor Green "Successfully retrieved OS info for $COMPUTER_NAME"
        $RETURNKEY = "BuildNumber", "OS Install Date", "Architecture", "Last Reboot", "BIOS Version", "Manufacturer", "Serial Number", "Model"
        $RETURNVALUE = $INFO.BuildNumber, $INFO.InstallDate, $INFO.OSArchitecture, $INFO.LastBootUpTime, $INFO2.BIOSVersion, $INFO2.Manufacturer, $INFO2.SerialNumber, $INFO3.model
        return $RETURNKEY, $RETURNVALUE

        }Catch {
        $ERRORMSG = $_.Exception.Message
        $FAILEDITEM = $_.Exception.ItemName
        Write-Host -ForegroundColor DarkYellow "$ERRORMSG"
        Write-Host -ForegroundColor DarkYellow "$FAILEDITEM"
        
        }
    
       }


#Grabs Network Config

function B3 {
 Param(
    [parameter(Mandatory=$true)]
    [string]
    $COMPUTER_NAME
    )
        Try {
        Write-Host -BackgroundColor Gray "Retrieving Network Info for $COMPUTER_NAME"
        $INFO = get-wmiobject -class win32_networkadapterconfiguration -Filter 'DNSDOMAIN != NULL' -ComputerName $COMPUTER_NAME
        Write-Host -ForegroundColor Green "Successfully retrieved Network info for $COMPUTER_NAME" 
        $RETURNKEY = "DNSServerSearchOrder", "IPAddress", "MAC Address", "Subnet"
        $RETURNVALUE = $INFO.DNSServerSearchOrder, $INFO.IPAddress, $INFO.MACAddress, $INFO.IPSubnet
        return $RETURNKEY, $RETURNVALUE
        } 
        Catch {
        $ERRORMSG = $_.Exception.Message
        $FAILEDITEM = $_.Exception.ItemName
        Write-Host -ForegroundColor DarkYellow "$ERRORMSG"
        Write-Host -ForegroundColor DarkYellow "$FAILEDITEM"
        
        }
       }


#Grabs Current time settings
function B4 {
 Param(
    [parameter(Mandatory=$true)]
    [string]
    $COMPUTER_NAME
    )
    Try {
    Write-Host -BackgroundColor Gray "Retrieving Time Info for $COMPUTER_NAME"
    $INFO = Get-WmiObject -class win32_localtime -ComputerName $COMPUTER_NAME
    Write-Host -ForegroundColor Green "Successfully retrieved Time info for $COMPUTER_NAME" 
    $RETURNKEY = "Year", "Month", "Day", "Hour", "Minute"
    $RETURNVALUE = $INFO.year, $INFO.month, $INFO.day, $INFO.hour, $INFO.Minute
    return $RETURNKEY, $RETURNVALUE
        }
        Catch {
        $ERRORMSG = $_.Exception.Message
        $FAILEDITEM = $_.Exception.ItemName
        Write-Host -ForegroundColor DarkYellow "$ERRORMSG"
        Write-Host -ForegroundColor DarkYellow "$FAILEDITEM"
        
        }
    
       }


function B5 {
 Param(
    [parameter(Mandatory=$true)]
    [string]
    $COMPUTER_NAME
    )
        










    
            }



             




#########################################
#####ADDS FUNCTIONS TO FUNCTION ARRAY####
#########################################

function Addfunction {
    Param(
    [parameter(Mandatory=$true)]
    [string]
    $Function
    )
    if($FunctionArray -notcontains "$Function") {[void]$FunctionArray.Add("$Function")
    questionfunction} 

    elseif($FunctionArray -contains "$Function") {
    echo "=============!!!!!!!!!============="
    echo "You've already added this function"
    echo "==================================="
    A3}



}

######################################################################################
### This function is called after the requested computer(s) has been verified as up###
### By the "addfunction" function ####################################################
######################################################################################

function A3 {
    echo ""
    echo "===================================================="
    echo "What would you like to know about $ComputerArray ?"
    echo "===================================================="
    Write-Host "1. ==ADUC Location (Distinguised name)."
    Write-Host "2. ==Get operating system info."
    Write-Host "3. ==Network configuration. (MAC, IP, DNS, DHCP etc.)"
    Write-Host "4. ==Current time settings."
    
    echo ""


    Do {[int]$OPTION = Read-Host "Enter an option 1-5" 
        
        } while(($OPTION -eq ""))
        If($OPTION -isnot [int]) {
        echo "You did not enter a number, try again."
        A3 
        } elseif ($OPTION -le 0 -or $OPTION -ge 5) {

        echo "===================================="
        echo "Please choose an option between 1-4"
        echo "===================================="
        A3 
        } elseif($OPTION -ge 0 -and $OPTION -le 5) {
            
                $Selection = "B${OPTION}"
                echo "=========================="
                echo "Added $OPTION to list"
                echo "=========================="
                Addfunction -Function $Selection
                

        }




        } 







#########################################################
####CHECKS TO SEE IF COMPUTER IS ALREADY ADDED ##########
####RETURNS TRUE OR FALSE TO A2##########################
#########################################################

function A4  {
    Param(
    [parameter(Mandatory=$true)]
    [string]
    $COMPUTER_NAME
    )
    if ($ComputerArray -contains "$COMPUTER_NAME") {

    return $true
    }


    }


##########################################################
###TAKES INPUT FROM A1 FUNCTION AND TESTS CONNECTION, ####
###IF COMPUTER IS UP, CHECKS A4 FUNCTION TO SEE IF $C#####
###IS ALREADY ADDED, IF IT ISNT, ADDS IT #################
##########################################################

function A2  {
    Param(
    [parameter(Mandatory=$true)]
    [collections.arraylist]
    $COMPUTER_NAME
    )
    $ADDED = New-Object System.Collections.ArrayList
    $NOTADDED = New-Object System.Collections.ArrayList
    foreach($C in $COMPUTER_NAME){
       
       Write-Host -BackgroundColor Gray "Testing network connectivity for $C standby..."
       $ISUP = Test-Connection -ComputerName $C -Quiet -Count 1
    
       if($ISUP -eq $true) {
       
       Write-Host -ForegroundColor Green "$C is UP, checking to see if $C is already added"
       
       $STATUS = A4($C)
            if($STATUS -ne $true) {
            Write-Host -ForegroundColor Green "$C not added already, adding to list."
            [void]$ComputerArray.Add($C)
            [void]$ADDED.Add($C)
            Write-Host -ForegroundColor Green "$C Added to list. "
            } 
            elseif($STATUS -eq $true)
             {
             Write-Host -ForegroundColor Yellow "$C Already added to list, skipping."
             }
        
        }elseif ($ISUP -eq $false) {

        Write-Host -ForegroundColor Red "Could not reach $C, try adding $C by itself."
        [void]$NOTADDED.Add($C)
         }

    
    
    
    }

echo "###################################################"
echo "##############List of Added Computers##############"
echo "###################################################"
echo " $ComputerArray "
echo "==================================================="

if($NOTADDED.Count -eq 0) {A1($true)} 
elseif($NOTADDED -ne "") {
echo "================================================================="
echo "COULD NOT ADD | $NOTADDED | please retry these computers 1 at a time! (these computers are probably offline or unreachable)"
echo "================================================================="
A1($true)
}
             
}


#######################################################
##Prompts user for method of adding computers to list##
##Sends array $ADD_COMPUTERS to A2 function ###########
#######################################################

function A1 {
Param(
    [parameter(Mandatory=$false)]
    [string]
    $RETURN
    )
$ANSWER = ""
$ADD_COMPUTERS = New-Object System.Collections.ArrayList



if($RETURN -eq "") {
echo "============================================"
echo "Welcome to the SysAd info Tool"
echo "Add computers one at a time or from a file?"
echo "1. One at a time.[1]"
echo "2. From a file.[2]"
echo "3. From an OU.[3]"
echo "============================================"
}
elseif($RETURN -eq $true) {
echo ""
echo "############################################"
echo "Add computers one at a time or from a file?"
echo "1. One at a time.[1]"
echo "2. From a file.[2]"
echo "3. From an OU.[3]"
echo "4. continue without adding more computers.[4]"
echo "############################################"
}

do {$ANSWER = Read-host "Selection"

If($ANSWER -eq "1") {
$SINGLECOMPUTER = Read-Host "Enter a hostname or IP" 
[void]$ADD_COMPUTERS.Add($SINGLECOMPUTER)
A2($ADD_COMPUTERS)
}
If($ANSWER -eq "2") {
$PATH = Get-Location
echo "===================================================="
Write-Host -ForegroundColor Yellow "!!enter file name without full path.!!"
Write-Host -ForegroundColor Yellow "!!Ensure the file is a text file, one computer per new line, and is in the same directory as this script.!!"
echo "===================================================="
$COMPUTERFILE = Read-Host "Enter file name"
$COMPUTERS = Get-Content -Path ${PATH}\${COMPUTERFILE}
    foreach($C in $COMPUTERS) {[void]$ADD_COMPUTERS.Add($C)
    echo "Adding $C to list"
    }

A2($ADD_COMPUTERS)


}


If($ANSWER -eq "3") {

echo ""
Write-Host -ForegroundColor Yellow "Example DN: OU=something,OU=something,OU=Windows 10,OU=Client Devices,OU=_,DC=,DC=,DC="
$SEARCHBASE = Read-Host "Enter the full Distinguished name, comma seperated."

Try {

$COMPUTERSFROMOU = Get-ADComputer -SearchBase $SEARCHBASE -Filter * | Select Name

$COMPUTERSFROMOU.Name | % {[void]$ADD_COMPUTERS.add($_)}
A2($ADD_COMPUTERS)


} Catch {

$ERRORMSG = $_.Exception.Message
$FAILEDITEM = $_.Exception.ItemName
echo "Received an error, please try again."
echo ""
Write-Host $ERRORMSG
echo ""
Write-Host $FAILEDITEM
A1

}

}

If($ANSWER -eq "4") {


    if ($RETURN -eq $true) {

    A3

} if ($RETURN -eq "")  {

Write-Host -ForegroundColor Red "Returning back to main menu, please choose an option."
A1

}



} 

if (($ANSWER -lt 1) -or ($ANSWER -gt 4) -or ($ANSWER -isnot [int])) {

write-host -ForegroundColor Red "Did not receive a valid option, please choose an option."
A1
}

} while($ANSWER = "") 




}






# Calls the computer name function

Write-Host -ForegroundColor Red -BackgroundColor black "IMPORTANT: Ensure you are running as ADMINISTRATOR."
A1
 
