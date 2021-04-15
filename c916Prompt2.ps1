# Alex Fluhr 001354345

try{
        # Creates a new Active Directory with the name finance
        New-ADOrganizationalUnit -Name finance -ProtectedFromAccidentalDeletion $False

        # Adds users to the finance active directory. Uses the for loop to go through the file
        $NewAD = Import-Csv $PSScriptRoot\financePersonnel.csv
        $Path = "OU=finance,DC=ucertify,DC=com"

        foreach ($ADUser in $NewAD)
        {
            $First = $ADUser.First_name
            $Last = $ADUser.Last_name
            $Sam = $ADUser.samAccount
            $City = $ADUser.City
            $Country = $ADUser.Country
            $PostalCode = $ADUser.PostalCode
            $OfficePhone = $ADUser.OfficePhone
            $MobilePhone = $ADUser.MobilePhone
            $DisplayName = $First + " " + $Last

            New-ADUser -Name $First -SurName $Last -DisplayName $DisplayName -SamAccountName $Sam -City $City -Country $Country -PostalCode $Postalcode -OfficePhone $OfficePhone -MobilePhone $MobilePhone -Path $Path
        }

        # Start of Sql Section

        Import-Module sqlps -DisableNameChecking -Force

        ##Create Object for local sql connection

        $servername = ".\UCERTIFY3"
        $srv = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $servername

        # Creates database
        $databasename = "ClientDB"
        $db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -ArgumentList $servername,$databasename
        $db.create()
 
        # Creates table using contacts.sql file
        Invoke-Sqlcmd -ServerInstance .\UCERTIFY3 -Database ClientDB -InputFile $PSScriptRoot\contacts.sql

        $table = 'Client_A_Contacts'
        $db = 'ClientDB'

        # Imports client data into the table
        Import-Csv $PSScriptRoot\NewClientData.csv | ForEach-Object {Invoke-Sqlcmd `
        -Database ClientDB -ServerInstance .\UCERTIFY3 -Query "insert into $table (first_name,last_name,city,county,zip,officePhone,mobilePhone) VALUES `
        ('$($_.first_name)','$($_.last_name)','$($_.city)','$($_.county)','$($_.zip)','$($_.officePhone)','$($_.mobilePhone)')"
        }

}
catch [System.OutOfMemoryException] {
    WriteHost "A system out of Memory exception has ocured."
}
