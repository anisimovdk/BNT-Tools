function set-BNTSNMPv1{
    <#
        .SYNOPSIS
            Setup SNMPv1 settings on BNT switch module.
        .DESCRIPTION
            Use set-BNTSNMPv1 to configure Name, Location, Contact and other SNMPv1 settings on BNT Layer 2/3 Copper Gigabit Ethernet Switch Module for IBM BladeCenter.
        .PARAMETER Stream
            BNT switch module session.
        .PARAMETER SystemName
            Set SNMP "sysName".
        .PARAMETER SystemLocation
            Set SNMP "sysLocation".
        .PARAMETER SystemContact
            Set SNMP "sysContact".
        .PARAMETER ReadCommunityString
            Set SNMP read community string.
        .PARAMETER WriteCommunityString
            Set SNMP write community string.
        .PARAMETER TrapInterface
            Set SNMP trap source interface for SNMPv1.
        .PARAMETER Timeout
            Set timeout for the SNMP state machine.
        .PARAMETER AuthTrap
            Enable/disable SNMP "sysAuthenTrap".
        .PARAMETER LinkStateInterface
            Select SNMP link up/down trap interface.
        .PARAMETER LinkState
            Enable/disable SNMP link up/down trap.
        .EXAMPLE
            Configure SNMPv1 'sysName','sysLocation','sysContact' trap.

            PS $con = connect-BNTswitch -RemoteHost "192.168.1.10"
            Login to 192.168.1.10:23 successful
            PS set-BNTSNMPv1 -Stream $con -SystemName "BNT-Switch1" -SystemLocation "Block A" -SystemContact "admin@somecorp.com"
            SNMPv1 settings updated successful
            PS disconnect-BNTswitch -Stream $con -Apply -Save
            New configuration applied.
            New configuration saved.
            Logout success.
        .NOTES
            Author: Dmitry Anisimov
            GitHub: https://github.com/made-with-care
            EMail: mail@anisimov.dk
            HomePage: https://www.anisimov.dk
        .LINK
            connect-BNTswitch
            disconnect-BNTswitch
            Invoke-BNTcmd
    #>
    param(
        [parameter(mandatory=$true)]
        [ValidateScript({$_ -is "System.Net.Sockets.NetworkStream"})]
        $Stream,
        [ValidateLength(1,64)]
        [string]$SystemName,
        [ValidateLength(1,64)]
        [string]$SystemLocation,
        [ValidateLength(1,64)]
        [string]$SystemContact,
        [ValidateLength(1,32)]
        [string]$ReadCommunityString,
        [ValidateLength(1,32)]
        [string]$WriteCommunityString,
        [ValidateRange(1,128)]
        [int]$TrapInterface,
        [ValidateRange(1,30)]
        [int]$Timeout,
        [ValidateSet("Enable","Disable")]
        [string]$AuthTrap,
        [ValidateScript({$_ -match "^(INT([1-9]|[1][0-4])|MGT[12]|EXT[1-6])$"})]
        [ValidateSet("INT1","INT2","INT3","INT4","INT5","INT6","INT7","INT8","INT9","INT10","INT11","INT12","INT13","INT14","MGT1","GMT2","EXT1","EXT2","EXT3","EXT4","EXT5","EXT6")]
        [string]$LinkStateInterface,
        [ValidateSet("Enable","Disable")]
        [string]$LinkState
    )
    $cmds = @("/cfg/sys/ssnmp/")
    if ($SystemName){$cmds += "name $SystemName"}
    if ($SystemLocation){$cmds += "locn $SystemLocation"}
    if ($SystemContact){$cmds += "cont $SystemContact"}
    if ($ReadCommunityString){$cmds += "rcomm $ReadCommunityString"}
    if ($WriteCommunityString){$cmds += "wcomm $WriteCommunityString"}
    if ($TrapInterface){$cmds += "trsrc $TrapInterface"}
    if ($Timeout){$cmds += "timeout $Timeout"}
    if ($AuthTrap){$cmds += "auth $AuthTrap"}
    if ($LinkStateInterface -and $LinkState){$cmds += "linkt $LinkStateInterface $LinkState"}

    $cmdsOutput = Invoke-BNTcmd -Stream $Stream -Commands $cmds
    if (!(get-BNTError -Log $cmdsOutput)){ Write-Host "SNMPv1 settings updated successful" -ForegroundColor Green}
}