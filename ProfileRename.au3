#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Oxygen-Icons.org-Oxygen-Status-script-error.ico
#AutoIt3Wrapper_Outfile_x64=RenameProfile.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <MsgBoxConstants.au3>
Global $sFileSelectFolder
Example1()
$usn1 = StringLen($sFileSelectFolder)
$usn2 = $usn1 - 9
$usn = StringRight($sFileSelectFolder, $usn2)
$sSearch = $usn

For $i = 1 To 100
	If FileExists($sFileSelectFolder & $i) Then
		ContinueLoop
	Else
		DirMove($sFileSelectFolder, $sFileSelectFolder & $i)
	EndIf
Next

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


Func Example1()
	Global $sFi
	; Create a constant variable in Local scope of the message to display in FileSelectFolder.
	Local Const $sMessage = "Select The Profile to Rename"

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

