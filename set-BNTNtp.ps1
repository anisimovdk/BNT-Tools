function set-BNTNtp{
    <#
        .SYNOPSIS
            Setup NTP client on BNT switch module.
        .DESCRIPTION
            Use set-BNTNtp to setup NTP client on BNT Layer 2/3 Copper Gigabit Ethernet Switch Module for IBM BladeCenter.
        .PARAMETER Stream
            BNT switch module session.
        .PARAMETER Primary
            Primary NTP server FQDN or IP.
        .PARAMETER Secondary
            Secondary NTP server FQDN or IP.
        .PARAMETER Interval
            Interval in miliseconds.
        .PARAMETER Enable
            Enable NTP client.
        .PARAMETER Disable
            Disable NTP client.
        .EXAMPLE
            Configure and enable NTP client on BNT switch module.

            PS $con = connect-BNTswitch -RemoteHost 192.168.1.10 -RemotePort "23"
            Login to 192.168.1.10:23 successful
            PS set-BNTNtp -Stream $con -Primary "192.168.1.1" -Secondary "192.168.1.2" -Enable
            NTP settings updated successful
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
        [ValidateRange(1,44640)]
        [int]$Interval,
        [switch]$Enable,
        [switch]$Disable
	)
	$cmds = @("/cfg/sys/ntp/")
	if ($Primary) {$cmds += "prisrv $Primary"}
    if ($Secondary) {$cmds += "secsrv $Secondary"}
    if ($Interval) {$cmds += "intrval $Interval"}
    if ($Enable -and !$Disable) {$cmds += "on"}
    if ($Disable -and !$Enable) {$cmds += "off"}
    if ($Enable -and $Disable) {write-host "Warning! Select only -Enable or -Disable. NTP state unchanged."}

    $cmdsOutput = Invoke-BNTcmd -Stream $Stream -Commands $cmds
    if (!(get-BNTError -Log $cmdsOutput)){ Write-Host "NTP settings updated successful" -ForegroundColor Green}
}