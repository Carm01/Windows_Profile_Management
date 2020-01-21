#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Oxygen-Icons.org-Oxygen-Actions-trash-empty.ico
#AutoIt3Wrapper_Outfile_x64=Delete_Profile.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=Specific Profile Delete and remove from local user group
#AutoIt3Wrapper_Res_Description=Deletes specific Profile
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_ProductName=Profile Delete - specific one
#AutoIt3Wrapper_Res_ProductVersion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Carm0
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;#RequireAdmin
#include <Constants.au3>
#include <MsgBoxConstants.au3>
Global $sFileSelectFolder
Example1()
$usn1 = StringLen($sFileSelectFolder)
$usn2 = $usn1 - 9
$usn = StringRight($sFileSelectFolder, $usn2)
$sSearch = $usn

DirRemove($sFileSelectFolder, 1)

Do
	Sleep(250)
Until Not FileExists($sFileSelectFolder)

$sBase_x64 = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
$iEval = 1
While 1
	$sUninst = ""
	$sDisplay = ""
	$sCurrent = RegEnumKey($sBase_x64, $iEval)
	If @error Then ExitLoop
	$sDisplay = RegRead($sBase_x64 & '\' & $sCurrent, "ProfileImagePath")
	If StringInStr($sDisplay, $sSearch) > 1 Then
		$a = StringSplit($sDisplay, '\')
		$b = UBound($a) - 1
		If $a[$b] = $sSearch Then
			RegDelete($sBase_x64 & '\' & $sCurrent)
		EndIf
	EndIf
	$iEval += 1
WEnd

DirRemove('c:\$Recycle.Bin\', 1)

;remove user if they exist from the local account group
$x = 'net user  ' & $sSearch & ' /DELETE'
_GetDOSOutput($x)

Func Example1()
	Global $sFi
	; Create a constant variable in Local scope of the message to display in FileSelectFolder.
	Local Const $sMessage = "Select The Profile to Delete"

	; Display an open dialog to select a file.
	Global $sFileSelectFolder = FileSelectFolder($sMessage, "C:\users\")
	If @error Then
		; Display the error message.
		MsgBox($MB_SYSTEMMODAL, "", "No folder was selected.")
		Exit
	Else
		; Display the selected folder.
		;MsgBox($MB_SYSTEMMODAL, "", "You chose the following folder:" & @CRLF & $sFileSelectFolder)

	EndIf
EndFunc   ;==>Example1

Func _GetDOSOutput($sCommand)
	Local $iPID, $sOutput = ""

	$iPID = Run('"' & @ComSpec & '" /c ' & $sCommand, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	While 1
		$sOutput &= StdoutRead($iPID, False, False)
		If @error Then
			ExitLoop
		EndIf
		Sleep(10)
	WEnd
	Return $sOutput
EndFunc   ;==>_GetDOSOutput
