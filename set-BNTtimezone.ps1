function set-BNTtimezone{
	<#
		.SYNOPSIS
			Setup timezone and daylight savings on BNT switch module.
		.DESCRIPTION
			Use set-BNTtimezone to set timezone and daylight savings on BNT Layer 2/3 Copper Gigabit Ethernet Switch Module for IBM BladeCenter.
		.PARAMETER Stream
			BNT switch module session.
		.PARAMETER DaylightSavings
			Set system daylight savings.
		.PARAMETER TimeZone
			Set system timezone.
		.EXAMPLE
			Setup timezone and disable system daylight savings.

            PS $con = connect-BNTswitch -RemoteHost "192.168.1.10"
            Login to 192.168.1.10:23 successful
            PS set-BNTtimezone -Stream $con -DaylightSavings Disable
            Selected timezone is: Europe/Russia/West
            Daylight savings Disabled
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
        [ValidateSet("Enable","Disable")]
        [string]$DaylightSavings,
        [ValidateScript({(($_ -is [System.Array]) -and (($_ | Where-Object {$_ -match "^\d{1,2}$"}).Count -eq 3))})]
        [string[]]$TimeZone = @("8","34","2") #Europe/Russia/West
	)
	$cmds = @("/cfg/sys/timezone")
	$cmds += $TimeZone
    if ($DaylightSavings) {$cmds += "dlight $DaylightSavings"}

	$cmdsOutput = Invoke-BNTcmd -Stream $Stream -Commands $cmds
	if (!(get-BNTError -Log $cmdsOutput)){
		$SelectedTimezone = [regex]::Match($cmdsOutput,'Selected timezone is: ([\w]+/[\w]+/[\w]+)').Groups[1].Value

		Write-Host "Selected timezone is '$SelectedTimezone'" -ForegroundColor Green
    if ($DaylightSavings) { Write-Host "Daylight savings '$($DaylightSavings)d'" -ForegroundColor Green }
	}
}