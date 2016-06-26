# BNT Tools
## Description
Powershell module that leverages telnet connection for managing BNT Layer 2/3 Copper Gigabit Ethernet Switch Module for IBM BladeCenter. 

## Install
Download and import module:
<pre>PS Import-Module path/to/module/BNT-Tools.psm1</pre>

## Supported device
|**Model**                                                              |**Part Number**|**Tested**  |
|-----------------------------------------------------------------------|:-------------:|:----------:|
|BNT Layer 2/3 Copper Gigabit Ethernet Switch Module for IBM BladeCenter|32R1866        |Work        |

## Features
* Connect to switch module through Telnet with local or RADIUS authentication - **connect-BNTswitch**;
* Execute custom Telnet command - **Invoke-BNTcmd**;
* Catching errors - **get-BNTError**;
* Apply/save switch configuration and disconnect from switch - **disconnect-BNTswitch**;
* Configure `NTP` client - **set-BNTNtp**;
* Configure `RADIUS` authentication - **set-BNTRadius**;
* Configure `SNMPv1` settings - **set-BNTSNMPv1**;
* Configure `Syslog` logging - **set-BNTSyslog**;
* Configure `Timezone` and *daylight savings* - **set-BNTtimezone**;
* Change user password - **set-BNTUserPassword**;

## Contact
Author: Dmitry Anisimov</br>
GitHub: https://github.com/made-with-care</br>
EMail: mail@anisimov.dk</br>
HomePage: https://www.anisimov.dk