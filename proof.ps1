$CSVFORMATTED = "yes"


$ComputerArray = New-Object System.Collections.ArrayList
$FunctionArray = New-Object System.Collections.ArrayList
$ComputerArray = "Comp1", "Comp2", "Comp3"
$FunctionArray = "B1", "B2", "B3", "B4", "B5"


function FunctionStart {

if($CSVFORMATTED = "yes") {
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

echo $FINALKEYS[1]
echo ""
echo $FINALKEYS[1]
echo ""

echo $FINALKEYS[7]
echo ""
echo $FINALVALUES[7]


($FINALRESULT = [PSCustomObject]@{ Keys = $FINALKEYS -join ','; Values = $FINALVALUES -join ',';}); 

Export-Csv -InputObject $FINALRESULT -Path C:\Users\eric.domeier\Desktop\please.csv -NoTypeInformation -Append





            }
        }
    }



#for reference

#       [pscustomobject]@{       
#        $KEY = $(@($RESULT2.DNSServerSearchOrder) -join ',') #do the join on all
#        
#        } | Export-Csv -NoTypeInformation -append -Path C:\Users\eric.domeier\Desktop\test2.csv




















function B1 {

$KEYS = "Key1", "Key2", "Key3"
$VALUES = "Value1", "Value2", "Value3"

return $KEYS, $VALUES

}

function B2 {

$KEYS = "Key10"
$VALUES = "Value10"

return $KEYS, $VALUES

}

function B3 {

$KEYS = "Key11", "Key12"
$VALUES = "Value11", "Value12"

return $KEYS, $VALUES

}

function B4 {

$KEYS = "Key100"
$VALUES = "Value100"

return $KEYS, $VALUES

}

function B5 {

$KEYS = "Key2000"
$VALUES = "Value2000"

return $KEYS, $VALUES

}


FunctionStart