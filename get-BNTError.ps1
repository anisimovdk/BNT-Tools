function get-BNTError{
	<#
		.SYNOPSIS
			Get errors from Invoke-BNTcmd output.
		.DESCRIPTION
			Use get-BNTError to analyze Invoke-BNTcmd output for errors.
			Display errors if occurred, return $false if no errors.
		.PARAMETER Log
			Invoke-BNTcmd command output.
		.EXAMPLE
			Get errors from custom command.
			If errors occurred - disconnect from switch without applying and saving.
			If no errors save and apply configuration before disconnect.

            ScriptBlock:
            $con = connect-BNTswitch -RemoteHost "192.168.1.10"
            $cmds = @("/cfg/sys/ntp/","prisrv 192.168.1.1")
            $output = Invoke-BNTcmd -Commands $cmds -Stream $con
            if (!(get-BNTError($output))) {
                Write-Host "Command executed without errors."
                disconnect-BNTswitch -Stream $con -Apply -Save
            }
            else {disconnect-BNTswitch -Stream $con}

            Result:
            Login to 192.168.1.10:23 successful
			Command executed without errors
			New configuration applied.
            New configuration saved.
			Logout success.
		.NOTES
            Author: Dmitry Anisimov
            GitHub: https://github.com/made-with-care
            EMail: mail@anisimov.dk
            HomePage: https://www.anisimov.dk
	#>
    param(
        [parameter(mandatory=$true)]
        $Log
    )
    $errors = $Log.split([char]0x000A) | Select-String -Pattern "Error" -SimpleMatch
    if ($errors) {$errors | ForEach-Object {Write-Host $_ -ForegroundColor Red; return $errors}}
    else {return $false}
}