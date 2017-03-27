#include <ImageSearch.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>
#include <Date.au3>

;~ MsgBox($MB_OK, "Tutorial", "Hello World!")
HotKeySet("{PGUP}","_Begin")
HotKeySet("{PAUSE}", "_Pause")
HotKeySet("{PGDN}", "_Exit")
 Global $X =0
 Global $Y =0

While 1  ;หยุดรอการกด start
	local $text =  'Start [PGUP]  Start&fill [Ctrl+PGUP]'&@LF
		  $text &= 'Run First Time [INSERT]'&@LF
		  $text &= 'Pause [PAUSE]'&@LF
		  $text &= 'EXIT [PGDN]'&@LF
	ToolTip($text, 19,0 )
    Sleep(4*60*1000)  ;รอ 4 นาที ถ้ายังไม่กด Bot จะเริ่มทำงาน
	Send("^{INSERT}")
WEnd


Func _Begin()

while 1
	ToolTip('Start loop', 50,0 )
	$p1 =PixelSearch(155, 417,1024, 667,0x854120)
	if Not @error Then

		if $p1[0] >303 And $p1[0] < 532 Then
			ToolTip('Left', 50,0 )
			_FileWriteLog(@ScriptDir & "\LogFile\LogData.log", "Left")  ;เก็บสถานะเ ลงในไฟล์ .log
		ElseIf $p1[0] >532 And $p1[0] < 757 Then
			ToolTip('Middle', 50,0 )
			_FileWriteLog(@ScriptDir & "\LogFile\LogData.log", "Middle")  ;เก็บสถานะเ ลงในไฟล์ .log
		ElseIf $p1[0] > 757 Then
			ToolTip('Right', 50,0 )
			_FileWriteLog(@ScriptDir & "\LogFile\LogData.log", "Right")  ;เก็บสถานะเ ลงในไฟล์ .log
		EndIf
		sleep(30*1000)
	EndIf


WEnd

EndFunc

Func click_picture($p_name)  ; คลิกรูปภาพภายในพื้นที่ของ ของ app adpocket

	Local $hTimer = TimerInit()  ;เริ่มจับเวลา
	while 1
		$Search = _ImageSearch(@ScriptDir &"\Images\"&$p_name&'.bmp',1,$X,$Y,2)
		IF $Search = 1  Then
			MouseClick("left",$X, $Y,1,2)
			ExitLoop

		ElseIf TimerDiff($hTimer) > 60000 Then   ;ถ้าหารูปไม่เจอเกิน 60 วิ ให้กลับไปทำงานใหม่
			;_goToRoulette()
		EndIf
         ToolTip("Pic "& $p_name& Round((TimerDiff($hTimer)/1000),1), 1,0 )
		sleep (400)
	WEnd
    Sleep(300)
 EndFunc

Func search_area($p_name)  ;หารูปภาพภายในพื้นที่ของ app adpocket
	Return  _ImageSearch(@ScriptDir &"\Images\"&$p_name&'.bmp',1,$X,$Y,2)
    Sleep(100)
EndFunc

Func _Pause()
	Global $pssix
    $pssix = Not $pssix
    While $pssix
        Sleep(500)
        ToolTip('PAUSE', 19, 0)
    WEnd
    ToolTip("")
EndFunc

Func _Exit()
	_FileWriteLog(@ScriptDir &"\LogFile\LogData.log", "Close Bot")  ;เก็บสถานะปิดบอท  ลงในไฟล์ .log
    Exit 0
EndFunc