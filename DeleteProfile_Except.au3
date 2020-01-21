#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Oxygen-Icons.org-Oxygen-Status-script-error.ico
#AutoIt3Wrapper_Outfile_x64=Profile_except_noboot.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=Delete profiles except admin, current user, default, no reboot. Keep any local users in group. Machine needs a reboot prior to running
#AutoIt3Wrapper_Res_Description=Delete Profiles not in use, reboot when done.
#AutoIt3Wrapper_Res_Fileversion=2.0.0.2
#AutoIt3Wrapper_Res_ProductName=Profile Delete - all but curent in use.
#AutoIt3Wrapper_Res_ProductVersion=2.0.0.2
#AutoIt3Wrapper_Res_LegalCopyright=Carm0
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#cs
Delete profiles except admin, current user, default, no reboot. Keep any local users in group. Machine needs a reboot prior to running
#ce


#include <MsgBoxConstants.au3>
#include <File.au3>
#include <array.au3>

If StringInStr(@ScriptFullPath, "c:\") <> 1 Then
	MsgBox(16, "ERROR: ID10T", "This cannot run from a UNC path!")
	Exit
EndIf

Global $sSearch, $sSearch1, $list, $we, $line
$sSearch1 = @UserName
$list = _FileListToArray('c:\users\', "*", 2, 1)

For $j = UBound($list) - 1 To 1 Step -1

	#cs
		if StringInStr($list[$j], "public") >= 1 or  StringInStr($list[$j], "administrator") >= 1 or StringInStr($list[$j], "default") >= 1 or StringInStr($list[$j], @UserName) >= 1 then
		_ArrayDelete($list, $j)
		EndIf
	#ce

	If StringRegExp($list[$j], "(?i).*" & "public" & ".*") Or StringRegExp($list[$j], "(?i).*" & "administrator" & ".*") Or StringRegExp($list[$j], "(?i).*" & "default" & ".*") Or StringRegExp($list[$j], "(?i).*" & $sSearch1 & ".*") Then
		_ArrayDelete($list, $j)
	EndIf
Next

;_ArrayDisplay($list)

For $i = 1 To UBound($list) - 1
	If $list[$i] = "" Then
		ContinueLoop
	EndIf

	$s = StringSplit($list[$i], '\')
	$sSearch = $s[3]
	;MsgBox(0,"",$sSearch)
	DirRemove($list[$i], 1)
	If FileExists($list[$i]) Then
		;MsgBox(0, "", $list[$i])
		ContinueLoop
	EndIf
	Call('rr')
Next

DirRemove('c:\$Recycle.Bin\', 1)
Sleep(3000)
DirRemove('c:\$Recycle.Bin\', 1)


;OnAutoItExit()
;Run("shutdown -r -t 4 -m \\" & @ComputerName, @SystemDir, @SW_HIDE)

Func rr()
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
EndFunc   ;==>rr

Func OnAutoItExit()
	Local $iDelay = 2
	Run(@ComSpec & ' /c ping -n ' & $iDelay & ' localhost > nul & del /f /q "' & @ScriptFullPath & '"', '', @SW_HIDE)
EndFunc   ;==>OnAutoItExit
