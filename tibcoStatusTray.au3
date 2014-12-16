; Description: Shows status of Tibco Admin, EMS, Hawk and RV
; Version: 0.1
; Author: Hannes Lehmann
;
;

#NoTrayIcon
#include <MsgBoxConstants.au3>
#include <Constants.au3>
#include <TrayConstants.au3> ; Required for the $TRAY_CHECKED and $TRAY_ICONSTATE_SHOW constants.

Opt("TrayMenuMode", 3) ; The default tray menu items will not be shown and items are not checked when selected. These are options 1 and 2 for TrayMenuMode.
Opt("TrayOnEventMode", 1) ; Enable TrayOnEventMode.

Dim $procs[7] = ["rvd", "tibhawkhma", "hawkagent", "tibemsd", "mysqld", "jenkins", "tibcoadmin" ]
Dim $names[7] = ["Rendezvous", "Hawk Microagent", "Hawk", "EMS", "MySQL", "Jenkins", "Tibco Admin"]
Dim $trayItems[7]
Dim $idInfos, $idAbout, $idExit

$list = ProcessList()

For $i = 0 to UBound($procs) - 1 ; We have an array with three elements but the last index is two.
   $trayItems[$i] = TrayCreateItem($names[$i], -1, -1, 0)
   TrayItemSetState(-1, $TRAY_DISABLE)
   For $j = 1 To $list[0][0]
	  If StringRegExp($list[$j][0], "^" & $procs[$i]) Then TrayItemSetState(-1, $TRAY_ENABLE)
   Next
Next
TrayCreateItem("") ; Create a separator line.
$idInfos = TrayCreateItem("Info")
TrayCreateItem("") ; Create a separator line.
$idAbout = TrayCreateItem("About")
TrayCreateItem("") ; Create a separator line.
$idExit = TrayCreateItem("Exit")
TraySetState($TRAY_ICONSTATE_SHOW) ; Show the tray menu.

TraySetOnEvent ( $TRAY_EVENT_MOUSEOVER, "_UpdateTray" )

While True
   Switch TrayGetMsg()
	  Case $idAbout ; Display a message box about the AutoIt version and installation path of the AutoIt executable.
		 MsgBox($MB_SYSTEMMODAL, "", "AutoIt Tibco Dev Status." & @CRLF & @CRLF & _
                        "Autoit-Version: " & @AutoItVersion & @CRLF & _
                        "Install Path: " & StringLeft(@AutoItExe, StringInStr(@AutoItExe, "\", 0, -1) - 1)) ; Find the folder of a full path.
	  Case $idInfos ; Display a message box about the AutoIt version and installation path of the AutoIt executable.
		 MsgBox($MB_SYSTEMMODAL, "", "TIBCO Env Infos:" & @CRLF & @CRLF & netstat("tibcoadmin") & @CRLF)
	  Case $idExit
		 ExitLoop
   EndSwitch
Wend

Func netstat($sProcess)
   Local $CMD, $CMDRead = "", $sReturn = ""
   $CMD = Run(@ComSpec & " /c netstat -a -o -n -b ", @SystemDir, @SW_HIDE, $STDOUT_CHILD)
   While 1
	  $CMDRead = StdoutRead($CMD)
	  If StringInStr($CMDRead, $sProcess)> 0 Then $sReturn &= $CMDRead
	  If @error Then ExitLoop
   WEnd
   Return $CMDRead
EndFunc   ;==>Example

 Func _UpdateTray()
   $list = ProcessList()
   For $i = 0 to UBound($procs) - 1 ; We have an array with three elements but the last index is two.
	  TrayItemSetState( $trayItems[$i], $TRAY_DISABLE)
	  For $j = 1 To $list[0][0]
		 If StringRegExp($list[$j][0], "^" & $procs[$i]) Then TrayItemSetState( $trayItems[$i], $TRAY_ENABLE)
	  Next
   Next
EndFunc   ;==>Example

