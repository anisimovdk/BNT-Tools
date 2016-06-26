function connect-BNTswitch{
    <#
        .SYNOPSIS
            Connect to BNT switch module via Telnet.
        .DESCRIPTION
            Use connect-BNTswitch to establish Telnet session with BNT Layer 2/3 Copper Gigabit Ethernet Switch Module for IBM BladeCenter.
        .PARAMETER RemoteHost
            FQDN or IP address of BNT switch module.
        .PARAMETER RemotePort
            Telnet port number. Default 23(TCP)
        .PARAMETER Password
            Admin or RADIUS user password.
        .PARAMETER WithRadius
            Use RADIUS authentication. Username required!
        .PARAMETER ClearUnsavedConfig
            Clear unsaved configuration after connect.
        .PARAMETER UserName
            Enter username (for RADIUS authentication only).
        .EXAMPLE
            Connect to BNT switch module with local Admin credential.

            PS $con = connect-BNTswitch -RemoteHost 192.168.1.10 -RemotePort "23"
            Login to 192.168.1.10:23 successful
        .EXAMPLE
            Connect to BNT switch module with RADIUS credential.

            PS $con = connect-BNTswitch -RemoteHost 192.168.1.10 -WithRadius -UserName BNTAdmin
            Login to 192.168.1.10:23 successful
        .EXAMPLE
            Connect to BNT switch module with local Admin credential and clear previously unsaved configuration.

            PS $con = connect-BNTswitch -RemoteHost 192.168.1.10 -ClearUnsavedConfig
            Login to 192.168.1.10:23 successful
        .NOTES
            Author: Dmitry Anisimov
            GitHub: https://github.com/made-with-care
            EMail: mail@anisimov.dk
            HomePage: https://www.anisimov.dk
        .LINK
            disconnect-BNTswitch
            Invoke-BNTcmd
            get-BNTpass
    #>
    param(
        [parameter(mandatory=$true)]
        [string]$RemoteHost,
        [string]$RemotePort = "23",
        $Password = (Read-Host -assecurestring "Enter password for $($RemoteHost):$RemotePort"),
        [switch]$WithRadius,
        [switch]$ClearUnsavedConfig,
        [string]$UserName
    )
    $HostPort = [string]"$($RemoteHost):$($RemotePort)"
    $Password = get-BNTpass -Password $Password
    $cmds = @()
    if ($WithRadius) {$cmds += $UserName}
    $cmds += $Password
    if ($ClearUnsavedConfig) {$cmds += "revert","y"}
    $socket = New-Object System.Net.Sockets.TcpClient($RemoteHost,$RemotePort)
    if ($Socket){
        $Stream = $Socket.GetStream()
        $loginOutput = Invoke-BNTcmd -Stream $Stream -Commands $cmds
        if ($loginOutput -like "*NOTICE*mgmt:*login from host*"){
            Write-Host "Login to $HostPort successful" -ForegroundColor Green
            return $Stream
        }
        else{
            Write-Host "Login to $HostPort failied" -ForegroundColor Red
            return $false
        }
    }
    else {
        Write-Host "Cannot connect to $HostPort" -ForegroundColor Red
        return $false
    }
}