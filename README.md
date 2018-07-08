# PSscript-WinServiceOperation

#Description:

PSscript-WinServiceOperation script it's great method can help you to control Windows services via Command Line or GUI no matter locally/remotely or deal with one server/service or many, also it has many different options can support you to let manage Windows services more easy such as filter output to get require information about a servcie by display options feature, as it usefully to run required services before start needed one. it included more to get you enjoy to deal with services instead of keep it last priority.


#Prerequisite:
- Open PowerShell as administrator.
- PS verion should be 3 or above.
  You can verify PS version by command "$PSVersionTable".
  You can upgrade PS version after install Windows Management Framework by url (https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell?view=powershell-6)
- Verify WinRM service is running on remote servers by command "winrm qc", and enable PSremoting by command "Enable-PSRemoting", with considering open concern ports through firewall.
- Create new module folders as same as module script files name to import script file into it.
  module folder can be under your powershell profile path, so you can get create powershell profile path by use command     "$env:PSModulePath.split(";")[0]"

#Instruction:

- Import module by command "import-module -name FormWinSvceFunctions.psm1" or by "import-module -name WinSvceFunctions.psm1".
- Get list of available commands by execute command "get-command -module FormWinSvceFunctions" or "get-command -module WinSvceFunctions".
- Run command "Show-FormWinSvce" to open WinSvce operation form, or you use available commands by WinSvceFunctions module.

#Note:
- FormWinSvceFunctions module is script file to do your operations by GUI.
- WinSvceFunctions module is script file to execute command lines.
