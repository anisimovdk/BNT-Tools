function set-BNTSyslog{
    <#
        .SYNOPSIS
            Setup Syslog logging on BNT switch module.
        .DESCRIPTION
            Use set-BNTSyslog to setup Syslog logging on BNT Layer 2/3 Copper Gigabit Ethernet Switch Module for IBM BladeCenter.
        .PARAMETER Stream
            BNT switch module session.
        .PARAMETER Primary
            Set IP address of first syslog host.
        .PARAMETER Secondary
            Set IP address of second syslog host.
        .PARAMETER PrimarySeverity
            Set the severity of first syslog host.
        .PARAMETER SecondarySeverity
            Set the severity of second syslog host.
        .PARAMETER PrimaryFacility
            Set facility of first syslog host.
        .PARAMETER SecondaryFacility
            Set facility of second syslog host.
        .PARAMETER ConsoleOutput
            Enable/disable console output of syslog messages
        .PARAMETER Feature
            Enable/disable syslogging of features.
        .PARAMETER Enable
            Enable Syslog logging.
        .EXAMPLE
            Configure Syslog logging.

            PS $con = connect-BNTswitch -RemoteHost "192.168.1.10"
            Login to 192.168.1.10:23 successful
            PS set-BNTSyslog -Stream $con -Primary "192.168.1.3" -Feature all -Enable
            SYSLOG settings updated successful
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
        [ValidateScript({$_ -match [IPAddress]$_ })]
        [string]$Primary,
        [ValidateScript({$_ -match [IPAddress]$_ })]
        [string]$Secondary,
        [ValidateRange(0,7)]
        [int]$PrimarySeverity,
        [ValidateRange(0,7)]
        [int]$SecondarySeverity,
        [ValidateRange(0,7)]
        [int]$PrimaryFacility,
        [ValidateRange(0,7)]
        [int]$SecondaryFacility,
        [ValidateSet("Enable","Disable")]
        [string]$ConsoleOutput,
        [ValidateSet("all","console","system","mgmt","cli","stg","vlan","ssh","vrrp","bgp","ntp","hotlink","ip","web","ospf","rmon","server","802.1x","cfg","difftrak","lldp","failover")]
        [string]$Feature,
        [switch]$Enable
    )
    $cmds = @("/cfg/sys/syslog/") # Enter Syslog configuration menu
    if ($Primary) {$cmds += "host $Primary"}
    if ($Secondary) {$cmds += "host2 $Secondary"}
    if ($PrimarySeverity) {$cmds += "sever $PrimarySeverity"}
    if ($SecondarySeverity) {$cmds += "sever2 $SecondarySeverity"}
    if ($PrimaryFacility) {$cmds += "facil $PrimaryFacility"}
    if ($SecondaryFacility) {$cmds += "facil2 $SecondaryFacility"}
    if ($ConsoleOutput) {$cmds += "console $ConsoleOutput"}
    if ($Feature -and $Enable) {$cmds += "log $Feature enable"}
    elseif ($Feature -and !$Enable) {$cmds += "log $Feature disable"}

    $cmdsOutput = Invoke-BNTcmd -Stream $Stream -Commands $cmds
    if (!(get-BNTError -Log $cmdsOutput)){ Write-Host "SYSLOG settings updated successful" -ForegroundColor Green}
}