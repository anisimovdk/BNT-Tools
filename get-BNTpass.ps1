function get-BNTpass{
	<#
		.SYNOPSIS
			Preparing password for BNT switch module.
		.DESCRIPTION
			Use get-BNTpass to prepare password for connection or changing password on BNT Layer 2/3 Copper Gigabit Ethernet Switch Module for IBM BladeCenter.
			Convert secure string to simple string.
			Always return simple string.
		.PARAMETER Password
			Secure or simple string.
		.EXAMPLE
			Convert secure string to simple string.

			PS $secureStr = Read-Host -assecurestring "Enter password"
			PS get-BNTpass -Password $secureStr
			somePassword
		.NOTES
            Author: Dmitry Anisimov
            GitHub: https://github.com/made-with-care
            EMail: mail@anisimov.dk
            HomePage: https://www.anisimov.dk
		.LINK
			connect-BNTswitch
			set-BNTUserPassword
	#>
    param(
        $Password
    )
    if ($Password -is "System.Security.SecureString") {
        return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
    }
    else { return $Password }
}