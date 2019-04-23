#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.14.5
 Author:         Igromanru
 Script Function:
	Automatically updates an Offsets class which has a special format.
#ce ----------------------------------------------------------------------------

#include <MsgBoxConstants.au3>

Global Const $TITLE = "Unreal Engine Offsets Updater"

If $CmdLine[0] > 1 Then
	ConsoleWrite("Offsets.h path: " & $CmdLine[1] & @CRLF)
	ConsoleWrite("SDK source path: " & $CmdLine[2] & @CRLF)
Else
	ConsoleWrite("Total params: " & $CmdLine[0] & @CRLF)
	If $CmdLine[0] > 0 Then
		ConsoleWrite("First param: " & $CmdLine[1] & @CRLF)
	EndIf
	If $CmdLine[0] > 1 Then
		ConsoleWrite("Second param: " & $CmdLine[2] & @CRLF)
	EndIf
	MsgBox($MB_ICONWARNING, $TITLE, "Not enough parameters were passed ("&$CmdLine[0]&")")
EndIf