#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.14.5
 Author:         Igromanru
 Script Function:
	Automatically updates an Offsets class which has a special format.
#ce ----------------------------------------------------------------------------

#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <StringConstants.au3>
#include <File.au3>

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
	MsgBox($MB_ICONWARNING, $TITLE, "Not enough parameters were passed (" & $CmdLine[0] & ")")
EndIf

Func UpdateOffsets($OffsetsFilePath, $SdkPath)
	If FileExists($OffsetsFilePath) = 0 Then
		$OffsetsFilePath = @ScriptDir & "\" & $OffsetsFilePath
		If FileExists($OffsetsFilePath) = 0 Then
			MsgBox($MB_ICONWARNING, $TITLE, "Offsets file " & $OffsetsFilePath & " doesn't exists")
			Return
		EndIf
	EndIf
	If FileExists($SdkPath) = 0 Then
		MsgBox($MB_ICONWARNING, $TITLE, "SDK directory " & $SdkPath & " doesn't exists")
		Return
	EndIf

	Local $offsetsFile = FileOpen($OffsetsFilePath, $FO_READ + $FO_UTF8_NOBOM)
	Local $offsetsFileArray = FileReadToArray($offsetsFile)
	FileClose($offsetsFile)
	For $i = 0 To UBound($offsetsFileArray) - 1
		Local $offsetInfo = StringRegExp($offsetsFileArray[$i], "\/\/ ?:(.*?):(.*?):(.*?)$", $STR_REGEXPARRAYMATCH)
		If Not @error Then
			If UBound($offsetInfo) > 2 Then
				Local $offset = GetOffsetFromSdk($offsetInfo, $SdkPath)
				$i += 1
				Local $updatedString = StringRegExpReplace($offsetsFileArray[$i], "0x.*?;", "0x" & $offset & ";")
				If Not @error Then
					$offsetsFileArray[$i] = $updatedString
				EndIf
				ConsoleWrite($offsetsFileArray[$i] & @CRLF)
			Else
				MsgBox($MB_ICONWARNING, $TITLE, $offsetsFileArray[$i] & " is not a valid offset tag")
			EndIf
		EndIf
	Next
	$offsetsFile = FileOpen($OffsetsFilePath, $FO_OVERWRITE + $FO_UTF8_NOBOM)
	_FileWriteFromArray($offsetsFile, $offsetsFileArray)
	FileClose($offsetsFile)
	MsgBox(0, $TITLE, "Offsets Update complete")
EndFunc   ;==>UpdateOffsets

Func GetOffsetFromSdk($offsetInfo, $SdkPath)
	Local $result = "error"
	If UBound($offsetInfo) > 2 Then
		If StringRight($SdkPath, 1) <> "\" Or StringRight($SdkPath, 1) <> "/" Then
			$SdkPath &= "\"
		EndIf
		Local $class = $offsetInfo[0]
		Local $field = $offsetInfo[1]
		Local $file = $SdkPath & $offsetInfo[2]
		Local $fileHandle = FileOpen($file, $FO_READ + $FO_UTF8_NOBOM)
		Local $fileArray = FileReadToArray($fileHandle)
		Local $searchForOffset = False
		FileClose($fileHandle)
		For $i = 0 To UBound($fileArray) - 1
			If Not $searchForOffset Then
				Local $isRightClass = StringRegExp($fileArray[$i], "^(?:class|struct) " & $class & "(?:\s|$)", $STR_REGEXPMATCH)
				If $isRightClass = 1 Then
					$searchForOffset = True
				EndIf
			Else
				Local $match = StringRegExp($fileArray[$i], ".*?" & $field & ";.*? \/\/ 0x(.*?)\(0x", $STR_REGEXPARRAYMATCH)
				If Not @error Then
					$result = $match[0]
					ExitLoop
				EndIf
			EndIf
		Next
	EndIf
	Return $result
EndFunc   ;==>GetOffsetFromSdk
