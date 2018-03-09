--[[
	---------------------------------------------------------
	Event counter takes any switch available in transmitter
	and count how many times it have been used. 
	
	Great for counting for example how many times retracts 
	have been used and to keep track of service-intervalls.
	
	Five counters are possible to configure, Counters 1 and 2
	can be used as telemetry window on main screen. Counters 
	1 and 2 also have an alarm possibility (Switch).
	
	Label can be configured for all counters and counter
	display is updated on app-screen per usage.
	
	Count can be adjusted manually from application itself
	if needed.
	
	Max value is 32767, after that counter resets to 0.
	
	Localisation-file has to be as /Apps/Lang/RCT-Cntr.jsn
	
	French translation courtesy from Daniel Memim
	Spanish translation courtesy from César Casado
	---------------------------------------------------------
	Event Counter is a part of RC-Thoughts Jeti Tools.
	---------------------------------------------------------
                Released under MIT-license by 
               Tero @ RC-Thoughts.com 2016-2017
	---------------------------------------------------------
--]]
collectgarbage()
----------------------------------------------------------------------
-- Locals for the application
local cnt1, cnt2, cnt3, cnt4, cnt5, cntAlm1, cntAlm2
local cntLb1, cntLb2, cntLb3, cntLb4, cntLb5
local cntSw1, cntSw2, cntSw3, cntSw4, cntSw5
local resSw1, resSw2, resSw3, resSw4, resSw5
local stateCnt1, stateCnt2, stateCnt3, stateCnt4, stateCnt5 = 0,0,0,0,0
----------------------------------------------------------------------
-- Read translations
local function setLanguage()
    local lng=system.getLocale()
    local file = io.readall("Apps/Lang/RCT-Cnt2.jsn")
    local obj = json.decode(file)
    if(obj) then
        trans1 = obj[lng] or obj[obj.default]
    end
end
----------------------------------------------------------------------
-- Draw telemetry screen for main display
local function printCounter1()
	lcd.drawText(145 - lcd.getTextWidth(FONT_BIG,string.format("%.0f", cnt1)),0,string.format("%.0f", cnt1),FONT_BIG)
end

local function printCounter2()
	lcd.drawText(145 - lcd.getTextWidth(FONT_BIG,string.format("%.0f", cnt2)),0,string.format("%.0f", cnt2),FONT_BIG)
end
----------------------------------------------------------------------
-- Store settings when changed by user
local function cntLbChanged1(value)
	cntLb1=value
	system.pSave("cntLb1",value)
	-- Redraw telemetrywindow if label is changed by user
	system.registerTelemetry(1,cntLb1,1,printCounter1)
end

local function cntLbChanged2(value)
	cntLb2=value
	system.pSave("cntLb2",value)
	-- Redraw telemetrywindow if label is changed by user
	system.registerTelemetry(2,cntLb2,1,printCounter2)
end

local function cntLbChanged3(value)
	cntLb3=value
	system.pSave("cntLb3",value)
end

local function cntLbChanged4(value)
	cntLb4=value
	system.pSave("cntLb4",value)
end

local function cntLbChanged5(value)
	cntLb5=value
	system.pSave("cntLb5",value)
end
--
local function almChanged1(value)
	cntAlm1=value
	system.pSave("cntAlm1",value)
end

local function almChanged2(value)
	cntAlm2=value
	system.pSave("cntAlm2",value)
end
--
local function cntChanged1(value)
	cnt1=value
	system.pSave("cnt1",value)
end

local function cntChanged2(value)
	cnt2=value
	system.pSave("cnt2",value)
end

local function cntChanged3(value)
	cnt3=value
	system.pSave("cnt3",value)
end

local function cntChanged4(value)
	cnt4=value
	system.pSave("cnt4",value)
end

local function cntChanged5(value)
	cnt5=value
	system.pSave("cnt5",value)
end
--
local function cntSwChanged1(value)
	cntSw1 = value
	system.pSave("cntSw1",value)
end

local function cntSwChanged2(value)
	cntSw2 = value
	system.pSave("cntSw2",value)
end

local function cntSwChanged3(value)
	cntSw3 = value
	system.pSave("cntSw3",value)
end

local function cntSwChanged4(value)
	cntSw4 = value
	system.pSave("cntSw4",value)
end

local function cntSwChanged5(value)
	cntSw5 = value
	system.pSave("cntSw5",value)
end
--
local function resSwChanged1(value)
	resSw1 = value
	system.pSave("resSw1",value)
end

local function resSwChanged2(value)
	resSw2 = value
	system.pSave("resSw2",value)
end

local function resSwChanged3(value)
	resSw3 = value
	system.pSave("resSw3",value)
end

local function resSwChanged4(value)
	resSw4 = value
	system.pSave("resSw4",value)
end

local function resSwChanged5(value)
	resSw5 = value
	system.pSave("resSw5",value)
end
----------------------------------------------------------------------
-- Draw the main form (Application inteface)
local function initForm()
	form.addRow(1)
	form.addLabel({label="---     RC-Thoughts Jeti Tools      ---",font=FONT_BIG})
	
	form.addRow(1)
	form.addLabel({label=trans1.counter1,font=FONT_BOLD})
	
	form.addRow(2)
	form.addLabel({label=trans1.labelW,width=175})
	form.addTextbox(cntLb1,14,cntLbChanged1)
	
	form.addRow(2)
	form.addLabel({label=trans1.switch,width=200})
	form.addInputbox(cntSw1,true,cntSwChanged1)
    
    form.addRow(2)
	form.addLabel({label=trans1.resSwitch,width=200})
	form.addInputbox(resSw1,true,resSwChanged1)
	
	form.addRow(2)
	form.addLabel({label=trans1.currentCnt})
	form.addIntbox(string.format("%f", cnt1),0,32767,0,0,1,cntChanged1)
	
	form.addRow(2)
	form.addLabel({label=trans1.almVal})
	form.addIntbox(string.format("%f", cntAlm1),0,32767,0,0,1,almChanged1)
	
	form.addRow(1)
	form.addLabel({label=trans1.counter2,font=FONT_BOLD})
	
	form.addRow(2)
	form.addLabel({label=trans1.labelW,width=175})
	form.addTextbox(cntLb2,14,cntLbChanged2)
	
	form.addRow(2)
	form.addLabel({label=trans1.switch,width=200})
	form.addInputbox(cntSw2,true,cntSwChanged2)
    
    form.addRow(2)
	form.addLabel({label=trans1.resSwitch,width=200})
	form.addInputbox(resSw2,true,resSwChanged2)
	
	form.addRow(2)
	form.addLabel({label=trans1.currentCnt})
	form.addIntbox(string.format("%f", cnt2),0,32767,0,0,1,cntChanged2)
	
	form.addRow(2)
	form.addLabel({label=trans1.almVal})
	form.addIntbox(string.format("%f", cntAlm2),0,32767,0,0,1,almChanged2)
	
	form.addRow(1)
	form.addLabel({label=trans1.counter3,font=FONT_BOLD})
	
	form.addRow(2)
	form.addLabel({label=trans1.counterName,width=175})
	form.addTextbox(cntLb3,14,cntLbChanged3)
	
	form.addRow(2)
	form.addLabel({label=trans1.switch,width=200})
	form.addInputbox(cntSw3,true,cntSwChanged3)
    
    form.addRow(2)
	form.addLabel({label=trans1.resSwitch,width=200})
	form.addInputbox(resSw3,true,resSwChanged3)
	
	form.addRow(2)
	form.addLabel({label=trans1.currentCnt})
	form.addIntbox(string.format("%f", cnt3),0,32767,0,0,1,cntChanged3)

	form.addRow(1)
	form.addLabel({label=trans1.counter4,font=FONT_BOLD})
	
	form.addRow(2)
	form.addLabel({label=trans1.counterName,width=175})
	form.addTextbox(cntLb4,14,cntLbChanged4)
	
	form.addRow(2)
	form.addLabel({label=trans1.switch,width=200})
	form.addInputbox(cntSw4,true,cntSwChanged4)
    
    form.addRow(2)
	form.addLabel({label=trans1.resSwitch,width=200})
	form.addInputbox(resSw4,true,resSwChanged4)
	
	form.addRow(2)
	form.addLabel({label=trans1.currentCnt})
	form.addIntbox(string.format("%f", cnt4),0,32767,0,0,1,cntChanged4)

	form.addRow(1)
	form.addLabel({label=trans1.counter5,font=FONT_BOLD})
	
	form.addRow(2)
	form.addLabel({label=trans1.counterName,width=175})
	form.addTextbox(cntLb5,14,cntLbChanged5)
	
	form.addRow(2)
	form.addLabel({label=trans1.switch,width=200})
	form.addInputbox(cntSw5,true,cntSwChanged5)
    
    form.addRow(2)
	form.addLabel({label=trans1.resSwitch,width=200})
	form.addInputbox(resSw5,true,resSwChanged5)
	
	form.addRow(2)
	form.addLabel({label=trans1.currentCnt})
	form.addIntbox(string.format("%f", cnt5),0,32767,0,0,1,cntChanged5)
	
	form.addRow(1)
	form.addLabel({label="Powered by RC-Thoughts.com - v."..cntrVersion.." ",font=FONT_MINI, alignRight=true})
end
----------------------------------------------------------------------
-- Runtime functions, read status of switches and store latching switch state
-- also resets count if reaches over 32767 and takes care of counter switches
local function loop()
	local cntSw1, cntSw2, cntSw3, cntSw4, cntSw5 = system.getInputsVal(cntSw1, cntSw2, cntSw3, cntSw4, cntSw5)
	local resSw1, resSw2, resSw3, resSw4, resSw5 = system.getInputsVal(resSw1, resSw2, resSw3, resSw4, resSw5)
    
	if (cntSw1 == 1 and stateCnt1 == 0) then
		stateCnt1 = 1
		cnt1 = cnt1 + 1
		if (cnt1 == 32768) then
			cnt1 = 0
		end
		system.pSave("cnt1",cnt1)
		form.reinit()
		else if (cntSw1 ~= 1 and stateCnt1 == 1) then
			stateCnt1 = 0
		end
	end	
    
    if (resSw1 == 1) then
        cnt1 = 0
        system.pSave("cnt1",0)
        form.reinit()
    end
	
	if (cntSw2 == 1 and stateCnt2 == 0) then
		stateCnt2 = 1
		cnt2 = cnt2 + 1
		if (cnt2 == 32768) then
			cnt2 = 0
		end
		system.pSave("cnt2",cnt2)
		form.reinit()
		else if (cntSw2 ~= 1 and stateCnt2 == 1) then
			stateCnt2 = 0
		end
	end
    
    if (resSw2 == 1) then
        cnt2 = 0
        system.pSave("cnt2",0)
        form.reinit()
    end
	
	if (cntSw3 == 1 and stateCnt3 == 0) then
		stateCnt3 = 1
		cnt3 = cnt3 + 1
		if (cnt3 == 32768) then
			cnt3 = 0
		end
		system.pSave("cnt3",cnt3)
		form.reinit()
		else if (cntSw3 ~= 1 and stateCnt3 == 1) then
			stateCnt3 = 0
		end
	end
    
    if (resSw3 == 1) then
        cnt3 = 0
        system.pSave("cnt3",0)
        form.reinit()
    end
	
	if (cntSw4 == 1 and stateCnt4 == 0) then
		stateCnt4 = 1
		cnt4 = cnt4 + 1
		if (cnt4 == 32768) then
			cnt4 = 0
		end
		system.pSave("cnt4",cnt4)
		form.reinit()
		else if (cntSw4 ~= 1 and stateCnt4 == 1) then
			stateCnt4 = 0
		end
	end
    
    if (resSw4 == 1) then
        cnt4 = 0
        system.pSave("cnt4",0)
        form.reinit()
    end
	
	if (cntSw5 == 1 and stateCnt5 == 0) then
		stateCnt5 = 1
		cnt5 = cnt5 + 1
		if (cnt5 == 32768) then
			cnt5 = 0
		end
		system.pSave("cnt5",cnt5)
		form.reinit()
		else if (cntSw5 ~= 1 and stateCnt5 == 1) then
			stateCnt5 = 0
		end
	end
    
    if (resSw5 == 1) then
        cnt5 = 0
        system.pSave("cnt5",0)
        form.reinit()
    end
	
	if (cntAlm1 > 0 and cnt1 >= cntAlm1) then
		system.setControl(8, 1, 0, 0)
		else
		system.setControl(8, 0, 0, 0)
	end
	
	if (cntAlm2 > 0 and cnt2 >= cntAlm2) then
		system.setControl(9, 1, 0, 0)
		else
		system.setControl(9, 0, 0, 0)
	end
    collectgarbage()
end
----------------------------------------------------------------------
-- Application initialization
local function init()
	system.registerForm(1,MENU_APPS,trans1.appName,initForm)	
	cntLb1 = system.pLoad("cntLb1",trans1.counter1)
	cntLb2 = system.pLoad("cntLb2",trans1.counter2)
	cntLb3 = system.pLoad("cntLb3",trans1.counter3)
	cntLb4 = system.pLoad("cntLb4",trans1.counter4)
	cntLb5 = system.pLoad("cntLb5",trans1.counter5)
	cntAlm1 = system.pLoad("cntAlm1", 0)
	cntAlm2 = system.pLoad("cntAlm2", 0)
	cnt1 = system.pLoad("cnt1", 0)
	cnt2 = system.pLoad("cnt2", 0)
	cnt3 = system.pLoad("cnt3", 0)
	cnt4 = system.pLoad("cnt4", 0)
	cnt5 = system.pLoad("cnt5", 0)
	cntSw1 = system.pLoad("cntSw1")
	cntSw2 = system.pLoad("cntSw2")
	cntSw3 = system.pLoad("cntSw3")
	cntSw4 = system.pLoad("cntSw4")
	cntSw5 = system.pLoad("cntSw5")
    resSw1 = system.pLoad("resSw1")
	resSw2 = system.pLoad("resSw2")
	resSw3 = system.pLoad("resSw3")
	resSw4 = system.pLoad("resSw4")
	resSw5 = system.pLoad("resSw5")
	system.registerTelemetry(1,cntLb1,1,printCounter1)
	system.registerTelemetry(2,cntLb2,1,printCounter2)
	system.registerControl(8,trans1.cont1,trans1.cs1)
	system.registerControl(9,trans1.cont2,trans1.cs2)
	system.setControl(8, 0, 0, 0)
	system.setControl(9, 0, 0, 0)
    collectgarbage()
end
----------------------------------------------------------------------
cntrVersion = "2.1"
setLanguage()
collectgarbage()
return { init=init, loop=loop, author="RC-Thoughts", version=cntrVersion, name=trans1.appName}