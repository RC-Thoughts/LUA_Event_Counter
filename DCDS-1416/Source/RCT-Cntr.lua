--[[
	---------------------------------------------------------
	Event counter takes any switch available in transmitter
	and count how many times it have been used. 
	
	Great for counting for example how many times retracts 
	have been used and to keep track of service-intervalls.
	
	This is DC/DS-16 version with two counters.
	
	Counters 1 and 2 can be used as telemetry window on 
	main screen. They also have an alarm possibility (Switch).
	
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
	Released under MIT-license by Tero @ RC-Thoughts.com 2016
	---------------------------------------------------------
--]]
collectgarbage()
----------------------------------------------------------------------
-- Locals for the application
local cntLb1, cntLb2, cntSw1, cntSw2, cnt1, cnt2, cntAlm1, cntAlm2
local stateCnt1, stateCnt2 = 0,0
----------------------------------------------------------------------
local function setLanguage()
    local lng=system.getLocale()
    local file = io.readall("Apps/Lang/RCT-Cntr.jsn")
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
----------------------------------------------------------------------
-- Draw the main form (Application inteface)
local function initForm()
	form.addRow(1)
	form.addLabel({label="---   RC-Thoughts Jeti Tools    ---",font=FONT_BIG})
	
	form.addRow(1)
	form.addLabel({label=trans1.counter1,font=FONT_BOLD})
	
	form.addRow(2)
	form.addLabel({label=trans1.labelW,width=185})
	form.addTextbox(cntLb1,14,cntLbChanged1)
	
	form.addRow(2)
	form.addLabel({label=trans1.switch,width=200})
	form.addInputbox(cntSw1,true,cntSwChanged1)
	
	form.addRow(2)
	form.addLabel({label=trans1.currentCnt})
	form.addIntbox(string.format("%f", cnt1),0,32767,0,0,1,cntChanged1)
	
	form.addRow(2)
	form.addLabel({label=trans1.almVal})
	form.addIntbox(string.format("%f", cntAlm1),0,32767,0,0,1,almChanged1)
	
	form.addRow(1)
	form.addLabel({label=trans1.counter2,font=FONT_BOLD})
	
	form.addRow(2)
	form.addLabel({label=trans1.labelW,width=185})
	form.addTextbox(cntLb2,14,cntLbChanged2)
	
	form.addRow(2)
	form.addLabel({label=trans1.switch,width=200})
	form.addInputbox(cntSw2,true,cntSwChanged2)
	
	form.addRow(2)
	form.addLabel({label=trans1.currentCnt})
	form.addIntbox(string.format("%f", cnt2),0,32767,0,0,1,cntChanged2)
	
	form.addRow(2)
	form.addLabel({label=trans1.almVal})
	form.addIntbox(string.format("%f", cntAlm2),0,32767,0,0,1,almChanged2)
	
	form.addRow(1)
	form.addLabel({label="Powered by RC-Thoughts.com - v."..cntrVersion.." ",font=FONT_MINI, alignRight=true})
end
----------------------------------------------------------------------
-- Runtime functions, read status of switches and store latching switch state
-- also resets count if reaches over 32767 and takes care of counter switches
local function loop()
	local cntSw1, cntSw2 = system.getInputsVal(cntSw1, cntSw2)
	
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
	
	if (cntAlm1 > 0 and cnt1 >= cntAlm1) then
		system.setControl(1, 1, 0, 0)
		else
		system.setControl(1, 0, 0, 0)
	end
	
	if (cntAlm2 > 0 and cnt2 >= cntAlm2) then
		system.setControl(2, 1, 0, 0)
		else
		system.setControl(2, 0, 0, 0)
	end
end
----------------------------------------------------------------------
-- Application initialization
local function init()
    local pLoad = system.pLoad
	system.registerForm(1,MENU_APPS,trans1.appName,initForm)	
	cntLb1 = pLoad("cntLb1",trans1.counter1)
	cntLb2 = pLoad("cntLb2",trans1.counter2)
	cntAlm1 = pLoad("cntAlm1", 0)
	cntAlm2 = pLoad("cntAlm2", 0)
	cnt1 = pLoad("cnt1", 0)
	cnt2 = pLoad("cnt2", 0)
	cntSw1 = pLoad("cntSw1")
	cntSw2 = pLoad("cntSw2")
	system.registerTelemetry(1,cntLb1,1,printCounter1)
	system.registerTelemetry(2,cntLb2,1,printCounter2)
	system.registerControl(1,trans1.cont1,trans1.cs1)
	system.registerControl(2,trans1.cont2,trans1.cs2)
	system.setControl(1, 0, 0, 0)
	system.setControl(2, 0, 0, 0)
    collectgarbage()
end
----------------------------------------------------------------------
cntrVersion = "2.0"
setLanguage()
collectgarbage()
return { init=init, loop=loop, author="RC-Thoughts", version=cntrVersion, name=trans1.appName}