#------------------------------------------------------
#---------DEVLOPED BY SAM MULDROW #DSL4LIFE -----------
#------------------------------------------------------
Add-Type -AssemblyName System.Windows.Forms
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]

public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]

public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
function Hide-Console {

   $consolePtr = [Console.Window]::GetConsoleWindow()

 #0 hide

[Console.Window]::ShowWindow($consolePtr, 0)

}
Hide-Console
Start-Sleep -Seconds 3
$result = [System.Windows.Forms.MessageBox]::Show('L0L TA1E A5 0LD A5 T1M3')
Start-Sleep -Seconds 5
Stop-Computer -ComputerName localhost