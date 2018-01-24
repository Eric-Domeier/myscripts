# Get quick information from computer


##TO DO##

#1. Complete the actual information gathering functions
#2. Fix the CSV path export in final function
#3. Find a way to call each information gathering function from the function array
#4. Find a way to format the CSV correctly when all done.
#5. make sure the csv export checks to see if a CSV already exists in location

# Array of entered computers

$ComputerArray = New-Object System.Collections.ArrayList
$FunctionArray = New-Object System.Collections.ArrayList
$CSVFORMATTED = ""


# The end is at the beginning...

function questionfunction  {
    # asks user to add more functions to the final function.
    Do {$QUESTION = Read-Host "Want to add more options? [y][n]"}
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
        

    
    Do {$QUESTION2 = Read-Host "Export to CSV? [y][n]" } 
        while(($QUESTION2 -notcontains "y") -and ($QUESTION2 -notcontains "n"))
        if($QUESTION2 -eq "y") {
        $PATH = Get-Location
        echo "CSV will be saved to ${PATH}\information.csv" 
        $CSVFORMATTED = "yes"
        ImprovedFunctionStart
               }

        elseif ($QUESTION2 -eq "n") {ImprovedFunctionStart}

        }


#START THE INFO GATHER FUNCTIONS 


###########################################################################
###Takes each function in array and runs them for each computer in array###
###########################################################################


function ImprovedFunctionStart {

if($CSVFORMATTED = "yes") {
foreach ($comp in $ComputerArray) {

$KEYSIZE = 0
       foreach ($f in $FunctionArray) {
       
       
       echo "running function $f on $comp"
       if ($f -eq "B1") {$KEY, $VALUE = B1($comp)
       $KEYSIZE = $KEYSIZE + $KEY.count
       }

       elif ($f -eq "B2") {$KEY, $VALUE = B2($comp)
       $KEYSIZE = $KEYSIZE + $KEY.count
       }

       elif ($f -eq "B3") {$KEY, $VALUE = B3($comp)
       $KEYSIZE = $KEYSIZE + $KEY.count
       }

       elif ($f -eq "B4") {$KEY, $VALUE = B4($comp)
       $KEYSIZE = $KEYSIZE + $KEY.count
       }

       elif ($f -eq "B5") {$KEY, $VALUE = B5($comp)
       $KEYSIZE = $KEYSIZE + $KEY.count
       }
            
                do {
                $KEYSIZE = $KEYSIZE - 1

                
                
                }  while($KEYSIZE -ne 0)


            }



       [pscustomobject]@{       
        $KEY = $(@($RESULT2.DNSServerSearchOrder) -join ',') #do the join on all
        
        } | Export-Csv -NoTypeInformation -append -Path C:\Users\eric.domeier\Desktop\test2.csv

        }
    }




elif ($CSVFORMATTED = "") {echo "fix later"}

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
        
        $INFO = Get-ADComputer $COMPUTER_NAME
        $RETURNKEY = "DN", "SamAccountName"
        $RETURNVALUE = $INFO.DistinguisedName, $INFO.SamAccountName
        return $RETURNKEY, $RETURNVALUE
       }


#Grabs OS Info

function B4 {

        
    
       }


#Grabs Network Config

function B3 {
 Param(
    [parameter(Mandatory=$true)]
    [string]
    $COMPUTER_NAME
    )
        get-wmiobject -class win32_networkadapterconfiguration -Filter -ComputerName $COMPUTER_NAME 'DNSDOMAIN != NULL'
        return 
       }


#Grabs Current time settings
function B4 {

        
    
       }

#Grabs McAfee Info
function B5 {

        
    
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
    if($FunctionArray -notcontains "$Function") {$FunctionArray.Add("$Function")
    questionfunction} 

    elseif($FunctionArray -contains "$Function") {echo "You've already added this function"
    A3}



}

######################################################################################
### This function is called after the requested computer(s) has been verified as up###
### By the "addfunction" function ####################################################
######################################################################################

function A3 {
    echo "###################################################"
    Echo "What would you like to know about $ComputerArray ?"
    Echo "###################################################"
    Write-Host "1. ADUC Location (Distinguised name) ."
    Write-Host "2. Get operating system info."
    Write-Host "3. Network configuration. (MAC, IP, DNS, DHCP etc.)"
    Write-Host "4. Current time settings."
    Write-Host "5. Get McAfee Information"


    Do {[int]$OPTION = Read-Host "Enter an option 1-5" 
        
        } while(($OPTION -eq ""))
        If($OPTION -isnot [int]) {
        echo "You did not enter a number, try again."
        A3 
        } elseif ($OPTION -le 0 -or $OPTION -ge 6) {

        echo "####################################"
        echo "Please choose an option between 1-9"
        echo "####################################"
        A3 
        } elseif($OPTION -ge 0 -and $OPTION -le 6) {
            
                $Selection = "B${OPTION}"
                echo "###########################"
                echo "Added $OPTION to list"
                echo "###########################"
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

       $ISUP = Test-Connection -ComputerName $C -Quiet -Count 1
    
       if($ISUP -eq $true) {
       echo "$C is UP, checking to see if already added..."
       $STATUS = A4($C)
            if($STATUS -ne $true) {
            echo "not added already, adding"
            $ComputerArray.Add($C)
            $ADDED.Add($C)
            } 
            elseif($STATUS -eq $true)
             {
             echo "$C Already added to list, skipping."
             }
        
        }elseif ($ISUP -eq $false) {echo "Could not reach $C, try adding $C by itself."
        $NOTADDED.Add($C)
         }

    
    
    
    }

echo "ADDED COMPUTERS $ADDED "

if($NOTADDED.Count -eq 0) {A3} 
elseif($NOTADDED -ne "") {
echo "COULD NOT ADD $NOTADDED please retry these computers 1 at a time! (these computers are probably offline or unreachable)"
A1
}
             
}


#######################################################
##Prompts user for method of adding computers to list##
##Sends array $ADD_COMPUTERS to A2 function ###########
#######################################################

function A1 {

$ADD_COMPUTERS = New-Object System.Collections.ArrayList

echo "Welcome to the SysAd info Tool"
echo "Add computers one at a time or from a file?"
echo "1. One at a time[1]"
echo "2. From a file[2]"

do {$ANSWER = Read-host "Selection"

If($ANSWER -eq "1") {
$SINGLECOMPUTER = Read-Host "Enter a hostname or IP"
$ADD_COMPUTERS.Add($SINGLECOMPUTER)
A2 -COMPUTER_NAME "$ADD_COMPUTERS"
}
If($ANSWER -eq "2") {
$PATH = Get-Location
echo "enter file name without full path."
echo "Ensure the file is a text file, one computer per new line, and is in the same directory as this script."
$COMPUTERFILE = Read-Host "Enter file name"
$COMPUTERS = Get-Content -Path ${PATH}\${COMPUTERFILE}
    foreach($C in $COMPUTERS) {$ADD_COMPUTERS.Add($C)
    echo "Adding $C to list (A1)"
    }

A2($ADD_COMPUTERS)

}

} while($ANSWER = "") 





}





# Calls the computer name function

A1












































    

#try {
  #Set up the key that needs to be accessed and what registry tree it is under
#  $key = "Software\McAfee\AVEngine"
#  $type = [Microsoft.Win32.RegistryHive]::LocalMachine

  #open up the registry on the remote machine and read out the TOE related registry values
 # $regkey = [Microsoft.win32.registrykey]::OpenRemoteBaseKey($type,$server)
#  $regkey = $regkey.opensubkey($key)
#  $status = $regkey.getvalue("AVDatVersion")
#  $datdate = $regkey.getvalue("AVDatDate")
# #} catch {
 # try {
 #  $key = "Software\Wow6432Node\McAfee\AVEngine"
 #  $type = [Microsoft.Win32.RegistryHive]::LocalMachine
 #  #open up the registry on the remote machine and read out the TOE related registry values
 #  $regkey = [Microsoft.win32.registrykey]::OpenRemoteBaseKey($type,$server)
 #  $regkey = $regkey.opensubkey($key)
 #  $status = $regkey.getvalue("AVDatVersion")
 #  $datdate = $regkey.getvalue("AVDatDate")
 # } catch {
 #  $status = "Cannot read regkey"
 # }
 #}
 
 





 







