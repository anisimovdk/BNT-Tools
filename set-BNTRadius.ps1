function set-BNTRadius{
    <#
        .SYNOPSIS
            Setup RADIUS authentication on BNT switch module.
        .DESCRIPTION
            Use set-BNTRadius to setup RADIUS authentication on BNT Layer 2/3 Copper Gigabit Ethernet Switch Module for IBM BladeCenter.
        .PARAMETER $Stream
            BNT switch module session.
        .PARAMETER Primary
            Primary RADIUS server.
        .PARAMETER Secondary
            Secondary RADIUS server.
        .PARAMETER PrimarySecret
            Secret for primary RADIUS server.
        .PARAMETER SecondarySecret
            Secret for Secondary RADIUS server.
        .PARAMETER SecondarySecret
            Secondary server port number.
        .PARAMETER Port
            RADIUS server port number.
        .PARAMETER Retries
            RADIUS server retries.
        .PARAMETER Timeout
            RADIUS server timeout.
        .PARAMETER Backdoor
            Enable/disable RADIUS backdoor for telnet/ssh/http/https.
        .PARAMETER SecureBackdoor
            Enable/disable RADIUS secure backdoor for telnet/ssh/http/https.
        .PARAMETER Enable
            Turn RADIUS authentication ON.
        .PARAMETER Disable
            Turn RADIUS authentication OFF
        .EXAMPLE
            Configure and enable RADIUS authentication on switch.

            PS $con = connect-BNTswitch -RemoteHost 192.168.1.10
            Login to 192.168.1.10:23 successful
            PS set-BNTRadius -Stream $con -Primary 192.168.1.1 -PrimarySecret "radiusSharedSecret" -Enable
            RADIUS settings updated successful
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
        [ValidateLength(1,32)]
        [ValidatePattern("[a-zA-Z0-9]")]
        [string]$PrimarySecret,
        [ValidateLength(1,32)]
        [ValidatePattern("[a-zA-Z0-9]")]
        [string]$SecondarySecret,
        [ValidateRange(1500,3000)]
        [string]$Port,
        [ValidateRange(1,3)]
        [string]$Retries,
        [ValidateRange(1,10)]
        [string]$Timeout,
        [ValidateSet("Enable","Disable")]
        [string]$Backdoor,
        [ValidateSet("Enable","Disable")]
        [string]$SecureBackdoor,
        [switch]$Enable,
        [switch]$Disable
    )
    $cmds = @("/cfg/sys/radius/")
    if ($Primary) {$cmds += "prisrv $Primary"}
    if ($Secondary) {$cmds += "secsrv $Secondary"}
    if ($PrimarySecret) {$cmds += "secret $PrimarySecret"}
    if ($SecondarySecret) {$cmds += "secret $SecondarySecret"}
    if ($Port) {$cmds += "port $Port"}
    if ($Retries) {$cmds += "retries $Retries"}
    if ($Timeout) {$cmds += "timeout $Timeout"}
    if ($Backdoor) {$cmds += "bckdoor $Backdoor"}
    if ($SecureBackdoor) {$cmds += "secbd $SecureBackdoor"}
    if ($Enable -and !$Disable) {$cmds += "on"}
    if ($Disable -and !$Enable) {$cmds += "off"}
    if ($Enable -and $Disable) {write-host "Warning! Select only -Enable or -Disable. RADIUS state unchanged."}

    $cmdsOutput = Invoke-BNTcmd -Stream $Stream -Commands $cmds
    if (!(get-BNTError -Log $cmdsOutput)){ Write-Host "RADIUS settings updated successful" -ForegroundColor Green}
}