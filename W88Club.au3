#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Images\roulette.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ImageSearch.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>
#include <Date.au3>

;~ MsgBox($MB_OK, "Tutorial", "Hello World!")
HotKeySet("{PGUP}","_Begin")
HotKeySet("^{PGUP}","_fixB4Start")
HotKeySet("{INSERT}","_goToRoulette")
HotKeySet("^{INSERT}","_fixB4goTo")
HotKeySet("{PAUSE}", "_Pause")
HotKeySet("{PGDN}", "_Exit")

$X =0
$Y =0
Global 	$CheckNet = true  			;��������ʶҹ���
Global  $Money = 0                  ;�Թ�ҧ����ѹ  - ���������� 0 �ҷ
Global  $dropMoney = 2
Global  $timeRestart				;�Ѻ������ Restart
Global  $profitNow = 0				;���ҧ����ҡ��� �ú 200 �ҷ���ѡ
Global  $profitPerRound =  Random(100,150,1)  ; profit 150 - 250 bath per round
Global 	$filePath = @ScriptDir&"\LogFile\BetMoney.txt"
While 1  ;��ش�͡�á� start
	local $text =  'Start [PGUP]  Start&fill [Ctrl+PGUP]'&@LF
		  $text &= 'Run First Time [INSERT] First&Fill [Ctrl+INSERT]'&@LF
		  $text &= 'Pause [PAUSE]'&@LF
		  $text &= 'EXIT [PGDN]'&@LF
	ToolTip($text, 19,0 )
    Sleep(4*60*1000)  ;�� 4 �ҷ� ����ѧ��衴 Bot ��������ӧҹ
	Send("^{INSERT}")
WEnd

Func _Begin()
	_FileWriteLog(@ScriptDir & "\LogFile\LogData.log", "Start Bot")  ;��ʶҹ��Դ�ͷ ŧ���� .log
    Start()
	;_goToRoulette()


EndFunc

func _fixB4goTo()
	ToolTip('Fix Money = 10.1 ', 50,0 )
	$Money = 10.1
	goWriteFile()
	_goToRoulette()
EndFunc

Func _fixB4Start()
	ToolTip('Fix Money = 10.1 ', 50,0 )
	$Money = 10.1
	goWriteFile()
	Start()
EndFunc


func _goToRoulette()
	$dropMoney = Random(1,3,1)	;������á���random ����ҧ�Թ
	$profitPerRound =   Random(100,150,1)  ; profit 100- 150 bath per round
	;-----------------------------------------------------
	sleep(1000)
	ToolTip('Go to Roulette ', 50,0 )
	Run("C:\Program Files\Google\Chrome\Application\chrome.exe C:\Users\minipc\Desktop\W88\W88Login.htm") ; run imacro
	Local $hTimer = TimerInit()  ;������Ѻ����
	While 1
		if search_area("areaMiddle") Then ExitLoop
		if TimerDiff($hTimer) > 3*60*1000 Then  ;������ٻ������Թ 3 �ҷ� ����Ѻ价ӧҹ����
			_goToRoulette()
		EndIf
		sleep(1000)
	WEnd
	Start()

EndFunc

Func Start()
	ToolTip('InternetCheck ', 19,0 )
	InternetCheck ()
	ToolTip('Bot Start ', 19,0 )
	$timeRestart = TimerInit()  ;������Ѻ����
	While 1
		While 1
			Local $hTimer = TimerInit()  ;������Ѻ����
			if  search_area("countdownTime") And search_area("fillMoney")  Then  ; ��ҵ�ǨѺ��������¹���մ� ��� ��ͧ����Թ���բ��
				ToolTip('New Round ', 50,0 )
				local $moneyOnFile  = FileReadLine($filePath,1)  ;�Դ���֧���
				If search_area("menuNow10-200THB") and $moneyOnFile > 200 Then
					click_picture("menuRoulette")
					click_picture("menu100-2000THB")
				ElseIf search_area("menuNow100-2000THB") and $moneyOnFile < 200 Then
					click_picture("menuRoulette")
					click_picture("menu10-200THB")
				EndIf
				sleep(500)
				click_picture("fillMoney")
				Sleep(300)
				send(Floor($moneyOnFile)) ;����Թ㹪�ͧ
				$Money = $moneyOnFile  ;᷹���㹵���� ����������
				FileClose($filePath) ;�Դ File
				Sleep(1000)
				send("{ENTER}")
				Sleep(300)
					if $dropMoney == 1 then
						click_picture("areaLeft")
					ElseIf $dropMoney == 2 then
						click_picture("areaMiddle")
					ElseIf $dropMoney == 3 then
						click_picture("areaRight")
					EndIf
				click_picture("submitButton") ;��ԡ���� �׹�ѹ
				ExitLoop
			EndIf
			if TimerDiff($hTimer) > 4*60*1000 Then  ;������ٻ������Թ 4 �ҷ� ����Ѻ价ӧҹ����
				_goToRoulette()
			EndIf
		WEnd

		local $winStatus = false     ; �纤��ʶҹ���� �ͺ��骹��������
		ToolTip('Wait Wait '&$Money&" THB", 50,0 )

		While 1
			sleep(100)
			$p1 =PixelSearch(155, 417,1024, 667,0x854120)
			if Not @error Then
				if $p1[0] >303 And $p1[0] < 532 And $dropMoney = 1 Then
					ToolTip('Left', 50,0 )
					$winStatus = true
				ElseIf $p1[0] >532 And $p1[0] < 757 And $dropMoney = 2 Then
					ToolTip('Middle', 50,0 )
					$winStatus = true
				ElseIf $p1[0] > 757 And $dropMoney = 3 Then
					ToolTip('Right', 50,0 )
					$winStatus = true
				EndIf
				ExitLoop
			EndIf
		Wend
		if  $winStatus == true Then
			ToolTip('!!! Win !!!!', 50,0 )

			if $Money > 583   Then
				_FileWriteLog(@ScriptDir & "\LogFile\LogData.log", "Warning")  ;��ʶҹ�� ŧ���� .log
				goWriteFile()
				warning ()
			EndIf

			if($Money == "10.1") then
				$profitNow += 20
			else
				$profitNow += 10
			EndIf

			If $profitNow >= $profitPerRound then

				_FileWriteLog(@ScriptDir & "\LogFile\LogData.log", "Profit in day "&$profitNow&" Bath")
				goWriteFile("TotalProfit")
				$Money = 10.1
				goWriteFile()

				Local $rantime = Random(60,180,1)	;random ˹�ǧ����
				$rantime = ($rantime*60)
				While ($rantime>=0)
					Sleep(1000)
					ToolTip("Congreat "&$profitNow&" Bath "& $rantime, 1,0 )
					$rantime-=1
				WEnd
				$profitNow =0
				_goToRoulette()
			EndIf
			goWriteFile("TotalProfit")

			$Money = 10.1  ;᷹��ҵç������� �����ش���¡�͹ restart ��� txt ��
			$dropMoney = Random(1,3,1)  ; random ��ͧ�ҧ�Թ��������ͪ��
		EndIf
 		sleep(5*1000)

		if $winStatus == true Then 			;��Ҫ�� �Թ����ѹ����¹�� 10.1 ��m
			$Money = 10.1
		else    							; ����� �����Թ����ѹ
			If  $Money == 10.1 then
				$Money = 10.2
			ElseIf $Money == 10.2 then
				$Money = 15
			ElseIf $Money == 15 then
				$Money = 23
			ElseIf $Money == 23 then
				$Money = 34
			ElseIf $Money == 34 then
				$Money = 51
			ElseIf $Money == 51 then
				$Money = 77
			ElseIf $Money == 77 then
				$Money = 115
			ElseIf $Money == 115 then
				$Money = 173
			ElseIf $Money == 173 then
				$Money = 259
			ElseIf $Money == 259 then
				$Money = 389
			ElseIf $Money == 389 then
				$Money = 583
			ElseIf $Money == 583 then
				$Money = 875
			ElseIf $Money == 875 then
				$Money = 1312
			ElseIf $Money == 1312 then
				$Money = 1968
			ElseIf $Money == 1968 then
				Exit 0
			EndIf
		EndIf

		goWriteFile()

		If ( TimerDiff($timeRestart)  >= (30*60*1000) ) And $winStatus == true  then
			_goToRoulette()
		EndIf
	WEnd
EndFunc

Func warning ()
	local $delayTime = 60*60 ;��ش��� 60 �ҷ�
	while 1
		ToolTip("!!! WARNING !!! "&Round(($delayTime/60),2), 1,0 )
		Sleep (1000)
		if $delayTime <= 0 Then _goToRoulette()
		$delayTime-=1
	WEnd
EndFunc

Func goWriteFile($menu="BetMoney")
	if $menu == "BetMoney" Then
		Local $fileOpen = FileOpen($filePath,2)
		FileWrite($fileOpen, $Money)
		FileClose($filePath) ;�Դ File
	ElseIf $menu =="TotalProfit" Then
		Local $filePatTotalProfit = @ScriptDir&"\LogFile\TotalProfit.txt"
		local $time  = FileReadLine($filePatTotalProfit,1)  ;�Դ���֧���
		local $TotalProfit  = FileReadLine($filePatTotalProfit,2)  ;�Դ���֧���
		if _NowDate() == $time and $totalProfit < 1000 then      ;���������ѹ���ǡѹ
			if($Money == "10.1") then
				$TotalProfit += 20
			else
				$TotalProfit += 10
			EndIf
			ElseIf  _NowDate() == $time and $totalProfit >= 1000 Then
				_FileWriteLog(@ScriptDir & "\LogFile\LogData.log", "Congreat 1000 Bath This time")
				$Money = 10.1
				goWriteFile()
				Local $waittime = ( (((24-@HOUR)*60) + (Random(60,180,1))) *60)  ; find time and + random  time 1-3 hr
				While ($waittime>=0)
					Sleep(1000)
					ToolTip("Congreat Wait Next Day "& $waittime, 1,0 )
					$waittime-=1
				WEnd
				_goToRoulette()
		ElseIf  _NowDate() <> $time then
			$time = _NowDate()
			$TotalProfit = 0
		EndIf
			Local $fileOpenTotalProfit = FileOpen($filePatTotalProfit,2)
			FileWriteLine($fileOpenTotalProfit ,$time)
			FileWriteLine($fileOpenTotalProfit ,$totalProfit)
			FileClose($fileOpenTotalProfit) ;�Դ File
	EndIf

EndFunc

Func InternetCheck ()  ;���ѭ�ҳ Internet
	while 1  ; �� internet ping�google  ��� ping����������� 10�� ����ping���訹���ҨеԴ
		Local $iPing = Ping("google.com", 1000)
		If $iPing Then
			If (Not $CheckNet) Then  ;��������͹䢹��  ����� net lost �ҡ�͹
				_FileWriteLog(@ScriptDir & "\LogFile\LogData.log", "Internet Connect")  ;��ʶҹ��Դ�ͷ ŧ���� .log
				$CheckNet = Not $CheckNet  ;��Ѻʶҹ�
			EndIf
			ExitLoop
		Else
			ToolTip('Internet Lost ', 19,0 )
			If ( $CheckNet ) Then   ;��������͹� ����� internet lost
				_FileWriteLog(@ScriptDir & "\LogFile\LogData.log", "Internet Lost")  ;��ʶҹ��Դ�ͷ ŧ���� .log
				$CheckNet = Not $CheckNet  ;��Ѻʶҹ�
			EndIf
			Sleep(10000)
		EndIf
	WEnd
EndFunc

Func click_picture($p_name)  ; ��ԡ�ٻ�Ҿ���㹾�鹷��ͧ �ͧ app adpocket

	Local $hTimer = TimerInit()  ;������Ѻ����
	while 1
		$Search = _ImageSearch(@ScriptDir &"\Images\"&$p_name&'.bmp',1,$X,$Y,2)
		IF $Search = 1  Then
			MouseClick("left",$X, $Y,1,2)
			ExitLoop

		ElseIf TimerDiff($hTimer) > 60000 Then   ;������ٻ������Թ 60 �� ����Ѻ价ӧҹ����
			_goToRoulette()
		EndIf
         ToolTip("Pic "& $p_name& Round((TimerDiff($hTimer)/1000),1), 1,0 )
		sleep (400)
	WEnd
    Sleep(300)
 EndFunc

Func search_area($p_name)  ;���ٻ�Ҿ���㹾�鹷��ͧ app adpocket
		Return  _ImageSearch(@ScriptDir &"\Images\"&$p_name&'.bmp',1,$X,$Y,2)
    Sleep(300)
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
	_FileWriteLog(@ScriptDir &"\LogFile\LogData.log", "Close Bot")  ;��ʶҹлԴ�ͷ  ŧ���� .log
    Exit 0
EndFunc