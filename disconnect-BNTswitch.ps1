function disconnect-BNTswitch{
    <#
        .SYNOPSIS
            Close BNT switch module connection session.
        .DESCRIPTION
            Use disconnect-BNTswitch to close Telnet session with BNT Layer 2/3 Copper Gigabit Ethernet Switch Module for IBM BladeCenter.
        .PARAMETER Stream
            BNT switch module session.
        .PARAMETER Apply
            Apply switch configuration before disconnect.
        .PARAMETER Save
            Save switch configuration before disconnect.
        .EXAMPLE
            Apply and Save configration, then close BNT switch module session.

            PS $con = connect-BNTswitch -RemoteHost "192.168.1.10"
            Login to 192.168.1.10:23 successful
            PS disconnect-BNTswitch -Stream $con -Apply -Save
            New configuration applied.
            New configuration saved.
            Logout success.
        .EXAMPLE
            Disconnect from BNT switch module session without saving and applying configuration.

            PS $con = connect-BNTswitch -RemoteHost "192.168.1.10"
            Login to 192.168.1.10:23 successful
            PS disconnect-BNTswitch -Stream $connection
            Logout success.
        .NOTES
            Author: Dmitry Anisimov
            GitHub: https://github.com/made-with-care
            EMail: mail@anisimov.dk
            HomePage: https://www.anisimov.dk
        .LINK
            connect-BNTswitch
            Invoke-BNTcmd
    #>
    param(
        [parameter(mandatory=$true)]
        [ValidateScript({$_ -is "System.Net.Sockets.NetworkStream"})]
        $Stream,
        [switch]$Apply,
        [switch]$Save
    )
    $cmds = @()
    if ($Apply) {$cmds += "/apply"}
    if ($Save) {$cmds += "/save","y"}
    $cmds += "exit","y","y"
    $logoutOutput = Invoke-BNTcmd -Stream $Stream -Commands $cmds -WaitTime 3000
    if ($Apply -and ($logoutOutput -like "*mgmt: new configuration applied*")){Write-Host "New configuration applied." -ForegroundColor Green}
    elseif ($Apply -and ($logoutOutput -like "*No apply needed*")){Write-Host "No apply needed." -ForegroundColor Yellow}
    if ($Save -and ($logoutOutput -like "*mgmt: new configuration saved*")){Write-Host "New configuration saved." -ForegroundColor Green}
    elseif ($Save -and ($logoutOutput -like "*No save needed*")){Write-Host "No save needed." -ForegroundColor Yellow}
    if ($logoutOutput -like "*Session terminated at*") {
        Write-Host "Logout success." -ForegroundColor Green
    }
    else{
        Write-Host "Logout failied." -ForegroundColor Red
    }
}