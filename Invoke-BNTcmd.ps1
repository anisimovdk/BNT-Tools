function Invoke-BNTcmd{
    <#
        .SYNOPSIS
            Execute custom commands on BNT switch module.
        .DESCRIPTION
            Use Invoke-BNTcmd to perform custom commands on BNT Layer 2/3 Copper Gigabit Ethernet Switch Module for IBM BladeCenter.
        .PARAMETER Commands
            A set of custom commands.
        .PARAMETER Stream
            BNT switch module session.
        .PARAMETER WaitTime
            Wait time between commands.
        .EXAMPLE
            Connect to BNT switch module and setup primary NTP server.

            PS $con = connect-BNTswitch -RemoteHost 192.168.1.10 -RemotePort "23"
            Login to 192.168.1.10:23 successful
            PS $cmds = @("/cfg/sys/ntp/","prisrv 192.168.1.1")
            PS Invoke-BNTcmd -Commands $cmds -Stream $con
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
    #>
    param(
        [parameter(mandatory=$true)]
        [string[]]$Commands = (Read-Host("Enter commands (use comma as separator)")),
        [parameter(mandatory=$true)]
        [ValidateScript({$_ -is "System.Net.Sockets.NetworkStream"})]
        $Stream,
        [int]$WaitTime = 1000
    )
    Write-Verbose [string]$Commands
    $writer = New-Object System.IO.StreamWriter($Stream)
    $buffer = New-Object System.Byte[] 1024
    $encoding = New-Object System.Text.AsciiEncoding
    foreach ($cmd in $Commands){
        $writer.WriteLine($cmd)
        $writer.Flush()
        Start-Sleep -Milliseconds $WaitTime
    }
    Start-Sleep -Milliseconds ($WaitTime * 5)
    $result = ""
    while($Stream.DataAvailable){
        $read = $Stream.Read($buffer,0,1024)
        $result += ($encoding.GetString($buffer,0,$read))
    }
    Write-Verbose $result
    return $result
}