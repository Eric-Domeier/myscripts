# goes through an OU recursively and outputs a list of all users within the scope
# checks for smart card required or not and outputs a seperate CSV for each OU

$OUbase = "OU=,OU=,OU=,DC=,DC=,DC="
$OUnew = Get-ADOrganizationalUnit -SearchBase $OUbase -SearchScope Subtree -Filter *

Foreach ($OU in $OUnew)
{
    $name = $OU.Name
    Get-ADUser -Properties smartcardlogonrequired, description, physicaldeliveryofficename, samaccountname -Searchbase $OU.distinguishedname -Filter * | select samaccountname, smartcardlogonrequired, description, physicaldeliveryofficename | Export-Csv -Append -Path C:\somedriectory\Desktop\${name}.smartcardrequired.csv
    
    }
    


