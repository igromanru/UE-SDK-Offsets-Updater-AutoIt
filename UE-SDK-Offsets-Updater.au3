#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.14.5
 Author:         Igromanru
 Script Function:
	Automatically updates an Offsets class which has a special format.
#ce ----------------------------------------------------------------------------

#include <MsgBoxConstants.au3>
#include <FileConstants.au3>

Global Const $TITLE = "Unreal Engine Offsets Updater"

If $CmdLine[0] > 1 Then
	ConsoleWrite("Offsets.h path: " & $CmdLine[1] & @CRLF)
	ConsoleWrite("SDK source path: " & $CmdLine[2] & @CRLF)
	UpdateOffsets($CmdLine[1], $CmdLine[2])
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

Func UpdateOffsets($OffsetsFilePath, $SdkPath)
	If FileExists($OffsetsFilePath) = 0 Then
		MsgBox($MB_ICONWARNING, $TITLE, "Offsets file " & $OffsetsFilePath & " doesn't exists")
		Return
	EndIf
	If FileExists($SdkPath) = 0 Then
		MsgBox($MB_ICONWARNING, $TITLE, "SDK directory " & $SdkPath & " doesn't exists")
		Return
	EndIf

	Local $offsetsFile = FileOpen($BASIC_CPP, $FO_READ + $FO_UTF8_NOBOM)
	Local $offsetsFileArray = FileReadToArray($offsetsFile)
	FileClose($offsetsFile)
	For $i = 0 To UBound($offsetsFileArray)-1
		; ToDo
	Next
	$offsetsFile = FileOpen($BASIC_CPP, $FO_OVERWRITE + $FO_UTF8_NOBOM)
	_FileWriteFromArray($offsetsFile, $offsetsFileArray)
	FileClose($offsetsFile)
EndFunc