function set-BNTUserPassword{
    <#
        .SYNOPSIS
            Change user password on BNT switch.
        .DESCRIPTION
            Use set-BNTUserPassword to change user password on BNT Layer 2/3 Copper Gigabit Ethernet Switch Module for IBM BladeCenter.
        .PARAMETER Stream
            BNT switch module session.
        .PARAMETER UserName
            User name.
        .PARAMETER AdminPassword
            Current admin password.
        .PARAMETER NewPassword
            New password for user.
        .EXAMPLE
            Change password for 'oper' user.

            PS $con = connect-BNTswitch -RemoteHost "192.168.1.10"
            Login to 192.168.1.10:23 successful
            PS set-BNTUserPassword -Stream $con -UserName "oper" -AdminPassword "adminPass" -NewPassword "newOperPass"
            Password for 'oper' changed.
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
        [string]$UserName,
        $AdminPassword = (Read-Host -assecurestring "Enter Admin password"),
        $NewPassword = (Read-Host -assecurestring "Enter new password for $UserName")
    )
    $AdminPassword = get-BNTpass -Password $AdminPassword
    $NewPassword = get-BNTpass -Password $NewPassword
    if ($UserName -eq "admin"){$cmd = "/cfg/sys/access/user/admpw"}
    elseif ($UserName -eq "oper"){$cmd = "/cfg/sys/access/user/opw"}
    elseif ($UserName -eq "user"){$cmd = "/cfg/sys/access/user/usrpw"}
    else {
        Write-Host "Changing password for non-default users don't supported yet."
        return $false
    }
    $cmds = @($cmd,$AdminPassword,$NewPassword,$NewPassword)
    $cmdsOutput = Invoke-BNTcmd -Stream $Stream -Commands $cmds
    if ($cmdsOutput -like "*New*password accepted.*") {
        write-host "Password for '$UserName' changed." -ForegroundColor Green
    }
    elseif ($cmdsOutput -like "*ERROR:  New password same as old password, no change.*") {
        Write-Host "New password for '$UserName' same as old password, no change." -ForegroundColor Yellow
    }
    elseif ($cmdsOutput -like "*New password is already taken, no change*"){
        Write-Host "New password for '$UserName' is already taken, no change." -ForegroundColor Red
    }
    else {Write-Host "Warning! Password for '$UserName' not changed" -ForegroundColor Red}
}