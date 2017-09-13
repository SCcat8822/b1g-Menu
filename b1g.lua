require("bsendpacket")


local pMenu = {}
local pMenuVars = { 
	Tabs = {},
	Sliders = {},
	CheckBoxes = {},
	Function_Buttons = {}
}

local AimbotPoints = {}
AimbotPoints[1] = {bone = "ValveBiped.Bip01_Head1"}
AimbotPoints[2] = {bone = "ValveBiped.Bip01_Neck1"}
AimbotPoints[3] = {bone = "ValveBiped.Bip01_Spine4"}
AimbotPoints[4] = {bone = "ValveBiped.Bip01_Spine2"}
AimbotPoints[5] = {bone = "ValveBiped.Bip01_Spine"}
local BigExploits = {} 
local PI = 3.14159265359;
local Rad = 180 / PI
local backtrackamt = 0.5;
local BackTrack = {}
function pMenu.IsNetString(netstring)
	local validate,_ = pcall( net.Start, netstring )
	if validate then
		return validate;
	end
	return false;
end
function pMenu.RandomString(len)
	if len == nil then
		len = math.random(20,100)
	end
	local ret = ""
	for i=1,len do
		ret = ret..string.char(math.random(33,126))
	end                                             
	return ret
end


BigExploits["Duel Moniez"] = {
	TopText = "Dueling",
	BottomText = "Give b1g money",
	should_draw = true, //pMenu.IsNetString(string) can be used
	func = function() 
		net.Start("duelrequestguiYes")
		net.WriteInt(-2147483648,32)
		net.WriteEntity(table.Random( player.GetAll() ) )
		net.WriteString("Crossbow")
		net.SendToServer()
	end
}

local FontL = pMenu.RandomString(10)
local FontM = pMenu.RandomString(10)
local FontL2 = pMenu.RandomString(10)
surface.CreateFont( FontL, {
	font = "Courier New",
	size = 18,
	weight = 300,
} )
surface.CreateFont( FontM, {
	font = "Courier New",
	size = 15,
	weight = 300,
} )
surface.CreateFont( FontL2, {
	font = "Verdana",
	extended = false,
	size = 12,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	shadow = true,
	antialias = true
} )

function pMenu.SaveSettings()
	local EndTable = {
		Sliders = {},
		CheckBoxes = {}
	}
	for _k,_v in pairs(EndTable) do
		for k,v in pairs(pMenuVars[_k]) do
			if k[1] == "S" && k[2] == "T" && k[3] == "E" && k[4] == "A" && k[5] == "M" then // dont save any plist vars remove it if you want to.
				continue;	  																// just don't want the file & table to fucking massive
			else
				_v[k] = v
			end
		end
	end
	file.Write( "_b1g_settings.txt",util.TableToJSON(EndTable,true))
end
function pMenu.GetSettings()
	if !file.Exists("_b1g_settings.txt","DATA") then
		return pMenuVars;
	end
	return util.JSONToTable(file.Read( "_b1g_settings.txt", "DATA" ))
end
function pMenu.LoadSettings()
	local settings = pMenu.GetSettings();
	pMenuVars["Sliders"] = settings["Sliders"];
	pMenuVars["CheckBoxes"] = settings["CheckBoxes"];
end
function pMenu.MouseInArea(frame,minx,miny,maxx,maxy)
	local PosX,PosY = frame:GetPos()
	local posx,posy = gui.MousePos();
	return ((posx >= minx && posx <= maxx) && (posy >= miny && posy <= maxy));
end
function pMenu.DrawOutLinedRect(x,y,w,h,color)
	surface.SetDrawColor( color )
	surface.DrawOutlinedRect( x, y, w, h )
	surface.SetDrawColor( Color(255,255,255,255) )
end
function pMenu.DrawRect(x,y,w,h,color)
	surface.SetDrawColor( color )
	surface.DrawRect( x, y, w, h )
	surface.SetDrawColor( Color(255,255,255,255) )
end
function pMenu.Drawline(x,y,x2,y2,color)
	surface.SetDrawColor(color)
	surface.DrawLine(x,y,x2,y2)
	surface.SetDrawColor( Color(255,255,255,255) )
end
function pMenu.DrawCircle(X,Y,radius,numSides,color)
	local Step = PI * 2.0 / numSides;
	local old = 0;
	for a=0,PI*2.0,Step do
		local X1 = radius * math.cos(a) + X;
		local Y1 = radius * math.sin(a) + Y;
		local X2 = radius * math.cos(a + Step) + X;
		local Y2 = radius * math.sin(a + Step) + Y;
		surface.SetDrawColor( color )
		surface.DrawLine(X1, Y1, X2, Y2);
	end
end
function pMenu.DrawSlider(frame,x,y,w,h,slider,min,max,startval,round)
	if round == nil then
		round = false;
	end
	max = max - min
	if pMenuVars.Sliders[slider] == nil then
		pMenuVars.Sliders[slider] = {min = min, max = max, value = startval}
	end
	local PosX,PosY = frame:GetPos()
	local NewX,NewY = PosX + x,PosY + y
	pMenu.DrawRect(x,y,w,h,Color(12,25,34,255))
	if input.IsMouseDown(MOUSE_LEFT) && pMenu.MouseInArea(frame,NewX,NewY,NewX+w,NewY+h) then
		local MX,MY = gui.MousePos();
		local MXF,MYF = MX - NewX + x,MY - NewY + y
		if round == false then
			pMenuVars.Sliders[slider].value = math.Clamp(math.Round((((MXF - x) / w) * max + min)),min,max + min)
		else
			pMenuVars.Sliders[slider].value = math.Clamp((((MXF - x) / w) * max + min),min,max + min)
		end
	end
	local val = pMenuVars.Sliders[slider].value;
	local slid = (w - 10) / (max) * (val - min)
	pMenu.DrawRect(x + slid,y,10,h,Color(18,89,131,255))
	draw.SimpleText(val,FontM,x + (w/2),y + 2,Color(255,255,255,255),TEXT_ALIGN_CENTER)
	pMenu.DrawOutLinedRect(x,y, w , h , Color( 0,255,255, 200 ))
end
function pMenu.DrawCheckBox(frame,x,y,CBOX,defvalue,text)
	local w,h = 20,20
	if pMenuVars.CheckBoxes[CBOX] == nil then
		pMenuVars.CheckBoxes[CBOX] = {value = defvalue,tez = 0}
	end
	local PosX,PosY = frame:GetPos()
	local NewX,NewY = PosX + x,PosY + y
	pMenu.DrawRect(x,y,w,h,Color(12,25,34,255))
	pMenu.DrawOutLinedRect(x,y,w,h,Color(0,255,255,255))
	if pMenu.MouseInArea(frame,NewX,NewY,NewX+w,NewY+h) && !pMenuVars.CheckBoxes[CBOX].value then
		pMenu.DrawRect(x + 3,y + 3,w - 6,h - 6,Color(18,59,101,255))
	end
	if input.IsMouseDown(MOUSE_LEFT) then
		pMenuVars.CheckBoxes[CBOX].tez = pMenuVars.CheckBoxes[CBOX].tez + 1
	else
		pMenuVars.CheckBoxes[CBOX].tez = 0;
	end
	if pMenuVars.CheckBoxes[CBOX].tez == 1 && pMenu.MouseInArea(frame,NewX,NewY,NewX+w,NewY+h) then
		pMenuVars.CheckBoxes[CBOX].value = !pMenuVars.CheckBoxes[CBOX].value;
	end
	if pMenuVars.CheckBoxes[CBOX].value then
		pMenu.DrawRect(x + 3,y + 3,w - 6,h - 6,Color(18,89,131,255))
	end
	draw.SimpleText(text,FontM,x + w + 5,y + 2,Color(255,255,255,255),TEXT_ALIGN_LEFT)
end

function pMenu.DrawDropDown(frame,x,y,CBOX,defvalue,text,tbl) // unfinished lol lazy
	local w,h = 70,20
	if pMenuVars.CheckBoxes[CBOX] == nil then
		pMenuVars.CheckBoxes[CBOX] = {value = defvalue,tez = 0}
	end
	local PosX,PosY = frame:GetPos()
	local NewX,NewY = PosX + x,PosY + y
	pMenu.DrawRect(x,y,w,h,Color(12,25,34,255))
	pMenu.DrawOutLinedRect(x,y,w,h,Color(0,255,255,255))
	if pMenu.MouseInArea(frame,NewX,NewY,NewX+w,NewY+h) && !pMenuVars.CheckBoxes[CBOX].value then
		pMenu.DrawRect(x + 3,y + 3,w - 6,h - 6,Color(18,59,101,255))
	end
	if input.IsMouseDown(MOUSE_LEFT) then
		pMenuVars.CheckBoxes[CBOX].tez = pMenuVars.CheckBoxes[CBOX].tez + 1
	else
		pMenuVars.CheckBoxes[CBOX].tez = 0;
	end
	if pMenuVars.CheckBoxes[CBOX].tez == 1 && pMenu.MouseInArea(frame,NewX,NewY,NewX+w,NewY+h) then
		pMenuVars.CheckBoxes[CBOX].value = !pMenuVars.CheckBoxes[CBOX].value;
	end
	if pMenuVars.CheckBoxes[CBOX].value then
		pMenu.DrawRect(x + 3,y + 3,w - 6,h - 6,Color(18,89,131,255))
	end
	draw.SimpleText(text,FontM,x + 5,y + 2,Color(255,255,255,255),TEXT_ALIGN_LEFT)
end

function pMenu.DrawTab(frame,x,y,w,h,NAME,defvalue)
	if pMenuVars.Tabs[NAME] == nil then
		pMenuVars.Tabs[NAME] = {value = defvalue,tez = 0}
	end
	local PosX,PosY = frame:GetPos()
	local NewX,NewY = PosX + x,PosY + y
	pMenu.DrawRect(x,y,w,h,Color(12,25,34,255))
	if pMenu.MouseInArea(frame,NewX,NewY,NewX+w,NewY+h) && !pMenuVars.Tabs[NAME].value then
		pMenu.DrawRect(x,y,w,h,Color(18,59,101,255))
	end
	if input.IsMouseDown(MOUSE_LEFT) then
		pMenuVars.Tabs[NAME].tez = pMenuVars.Tabs[NAME].tez + 1
	else
		pMenuVars.Tabs[NAME].tez = 0;
	end
	if pMenuVars.Tabs[NAME].tez == 1 && pMenu.MouseInArea(frame,NewX,NewY,NewX+w,NewY+h) then
		pMenuVars.Tabs[NAME].value = !pMenuVars.Tabs[NAME].value;
		for k,v in pairs(pMenuVars.Tabs) do
			if k != NAME && v.value == true then
				v.value = false;
			end
		end
	end
	if pMenuVars.Tabs[NAME].value then
		pMenu.DrawRect(x,y,w,h,Color(18,89,131,255))
	end
	pMenu.DrawOutLinedRect(x,y,w,h,Color(0,255,255,255))
	draw.SimpleText(NAME,FontL,x + w/2,y + h/2,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end
function pMenu.DrawFunctionButton(frame,x,y,w,h,NAME,func,text1,text2)
	if pMenuVars.Function_Buttons[NAME] == nil then
		pMenuVars.Function_Buttons[NAME] = {func = func,tez = 0}
	end
	local PosX,PosY = frame:GetPos()
	local NewX,NewY = PosX + x,PosY + y
	pMenu.DrawRect(x,y,w,h,Color(12,25,34,255))
	if pMenu.MouseInArea(frame,NewX,NewY,NewX+w,NewY+h) then
		pMenu.DrawRect(x,y,w,h,Color(18,59,101,255))
	end
	if input.IsMouseDown(MOUSE_LEFT) then
		pMenuVars.Function_Buttons[NAME].tez = pMenuVars.Function_Buttons[NAME].tez + 1
	else
		pMenuVars.Function_Buttons[NAME].tez = 0;
	end
	if pMenuVars.Function_Buttons[NAME].tez == 1 && pMenu.MouseInArea(frame,NewX,NewY,NewX+w,NewY+h) then
		pMenuVars.Function_Buttons[NAME].func();
	end
	pMenu.DrawOutLinedRect(x,y,w,h,Color(0,255,255,255))
	if text2 == nil then
		draw.SimpleText(text1,FontM,x + w/2,y + h/2 - 1,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	else
		draw.SimpleText(text1,FontM,x + w/2,y + h/2 - 8,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText(text2,FontM,x + w/2,y + h/2 + 8,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
end
local firsttime = true
local Frame = NULL;
local IsFake = false;
local shotz = 0;



function pMenu.Menu()
	Frame = vgui.Create( "DFrame" )
	Frame:SetTitle( "" )
	Frame:SetSize( 700, 500 )
	Frame:Center()
	Frame:ShowCloseButton(false)
	Frame:MakePopup()
	Frame.Paint = function( self, w, h )
		pMenu.DrawRect(0, 0, w, h, Color( 32,45,54, 230 ))
		pMenu.DrawRect(0, 0, w, 20, Color( 18,89,131, 255 ))
		pMenu.DrawOutLinedRect(0, 0, w, 20, Color( 0,255,255, 200 ))
		pMenu.DrawOutLinedRect(0, 0, w, h, Color( 0,255,255, 200 ))
		pMenu.DrawRect(5, 25, 125, h - 30, Color( 18,89,131, 100 ))
		pMenu.DrawOutLinedRect(5, 25, 125, h - 30, Color( 0,255,255, 200 ))
		pMenu.DrawOutLinedRect(135, 25, w - 140, h - 30, Color( 0,255,255, 200 ))
		draw.SimpleText("B1g Meme",FontL,w/2,1,Color(255,255,255,255),TEXT_ALIGN_CENTER)
		local Aimbot = "Aimbot";
		local Visuals = "Visuals";
		local b1gExploits = "Exploits"
		local misc = "MISC"
		local hvh = "HvH"
		local test = "Test"
		pMenu.DrawTab(Frame,10,30,115,50,Aimbot,true)
		pMenu.DrawTab(Frame,10,85,115,50,Visuals,true)
		pMenu.DrawTab(Frame,10,140,115,50,b1gExploits,true)
		pMenu.DrawTab(Frame,10,195,115,50,misc,true) 
		pMenu.DrawTab(Frame,10,250,115,50,hvh,true)

		pMenu.DrawFunctionButton(Frame,10,h - 75,115,30,"Load Settings Button",pMenu.LoadSettings,"Load Settings")
		pMenu.DrawFunctionButton(Frame,10,h - 40,115,30,"Save Settings Button",pMenu.SaveSettings,"Save Settings")

		if pMenuVars.Tabs[Visuals].value then
			pMenu.DrawCheckBox(Frame,170,55,"ESP",true,"Enable ESP")

			pMenu.Drawline(160,95,350,95,Color(0,255,255,255))

			pMenu.DrawCheckBox(Frame,150,115,"ESP Name",true,"Name")
			pMenu.DrawCheckBox(Frame,150,145,"ESP BoundingBox",true,"Bounding Box")
			pMenu.DrawCheckBox(Frame,150,175,"ESP HealthBar",true,"Health Bar")
			pMenu.DrawCheckBox(Frame,150,205,"ESP Traceline",true,"Eye Traceline")
			draw.SimpleText("Traceline Distance",FontM,150,237,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,150,265,210,20,"ESP Traceline Distance",25,  250,  71)
			pMenu.DrawCheckBox(Frame,150,295,"ESP Position",false,"Position")
			pMenu.DrawCheckBox(Frame,150,325,"ESP Angles",false,"Eye Angles")
			pMenu.DrawCheckBox(Frame,150,355,"ESP Glow",true,"Glow")
			pMenu.DrawCheckBox(Frame,150,385,"ESP Chams",true,"Chams")
			pMenu.DrawCheckBox(Frame,150,415,"ESP XQZ",true,"XQZ")
			pMenu.DrawCheckBox(Frame,150,445,"ESP WeaponCham",true,"Weapon Chams")


			draw.SimpleText("Box Color",FontM,390,35,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			draw.SimpleText("R",FontM,660,55,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,55,260,20,"ESP BoxColor.r",0,  255,  255)
			draw.SimpleText("G",FontM,660,80,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,80,260,20,"ESP BoxColor.g",0,  255,  0)
			draw.SimpleText("B",FontM,660,105,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,105,260,20,"ESP BoxColor.b",0,  255,  255)

			draw.SimpleText("Text Color",FontM,390,130,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			draw.SimpleText("R",FontM,660,150,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,150,260,20,"ESP TextColor.r",0,  255,  255)
			draw.SimpleText("G",FontM,660,175,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,175,260,20,"ESP TextColor.g",0,  255,  206)
			draw.SimpleText("B",FontM,660,200,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,200,260,20,"ESP TextColor.b",0,  255,  121)

			draw.SimpleText("Chams Visible",FontM,390,225,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			draw.SimpleText("R",FontM,660,250,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,250,260,20,"ESP ChamVisColor.r",0,  255,  10)
			draw.SimpleText("G",FontM,660,275,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,275,260,20,"ESP ChamVisColor.g",0,  255,  206)
			draw.SimpleText("B",FontM,660,300,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,300,260,20,"ESP ChamVisColor.b",0,  255,  4)

			draw.SimpleText("Chams Non-Visible",FontM,390,325,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			draw.SimpleText("R",FontM,660,350,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,350,260,20,"ESP ChamNVisColor.r",0,  255,  70)
			draw.SimpleText("G",FontM,660,375,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,375,260,20,"ESP ChamNVisColor.g",0,  255,  70)
			draw.SimpleText("B",FontM,660,400,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,400,260,20,"ESP ChamNVisColor.b",0,  255,  255)

			pMenu.Drawline(375,30,375,490,Color(0,255,255,255))
		end
		if pMenuVars.Tabs[misc].value then
			pMenu.DrawCheckBox(Frame,170,55,"MISC Thirdperson",false,"Enable ThirdPerson")
			draw.SimpleText("Distance",FontM,170,85,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,170,105,260,20,"MISC Thirdperson Distance",10,  1000,  100)
			pMenu.DrawCheckBox(Frame,170,135,"MISC Bhop",true,"Enable Bunnyhop")
			pMenu.DrawCheckBox(Frame,170,165,"MISC Autostrafe",true,"Enable Autostrafe")
			pMenu.DrawCheckBox(Frame,170,195,"MISC Text to speech is fucking aids",false,"Enable Text to Speech")
			pMenu.DrawCheckBox(Frame,170,225,"MISC Night-mode",true,"Enable Night-mode")
			pMenu.DrawCheckBox(Frame,170,255,"MISC CStrafe",true,"Enable Circle Strafe (E to use (pretty ass))")
		end

		// this looks like trash holyshit should have used in pairs
		if pMenuVars.Tabs[b1gExploits].value then
			// 8 max
			local explotcount = 0;
			local row = 0;
			for k,v in pairs(BigExploits) do
				local num = explotcount % 8;
				if num == 0 && explotcount >= 8 then
					row = row + 1;
				end
				if v.should_draw then
					pMenu.DrawFunctionButton(Frame,140 + (175 * row),30 + (55 * num),170,50,k,v.func,v.TopText,v.BottomText)
					explotcount = explotcount + 1;
				end
			end
			draw.SimpleText("Exploits can be easily added through lua",FontL,140,470,Color(255,255,255,255),TEXT_ALIGN_LEFT)
		end
		if pMenuVars.Tabs[Aimbot].value then
			pMenu.DrawCheckBox(Frame,170,55,"Aibmot Enable",false,"Enable")
			draw.SimpleText("Aimbot FOV",FontM,170,85,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,170,105,490,20,"Aimbot FOV",1,  360,  10,true)

			pMenu.DrawCheckBox(Frame,170,140,"Aibmot Smooth",false,"Smooth movement")
			draw.SimpleText("Smooth amount",FontM,170,170,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,170,190,225,20,"Aimbot Smooth AMT",1,  100,  5)

			pMenu.DrawCheckBox(Frame,410,140,"Aibmot Show fov circle",false,"Aibmot FOV circle (sort of accurate)")
			draw.SimpleText("Circle color",FontM,410,170,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			draw.SimpleText("R",FontM,645,190,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,410,190,225,20,"Aimbot Circle.r",1,  255,  255)
			draw.SimpleText("G",FontM,645,215,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,410,215,225,20,"Aimbot Circle.g",1,  255,  255)
			draw.SimpleText("B",FontM,645,240,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,410,240,225,20,"Aimbot Circle.b",1,  255,  1)
			draw.SimpleText("A",FontM,645,265,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,410,265,225,20,"Aimbot Circle.a",1,  255,  255) // 159
			///input.GetKeyName(
			pMenu.DrawSlider(Frame,170,315,490,20,"Aimbot Key",1,  159,  81)
			draw.SimpleText("Aimkey (wiki.garrysmod.com/page/Enums/KEY): "..string.upper(input.GetKeyName(pMenuVars.Sliders["Aimbot Key"].value)),FontM,170,290,Color(255,255,255,255),TEXT_ALIGN_LEFT)

			draw.SimpleText("Aimspot (default values): 1 = head, 2 = neck,3 = top of the spine",FontM,170,340,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			draw.SimpleText("4 = center spine,5 = stomach.   More can be added at the top of the code",FontM,170,360,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,170,385,490,20,"Aimbot Bone",1,  #AimbotPoints,  1)
		end
		if pMenuVars.Tabs[hvh].value then
			pMenu.DrawCheckBox(Frame,170,55,"HvH Enable",false,"Enable")
			draw.SimpleText("Aimkey ("..string.upper(input.GetKeyName(pMenuVars.Sliders["Aimbot Key"].value))..") Change this in the aimbot section.",FontM,300,57,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawCheckBox(Frame,170,100,"HvH Antiaim",false,"Enable AntiAim")
			draw.SimpleText("Pitch Angle",FontM,170,125,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,170,150,490,20,"HvH Pitch",-360,  360,  0)
			draw.SimpleText("Yaw Angle",FontM,170,175,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,170,200,490,20,"HvH Yaw",-360,  360,  0)
			draw.SimpleText("Style: 1 jitter spin, 2 spin, 3 random,4 at player,5 static,6 y+cam",FontM,170,225,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,170,250,200,20,"HvH Style",1,  6,  2)
			if pMenuVars.Sliders["HvH Style"].value == 2 then
				draw.SimpleText("Spin Speed (ang  + (IntervalPerTick + Number)",FontM,380,250,Color(255,255,255,255),TEXT_ALIGN_LEFT)
				pMenu.DrawSlider(Frame,380,275,285,20,"HvH Spin Speed",1,  1000,  230)
			elseif pMenuVars.Sliders["HvH Style"].value == 3 then
				draw.SimpleText("Random min/max",FontM,380,250,Color(255,255,255,255),TEXT_ALIGN_LEFT)
				pMenu.DrawSlider(Frame,380,275,200,20,"HvH randomY",1,  180,  45)
			end

			pMenu.DrawCheckBox(Frame,170,280,"HvH Autoshoot",false,"Autoshoot")

			draw.SimpleText("fag lag ammount ( > 0 for fake angles)",FontM,170,310,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,170,330,200,20,"HvH Choke Packet",0,  14,  1)

			if IsFake then
				draw.SimpleText("Fake angle (angle + number)",FontM,170,370,Color(255,255,255,255),TEXT_ALIGN_LEFT)
				pMenu.DrawSlider(Frame,170,390,490,20,"HvH Fake Ang",0,  360,  0)
			end

			//IsFake

			pMenu.DrawCheckBox(Frame,170,425,"HvH Show FA",true,"Show FakeAngle")
			pMenu.DrawCheckBox(Frame,170,460,"HvH pList",true,"pList")
		end
		if firsttime then
			pMenuVars.Tabs[Visuals].value = false;
			pMenuVars.Tabs[misc].value = false;
			pMenuVars.Tabs[b1gExploits].value = false;
			pMenuVars.Tabs[Aimbot].value = false;
			pMenuVars.Tabs[hvh].value = true;
		end
		firsttime = false;
	end
	local PList = vgui.Create( "DFrame" )
	PList:SetTitle( "" )
	PList:SetSize( 300, ScrH() )
	PList:SetPos(0,0)
	PList:ShowCloseButton(false)
	PList:MakePopup()
	PList.Paint = function( self, w, h )
		if pMenuVars.CheckBoxes["HvH pList"] != nil && pMenuVars.CheckBoxes["HvH pList"].value then
			if pMenuVars.Tabs["HvH"].value != nil && pMenuVars.Tabs["HvH"].value then
				pMenu.DrawRect(0, 0, w, h, Color( 32,45,54, 230 ))
				draw.SimpleText("PList",FontL,w/2,1,Color(255,255,255,255),TEXT_ALIGN_CENTER)
				draw.SimpleText("Can't hit someone because their aa is good?",FontM,w/2,21,Color(255,255,255,255),TEXT_ALIGN_CENTER)
				draw.SimpleText("Use this :)",FontM,w/2,42,Color(255,255,255,255),TEXT_ALIGN_CENTER)
				local up = 20;
				local add = 110
				local k = 0;
				for _,v in pairs(player.GetAll()) do
					k = k + 1;
					/*
					if v == LocalPlayer() then
						k = k -1
						continue;
					end
					*/
					pMenu.DrawOutLinedRect(10,up + (k * add),280,add - 2,Color(255,255,255,255))
					pMenu.DrawRect(10,up + (k * add),280,add - 2,Color(18,89,131,170))
					draw.SimpleText(v:Nick(),FontM,12,up + (k * add) + 3,Color(0,255,255,255))
					draw.SimpleText("P:",FontM,175,up + (k * add) + 3,Color(0,255,255,255))
					pMenu.DrawSlider(PList,190,up + (k * add),100,22,v:SteamID().."Force Pitch",-180,  180,  0,true)
					draw.SimpleText("Y:",FontM,175,up + (k * add) + 24,Color(0,255,255,255))
					pMenu.DrawSlider(PList,190,up + (k * add)+22,100,22,v:SteamID().."Force Yaw",-180,  180,  0,true)

					draw.SimpleText("Ticks:",FontM,190,up + (k * add) + 45,Color(0,255,255,255),TEXT_ALIGN_RIGHT)
					pMenu.DrawSlider(PList,190,up + (k * add)+44,100,22,v:SteamID().."Backtrack",0,  (backtrackamt / engine.TickInterval()) - 2,  0,false)

					pMenu.DrawCheckBox(PList,11,up + (k * add) + 23,v:SteamID().."Baim",false,"baim")
					pMenu.DrawCheckBox(PList,75,up + (k * add) + 23,v:SteamID().."Force Ang",false,"Force Ang")
					pMenu.DrawCheckBox(PList,11,up + (k * add) + 44,v:SteamID().."Backtrack",false,"Backtrack")
					pMenu.DrawCheckBox(PList,11,up + (k * add) + 66,v:SteamID().."Spin",false,"Spin Resolve")
					pMenu.DrawCheckBox(PList,130,up + (k * add) + 66,v:SteamID().."aplayer",false,"Aim At LocalPlayer")

					pMenu.DrawCheckBox(PList,11,up + (k * add) + 88,v:SteamID().."Anti pResolver",false,"Anti pResolver")
				end
			end
		end
		if Frame == NULL then
			self:Close()
		end
	end

end
function pMenu.boundingbox(ply)
	local bot,top = ply:GetHull()
	local iBoxWidth = top.x * 2;
	local iBoxHeight = top.z;
	
	local pos = ply:GetPos()
	if (ply:Crouching()) then
		local bot,top = ply:GetHullDuck()
		pos = Vector(pos.x, pos.y, pos.z);
		iBoxHeight = top.z;
	else
		pos = Vector(pos.x,pos.y,pos.z);
	end

	local points = {
		Vector(pos.x - iBoxWidth / 2, pos.y - iBoxWidth / 2, pos.z ),
		Vector(pos.x - iBoxWidth / 2, pos.y + iBoxWidth / 2, pos.z ), 
		Vector(pos.x + iBoxWidth / 2, pos.y + iBoxWidth / 2, pos.z ), 
		Vector(pos.x + iBoxWidth / 2, pos.y - iBoxWidth / 2, pos.z ), 
		Vector(pos.x + iBoxWidth / 2, pos.y + iBoxWidth / 2, pos.z + iBoxHeight), 
		Vector(pos.x - iBoxWidth / 2, pos.y + iBoxWidth / 2, pos.z + iBoxHeight), 
		Vector(pos.x - iBoxWidth / 2, pos.y - iBoxWidth / 2, pos.z + iBoxHeight), 
		Vector(pos.x + iBoxWidth / 2, pos.y - iBoxWidth / 2, pos.z + iBoxHeight),
	};
	local flb = points[4]:ToScreen();
	local brt = points[6]:ToScreen();
	local blb = points[1]:ToScreen();
	local frt = points[5]:ToScreen();
	local frb = points[3]:ToScreen();
	local brb = points[2]:ToScreen();
	local blt = points[7]:ToScreen();
	local flt = points[8]:ToScreen();
	local arr = { flb, brt, blb, frt, frb, brb, blt, flt };

	local t1 = flb.x;      
	local t2 = flb.y;        
	local t3 = flb.x;   
	local t4 = flb.y;   

	for i=1,8 do
		if (t1 > arr[i].x) then
			t1 = arr[i].x;
		end
		if (t4 < arr[i].y) then
			t4 = arr[i].y;
		end
		if (t3 < arr[i].x) then
			t3 = arr[i].x;
		end
		if (t2 > arr[i].y) then
			t2 = arr[i].y; 
		end
	end
	return t1,t3,t2,t4;
end
function pMenu.PredictPos(pos)
	local myvel = LocalPlayer():GetVelocity()
	local pos = pos - (myvel * engine.TickInterval()); 
	return pos;
end
function pMenu.SmoothAngle(angle,me,SmoothPercent)
	local first = Vector(angle.x - me.x, math.NormalizeAngle(angle.y - me.y), 0.0);
	local smoothX = me.x + first.x / 100 * SmoothPercent;
	local smoothY = me.y + first.y / 100 * SmoothPercent;
	return Angle(smoothX, math.NormalizeAngle(smoothY), 0.0);
end
function pMenu.GetAngle(src, dst)
	local delta = pMenu.PredictPos(Vector(dst.x - src.x, dst.y - src.y, dst.z - src.z));
	local hyp = math.sqrt(delta.x * delta.x + delta.y * delta.y);
	local pitch = math.atan(delta.z/hyp) * Rad * -1;
	local yaw = math.atan(delta.y / delta.x) * Rad;
	if (delta.x >= 0) then
		yaw = yaw + 180;
	end
	return Angle(pitch, math.NormalizeAngle(yaw - 180), 0.0);
end
function pMenu.GetAngleVector(src, dst)
	local delta = pMenu.PredictPos(Vector(dst.x - src.x, dst.y - src.y, dst.z - src.z));
	local hyp = math.sqrt(delta.x * delta.x + delta.y * delta.y);
	local pitch = math.atan(delta.z/hyp) * Rad * -1;
	local yaw = math.atan(delta.y / delta.x) * Rad;
	if (delta.x >= 0) then
		yaw = yaw + 180;
	end
	return Vector(pitch, math.NormalizeAngle(yaw - 180), 0.0);
end
function pMenu.ClosestEntToCross(limit,pcmd,bonee,Angle)
	if limit == nil then
		limit = 360;
	end
	local curAng = Vector(Angle.x,Angle.y + 180,0);
	local curEye = LocalPlayer():EyePos()
	local ret = NULL
	local retDist = 1000;
	for k,v in pairs(player.GetAll()) do
		if v == LocalPlayer() || !v:Alive() || v:Team() == LocalPlayer():Team() then
			continue;
		end
		local pos = Vector(0,0,0);
		if bonee != nil then
			pos = pMenu.PredictPos(v:GetBonePosition(v:LookupBone(bonee)))
		else
			pos = pMenu.PredictPos(v:GetBonePosition(v:LookupBone(AimbotPoints[pMenuVars.Sliders["Aimbot Bone"].value].bone)))
		end
		local tarAng = pMenu.GetAngleVector(curEye,pos);
		tarAng = Vector(tarAng.x,tarAng.y + 180,0);
		local dist = tarAng:Distance(curAng);
		if dist <= limit && dist < retDist && LocalPlayer():IsLineOfSightClear(pos) then
			ret = v;
			retDist = dist;
		end
	end
	return ret;
end
function pMenu.ClosestEntToCrossNLOS(limit,pcmd,bone,Angle)
	if limit == nil then
		limit = 360;
	end
	local curAng = Vector(Angle.x,Angle.y + 180,0);
	local curEye = LocalPlayer():EyePos()
	local ret = NULL
	local retDist = 1000;
	for k,v in pairs(player.GetAll()) do
		if v == LocalPlayer() || !v:Alive() || v:Team() == LocalPlayer():Team() then
			continue;
		end
		local pos = Vector(0,0,0);
		if bone != nil then
			pos = v:EyePos()
		else
			pos = v:GetBonePosition(v:LookupBone(AimbotPoints[pMenuVars.Sliders["Aimbot Bone"].value].bone))
		end
		local tarAng = pMenu.GetAngleVector(curEye,pos);
		tarAng = Vector(tarAng.x,tarAng.y + 180,0);
		local dist = tarAng:Distance(curAng);
		if dist <= limit && dist < retDist then
			ret = v;
			retDist = dist;
		end
	end
	return ret;
end
function EntIndexToEnt(index)
	for k,v in pairs(player.GetAll()) do
		if v:EntIndex() == index then
			return v;
		end
	end
	return NULL;
end
local SpinPeople = {}
gameevent.Listen( "entity_killed" )
function pMenu.AAA(ply,spinnum)
	local Angles = ply:EyeAngles()
	if pMenuVars.CheckBoxes[ply:SteamID().."Force Ang"] != nil && pMenuVars.CheckBoxes[ply:SteamID().."Force Ang"].value then

		if pMenuVars.CheckBoxes[ply:SteamID().."aplayer"].value then
			local angz = pMenu.GetAngle(ply:EyePos(),LocalPlayer():EyePos())
			Angles.p = math.NormalizeAngle(angz.x + pMenuVars.Sliders[ply:SteamID().."Force Pitch"].value)
			Angles.y = math.NormalizeAngle(angz.y + pMenuVars.Sliders[ply:SteamID().."Force Yaw"].value)
		else
			Angles.p = math.NormalizeAngle( math.Clamp(Angles.p,-89,89) + pMenuVars.Sliders[ply:SteamID().."Force Pitch"].value)
			Angles.y = math.NormalizeAngle( math.NormalizeAngle(Angles.y) + pMenuVars.Sliders[ply:SteamID().."Force Yaw"].value)
		end
	end
	if (Angles.x < -179.0) then // pitch
		Angles.x = Angles.x - 360
	elseif Angles.x > 90.0 || Angles.x < -90.0 then
		Angles.x = 89
	elseif Angles.x > 89.0 && Angles.x < 91.0 then
		Angles.x = 89;
	elseif Angles.x > 179.0 && Angles.x < 181.0 then
		Angles.x = Angles - 180;
	elseif Angles.x > -179.0 && Angles.x < -181.0 then
		Angles.x = 180;
	end
	if pMenuVars.CheckBoxes[ply:SteamID().."Spin"] != nil && pMenuVars.CheckBoxes[ply:SteamID().."Spin"].value then // spin
		if SpinPeople[ply:SteamID()] == nil then
			SpinPeople[ply:SteamID()] = {ang = 0}
		end
		Angles.y = math.NormalizeAngle((spinnum))
		SpinPeople[ply:SteamID()].ang = Angles.y
	end
	ply:SetPoseParameter("aim_pitch", Angles.p);
	ply:SetPoseParameter("head_pitch",Angles.p);
	ply:SetPoseParameter("body_yaw", Angles.y );
	ply:SetPoseParameter("aim_yaw", 0);
	ply:InvalidateBoneCache();
	ply:SetRenderAngles(Angle(0, Angles.y, 0));
end
hook.Add( "entity_killed", "Return angle", function( data )
	local Ent = EntIndexToEnt(data.entindex_killed)
	if SpinPeople[Ent:SteamID()] != nil && pMenuVars.CheckBoxes[Ent:SteamID().."Spin"] != nil && pMenuVars.CheckBoxes[Ent:SteamID().."Spin"].value then
		chat.AddText(Color(0,255,255),"Player (",Color(255,255,0),Ent:Nick(),Color(0,255,255),") was killed at yaw angle ",Color(255,255,0),"(Their yaw + "..tostring(math.Round(SpinPeople[Ent:SteamID()].ang))..")",Color(0,255,255)," if you didn't kill him take this with a grain of salt." )
	end
end)
local SpinNum = 0;
local RealAngle = Angle(0,0,0)
local FakeAngles = Angle();
hook.Add("RenderScene","tes",function()
	local ammo = 0;
	if LocalPlayer():Alive() then
		ammo = LocalPlayer():GetActiveWeapon():Clip1() % 8 + 1;
	end
	SpinNum = ammo * 45;
	for k,v in pairs(player.GetAll()) do
		v:SetupBones()
		if v == LocalPlayer() then
			v:SetPoseParameter("aim_pitch", RealAngle.p);
			v:SetPoseParameter("head_pitch",RealAngle.p);
			v:SetPoseParameter("head_yaw",0);
			v:SetPoseParameter("body_yaw", RealAngle.y );
			v:SetPoseParameter("move_x", 1);
			v:SetPoseParameter("move_y", 0);
			v:SetPoseParameter("aim_yaw", 0);
			v:InvalidateBoneCache();
			v:SetRenderAngles(Angle(0, RealAngle.y, 0));
			continue;
		end
		pMenu.AAA(v,SpinNum)
	end
end)
local NextShot = 0;
function pMenu.CanShoot()
	if (CurTime() < NextShot) then
		return false
	end
	return true;
end
function pMenu.Shoot(pcmd)
	if(LocalPlayer():KeyDown(1)) then
		pcmd:SetButtons(bit.band( pcmd:GetButtons(), bit.bnot( 1 ) ) );
		if LocalPlayer():GetActiveWeapon().RPM != nil then
			NextShot = (CurTime() + (1/(LocalPlayer():GetActiveWeapon().RPM / 60)));
		else
			NextShot = (CurTime() + 0.05);
		end
	else
		pcmd:SetButtons(bit.bor( pcmd:GetButtons(), 1 ) );
	end
end
function pMenu.DrawESP(ply)
	local boxcolor = Color(pMenuVars.Sliders["ESP BoxColor.r"].value,pMenuVars.Sliders["ESP BoxColor.g"].value,pMenuVars.Sliders["ESP BoxColor.b"].value,255)
	local textcolor = Color(pMenuVars.Sliders["ESP TextColor.r"].value,pMenuVars.Sliders["ESP TextColor.g"].value,pMenuVars.Sliders["ESP TextColor.b"].value,255)
	local left,right,top,bottom = pMenu.boundingbox(ply)
	if pMenuVars.CheckBoxes["ESP BoundingBox"].value then
		surface.SetDrawColor(Color(0,0,0,255));
		surface.DrawOutlinedRect(left ,top , (right - left) + 3,(bottom - top) + 3)
		surface.SetDrawColor(boxcolor);
		surface.DrawOutlinedRect(left + 1,top + 1, (right - left) + 1,(bottom - top) + 1)
	end
	if pMenuVars.CheckBoxes["ESP HealthBar"].value then
		surface.SetDrawColor(0,0,0,255);
		surface.DrawRect(left - 5,top - 1 + 2,4, (bottom - top) / 100 * ply:Health() + 2)
		surface.SetDrawColor(255,0,0,255);
		surface.DrawRect(left - 4,top + 2,2, (bottom - top) / 100 * ply:Health())
	end

	if (pMenuVars.CheckBoxes["ESP Name"].value) then
		draw.SimpleText(ply:Nick(),FontL2,left + (right - left) / 2,top - 5,textcolor,TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM)
	end
	if (pMenuVars.CheckBoxes["ESP Position"].value) then
		local pos = ply:GetPos();
		draw.SimpleText("POS = ".."X: "..math.floor(pos.x).." Y: "..math.floor(pos.y).." Z: "..math.floor(pos.z),FontL2,right + 3,top,textcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
	end
	if (pMenuVars.CheckBoxes["ESP Angles"].value) then
		local pos = ply:EyeAngles();
		draw.SimpleText("ANG.X: "..(ply:EyeAngles().p),FontL2,right + 3,top + 12,textcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		draw.SimpleText("ANG.Y: "..(ply:EyeAngles().y),FontL2,right + 3,top + 24,textcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		draw.SimpleText("ANG.Z: "..(ply:EyeAngles().r),FontL2,right + 3,top + 36,textcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
	end
	if (pMenuVars.CheckBoxes["ESP Traceline"].value) then
		local eyes = (ply:EyePos() + ply:EyeAngles():Forward() * pMenuVars.Sliders["ESP Traceline Distance"].value):ToScreen();
		local eye = ply:EyePos():ToScreen();

		surface.SetDrawColor(255,255,255,255)
		if eye.visible && eyes.visible then
			surface.DrawLine(eyes.x,eyes.y,eye.x,eye.y)
		end
	end
end
// pasted chams because l a z y 
local chamsmat = CreateMaterial("a", "VertexLitGeneric", {
	["$ignorez"] = 1,
	["$model"] = 1,
	["$basetexture"] = "models/debug/debugwhite",
})
local chamsmat2 = CreateMaterial("@", "VertexLitGeneric", {
	["$ignorez"] = 0,
	["$model"] = 1,
	["$basetexture"] = "models/debug/debugwhite",
})
function pMenu.Chams(v)
	local ChamVis = Color(pMenuVars.Sliders["ESP ChamVisColor.r"].value,pMenuVars.Sliders["ESP ChamVisColor.g"].value,pMenuVars.Sliders["ESP ChamVisColor.b"].value,255)
	local ChamNVis = Color(pMenuVars.Sliders["ESP ChamNVisColor.r"].value,pMenuVars.Sliders["ESP ChamNVisColor.g"].value,pMenuVars.Sliders["ESP ChamNVisColor.b"].value,255)
	cam.Start3D()
		render.SuppressEngineLighting(false)
		if v:IsValid() then
			if pMenuVars.CheckBoxes["ESP XQZ"].value then
				render.MaterialOverride(chamsmat)
				render.SetColorModulation(ChamNVis.r/ 255, ChamNVis.g/255, ChamNVis.b/255)
				v:DrawModel()
			end

			render.SetColorModulation(ChamVis.r / 255, ChamVis.g/ 255, ChamVis.b/ 255) // vis
			render.MaterialOverride(chamsmat2)
			v:DrawModel()
		end
		local wep = v:GetActiveWeapon()
		local wep = v:GetActiveWeapon()
		if wep:IsValid() then
			if pMenuVars.CheckBoxes["ESP WeaponCham"].value then
				render.MaterialOverride(chamsmat)
				render.SetColorModulation(255/255, 0/255, 0/255, 255)
				wep:DrawModel()
				render.SetColorModulation(255/255, 255/255, 0/255, 255)
				render.MaterialOverride(chamsmat2)
				wep:DrawModel()
			end
		end
	cam.End3D()
end
function pMenu.bhop(pcmd)
	if (!LocalPlayer():IsOnGround() && !LocalPlayer():IsTyping() && pcmd:KeyDown(IN_JUMP)) then
		pcmd:RemoveKey(IN_JUMP)
	end
end
function pMenu.autostrafe(pcmd)
	if !(LocalPlayer():IsOnGround()) && input.IsKeyDown(KEY_SPACE) then
		if(pcmd:GetMouseX() > 1 or pcmd:GetMouseX() < -1) then
			if(pcmd:GetMouseX() < 0) then
				pcmd:SetSideMove(-400)
			else
				pcmd:SetSideMove(400)
			end
		else
			pcmd:SetForwardMove(5850 / LocalPlayer():GetVelocity():Length2D())
			pcmd:SetSideMove((pcmd:CommandNumber() % 2 == 0) and 400 or -400)
		end
	end
end
function pMenu.ToggleMenu()
	if Frame == NULL then
		pMenu.Menu()
	else
		Frame:Close()
		Frame = NULL
	end
end
function pMenu.FixMovement(pCmd,fa,angles)
	local vec = Vector(pCmd:GetForwardMove(pCmd), pCmd:GetSideMove(), 0)
	local vel = math.sqrt(vec.x*vec.x + vec.y*vec.y)
	local mang = vec:Angle()
	local yaw = angles.y - fa.y + mang.y
	if (((angles.p+90)%360) > 180) then
		yaw = 180 - yaw
	end
	yaw = ((yaw + 180)%360)-180
	pCmd:SetForwardMove(math.cos(math.rad(yaw)) * vel)
	pCmd:SetSideMove(math.sin(math.rad(yaw)) * vel)
end

hook.Add("RenderScreenspaceEffects","hkRenderScreenspaceEffects",function()
	if (pMenuVars.CheckBoxes["ESP Chams"] != nil && pMenuVars.CheckBoxes["ESP Chams"].value && pMenuVars.CheckBoxes["ESP"] != nil && pMenuVars.CheckBoxes["ESP"].value) then
		for k,v in pairs(player.GetAll()) do
			if v != LocalPlayer() && v:Alive() && !v:IsDormant() && v:Health() > 1 then
				pMenu.Chams(v);
			end
		end
	end
end)

hook.Add("PreDrawHalos","hkPreDrawHalos",function()
	if (pMenuVars.CheckBoxes["ESP Glow"] != nil && pMenuVars.CheckBoxes["ESP Glow"].value && pMenuVars.CheckBoxes["ESP"] != nil && pMenuVars.CheckBoxes["ESP"].value) then
		local tab = {}
		for k,v in pairs(player.GetAll()) do
			if v != LocalPlayer() &&  v:Alive() then
				tab[k] = v;
			end
		end
		halo.Add( tab, Color( 255, 255, 255 ), 0.5, 0.5, 4,true,true )
	end
end)
hook.Add("HUDPaint","hkHUDPaint",function()
	for k,v in pairs(player.GetAll()) do
		if v != LocalPlayer() &&  v:Alive() then
			if pMenuVars.CheckBoxes["ESP"] != nil && pMenuVars.CheckBoxes["ESP"].value then
				pMenu.DrawESP(v)
			end
		end
	end
	if pMenuVars.CheckBoxes["Aibmot Show fov circle"] != nil && pMenuVars.CheckBoxes["Aibmot Show fov circle"].value then
		local End = (ScrW() / (LocalPlayer():GetFOV() + 60) ) * pMenuVars.Sliders["Aimbot FOV"].value;
		pMenu.DrawCircle(ScrW() / 2,ScrH() / 2, End, 70,Color(pMenuVars.Sliders["Aimbot Circle.r"].value,pMenuVars.Sliders["Aimbot Circle.g"].value,pMenuVars.Sliders["Aimbot Circle.b"].value,pMenuVars.Sliders["Aimbot Circle.a"].value))
	end
end)
local View = Angle();
hook.Add("CalcView","hkCalcView",function(ply, pos1, angles, fov)
	if (pMenuVars.CheckBoxes["HvH Enable"] != nil && pMenuVars.CheckBoxes["HvH Enable"].value) && LocalPlayer():Alive() then
		local view = {}
		local ang = View
		view.angles = View
		local angfwd = ang:Forward();
		local distance = pMenuVars.Sliders["MISC Thirdperson Distance"].value
		local endpoz = Vector(pos1.x - distance * angfwd.x,pos1.y - distance * angfwd.y, pos1.z - distance * angfwd.z);
		local tracelines = util.TraceLine({start = LocalPlayer():EyePos(),endpos  = endpoz, filter = LocalPlayer()})

		view.origin = tracelines.HitPos
		view.drawviewer = true;
		return view;
	end
	if pMenuVars.CheckBoxes["MISC Thirdperson"] != nil && pMenuVars.CheckBoxes["MISC Thirdperson"].value then
		local view = {}
		local ang = angles
		view.angles = ang
		local angfwd = ang:Forward();
		local distance = pMenuVars.Sliders["MISC Thirdperson Distance"].value
		local endpoz = Vector(pos1.x - distance * angfwd.x,pos1.y - distance * angfwd.y, pos1.z - distance * angfwd.z);
		local tracelines = util.TraceLine({start = LocalPlayer():EyePos(),endpos  = endpoz, filter = LocalPlayer()})

		view.origin = tracelines.HitPos
		view.drawviewer = true;
		return view;
	end
end)
local t = 0; // to open the fucking menu
local jitter = false;
local AShoot = false;

local test_int = 0;
local T2 = 0;
local Failed_Packets = 0;


hook.Add("Tick","Test",function()
	if pMenuVars.Sliders["HvH Choke Packet"] != nil then
		bSendPacket = false;
		if bSendPacket == false then
			Failed_Packets = Failed_Packets + 1;
		end
		if Failed_Packets > pMenuVars.Sliders["HvH Choke Packet"].value then
			bSendPacket = true;
			Failed_Packets = 0;
		end
	end
	if !LocalPlayer():Alive() then
		bSendPacket = true;
	end
end)
local FontVerdana = pMenu.RandomString()
surface.CreateFont( FontVerdana, {
	font = "Verdana",
	extended = false,
	size = 30,
	weight = 300,
	blursize = 0,
	scanlines = 0,
	shadow = true,
	antialias = true
} )
local path_pos = {}
local play = false;
local aa_style = 0;
hook.Add("HUDPaint","AA Type",function()
	draw.SimpleText(math.NormalizeAngle(math.Round(RealAngle.y)).." Real Yaw",FontL,0,15,Color(255,255,0,255))
	draw.SimpleText(math.NormalizeAngle(math.Round(FakeAngles.y)).." Fake Yaw",FontL,0,30,Color(255,255,0,255))
	if aa_style == 1 then
		draw.SimpleText("Jitter Spin",FontVerdana,10,ScrH() - 100,Color(255,255,0,255))
	elseif aa_style == 2 then
		draw.SimpleText("Spin",FontVerdana,10,ScrH() - 100,Color(255,255,0,255))
	elseif aa_style == 3 then
		draw.SimpleText("Random Yaw Angle",FontVerdana,10,ScrH() - 100,Color(255,255,0,255))
	elseif aa_style == 4 then
		draw.SimpleText("At Player",FontVerdana,10,ScrH() - 100,Color(255,255,0,255))
	elseif aa_style == 5 then
		draw.SimpleText("Static Angle",FontVerdana,10,ScrH() - 100,Color(255,255,0,255))
	elseif aa_style == 6 then
		draw.SimpleText("Yaw + cam.y",FontVerdana,10,ScrH() - 100,Color(255,255,0,255))
	end
	/*
	for k,v in pairs(player.GetAll()) do
		local pos = v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Head1")):ToScreen()
		surface.DrawLine(ScrW()/2,ScrH(),pos.x,pos.y)
	end
	*/
end)

hook.Add("CreateMove","hkCreateMove",function(pCmd)
	if pMenuVars.Sliders["HvH Choke Packet"] != nil && pMenuVars.Sliders["HvH Choke Packet"].value > 0 then
		IsFake = true;
	else
		IsFake = false;
	end
	if pMenuVars.CheckBoxes["MISC Bhop"] != nil && pMenuVars.CheckBoxes["MISC Bhop"].value then
		pMenu.bhop(pCmd)
	end
	if pMenuVars.CheckBoxes["MISC Autostrafe"] != nil && pMenuVars.CheckBoxes["MISC Autostrafe"].value then
		pMenu.autostrafe(pCmd)
	end
	if pMenuVars.CheckBoxes["Aibmot Enable"] != nil && pMenuVars.CheckBoxes["Aibmot Enable"].value then
		if input.IsKeyDown(pMenuVars.Sliders["Aimbot Key"].value) then
			local nearest = pMenu.ClosestEntToCross(pMenuVars.Sliders["Aimbot FOV"].value,pCmd,AimbotPoints[pMenuVars.Sliders["Aimbot Bone"].value].bone,pCmd:GetViewAngles());
			if nearest != NULL then 
				local Eye = LocalPlayer():EyePos();
				local target = nearest:GetBonePosition(nearest:LookupBone(AimbotPoints[pMenuVars.Sliders["Aimbot Bone"].value].bone))
				local End = Angle();
				if pMenuVars.CheckBoxes["Aibmot Smooth"].value then
					End = pMenu.SmoothAngle(pMenu.GetAngle(Eye,target),pCmd:GetViewAngles(),pMenuVars.Sliders["Aimbot Smooth AMT"].value);
				else
					End = pMenu.GetAngle(Eye,target)
				end
				pCmd:SetViewAngles(End)
			end
		end
	end
	if input.IsKeyDown(KEY_DELETE) then
		t = t + 1
		if t == 1 then
			pMenu.ToggleMenu()
		end
	else
		t = 0;
	end
	local fwdmouse = Vector(pCmd:GetMouseX(),pCmd:GetMouseY(),0)
	View.y = math.NormalizeAngle(View.y + ( ((fwdmouse.x / 250) * GetConVar("sensitivity"):GetInt() )* -1) );
	View.x = math.Clamp(View.x + ( ((fwdmouse.y / 250) * GetConVar("sensitivity"):GetInt() )),-89,89 );
	View:Normalize()
	if (pMenuVars.CheckBoxes["HvH Enable"] != nil && pMenuVars.CheckBoxes["HvH Enable"].value) then
		local CurAngles = pCmd:GetViewAngles()
		local Anglez = Angle(View.x,View.y,0);




		if (pMenuVars.CheckBoxes["HvH Antiaim"].value && pMenuVars.Sliders["HvH Fake Ang"] != nil) then
			Anglez = Angle(pMenuVars.Sliders["HvH Pitch"].value,pMenuVars.Sliders["HvH Yaw"].value,0);
			local style = pMenuVars.Sliders["HvH Style"].value;
			aa_style = style;
			if style == 1 then
				jitter = !jitter;
				if jitter then
					Anglez.y = math.NormalizeAngle(RealAngle.y + Anglez.y + 45);
				else
					Anglez.y = math.NormalizeAngle(RealAngle.y + Anglez.y - 10);
				end
				if bSendPacket then
					if IsFake then
						Anglez.y = math.NormalizeAngle(RealAngle.y + pMenuVars.Sliders["HvH Fake Ang"].value);
					else
						if jitter then
							Anglez.y = math.NormalizeAngle(RealAngle.y + Anglez.y + 45);
						else
							Anglez.y = math.NormalizeAngle(RealAngle.y + Anglez.y - 10);
						end
					end
				end
			elseif style == 2 then
				if bSendPacket then
					if IsFake then
						Anglez.y = math.NormalizeAngle(RealAngle.y + (engine.TickInterval() * pMenuVars.Sliders["HvH Spin Speed"].value) + pMenuVars.Sliders["HvH Fake Ang"].value);
					else
						Anglez.y = math.NormalizeAngle(RealAngle.y + (engine.TickInterval() * pMenuVars.Sliders["HvH Spin Speed"].value));
					end
				else
					Anglez.y = math.NormalizeAngle(RealAngle.y + (engine.TickInterval() * pMenuVars.Sliders["HvH Spin Speed"].value));
				end
			elseif style == 3 then
				local rand = pMenuVars.Sliders["HvH randomY"].value;
				if bSendPacket then 
					if IsFake then
						Anglez.y = math.NormalizeAngle(RealAngle.y + Anglez.y + math.random(rand * -1,rand) + pMenuVars.Sliders["HvH Fake Ang"].value);
					else
						Anglez.y = math.NormalizeAngle(RealAngle.y + Anglez.y + math.random(rand * -1,rand));
					end
				else
					Anglez.y = math.NormalizeAngle(RealAngle.y + Anglez.y + math.random(rand * -1,rand));
				end
			elseif style == 4 then
				local ent = pMenu.ClosestEntToCrossNLOS(720,pCmd,nil,View)
				if ent == NULL then
					if bSendPacket then
						if IsFake then
							Anglez.y = math.NormalizeAngle(View.y + Anglez.y + pMenuVars.Sliders["HvH Fake Ang"].value);
						else
							Anglez.y = math.NormalizeAngle(View.y + Anglez.y);
						end
					else
						Anglez.y = math.NormalizeAngle(View.y + Anglez.y);
					end
				else
					local pos = ent:EyePos()
					local End = pMenu.GetAngle(LocalPlayer():EyePos(),pos);
					if bSendPacket then
						if IsFake then
							Anglez.y = math.NormalizeAngle(End.y + Anglez.y + pMenuVars.Sliders["HvH Fake Ang"].value);
						else
							Anglez.y = math.NormalizeAngle(End.y + Anglez.y);
						end
					else
						Anglez.y = math.NormalizeAngle(End.y + Anglez.y);
					end
				end
			elseif style == 5 then
				Anglez.y = math.NormalizeAngle(Anglez.y);
				if bSendPacket  && IsFake then
					Anglez.y = Anglez.y + pMenuVars.Sliders["HvH Fake Ang"].value
				end
			elseif style == 6 then
				Anglez.y = math.NormalizeAngle(View.y + Anglez.y);
				if bSendPacket  && IsFake then
					Anglez.y = Anglez.y + pMenuVars.Sliders["HvH Fake Ang"].value
				end
			end
		end




		if bSendPacket == false then
			if IsFake then
				RealAngle = Anglez
			end
		end
		if bSendPacket then
			if IsFake then
				FakeAngles = Anglez
			else
				RealAngle = Anglez
			end
		end
		if bSendPacket && pMenu.CanShoot() then
			if pMenuVars.CheckBoxes["HvH Autoshoot"].value || input.IsKeyDown(pMenuVars.Sliders["Aimbot Key"].value)  then
				local ent = pMenu.ClosestEntToCross(720,pCmd,"ValveBiped.Bip01_Head1",View);
				if ent != NULL then
					local poz = Vector(0,0,0);
					if pMenuVars.CheckBoxes[ent:SteamID().."Backtrack"] != nil && pMenuVars.CheckBoxes[ent:SteamID().."Backtrack"].value then // idk someone told me to do this doesn't really do anything
						local Amt = pMenuVars.Sliders[ent:SteamID().."Backtrack"].value;
						local curkey = BackTrack[ent:SteamID()].LastKey;
						local maxback = #BackTrack[ent:SteamID()] - 1
						if curkey - Amt <= 0 then
							poz = BackTrack[ent:SteamID()][maxback + (curkey - Amt)].pos;
						else
							poz = BackTrack[ent:SteamID()][(curkey - Amt)].pos;
						end
					else
						if pMenuVars.CheckBoxes[ent:SteamID().."Baim"] != nil && pMenuVars.CheckBoxes[ent:SteamID().."Baim"].value then
							local center = ent:OBBCenter()
							poz = ent:GetPos() + center;
						else
							local head = ent:LookupBone("ValveBiped.Bip01_Head1")
							poz = ent:GetBonePosition(head)
						end
					end
					local End = pMenu.GetAngle(LocalPlayer():EyePos(),poz);
					Anglez.y = math.NormalizeAngle(End.y);
					Anglez.x = math.NormalizeAngle(End.x);
					pMenu.Shoot(pCmd)
				end
			end
		end
		if Anglez != nil then
			pCmd:SetViewAngles(Anglez)
		end
	end
	if pMenuVars.CheckBoxes["MISC CStrafe"] != nil && pMenuVars.CheckBoxes["MISC CStrafe"].value && input.IsKeyDown(KEY_E) then
		if !LocalPlayer():IsOnGround() then
			test_int = test_int + (200 * FrameTime());
		end
		if test_int > 360 then
			test_int = 0;
		end
		local FakeView = Angle(View.x,View.y + test_int,0.0)
		pMenu.FixMovement(pCmd,FakeView,pCmd:GetViewAngles())
	else
		if pMenuVars.CheckBoxes["HvH Antiaim"] != nil && pMenuVars.CheckBoxes["HvH Antiaim"].value && pMenuVars.CheckBoxes["HvH Enable"].value then
			T2 = 0;
			test_int = 0;
			pMenu.FixMovement(pCmd,View,pCmd:GetViewAngles())
		end
	end
	if input.IsKeyDown(KEY_O) && pMenu.CanShoot() then
		pMenu.Shoot(pCmd)
	end
end)
hook.Add( "OnPlayerChat", "hkOnPlayerChat", function( ply, strText, bTeam, bDead )
	if pMenuVars.CheckBoxes["MISC Text to speech is fucking aids"] != nil && pMenuVars.CheckBoxes["MISC Text to speech is fucking aids"].value then
		strText = string.lower( strText )
		local player = ply:Nick()

		local text = player.." said "..strText;
		sound.PlayURL("https://api.ispeech.org/api/rest?apikey=34b06ef0ba220c09a817fe7924575123&action=convert&voice=usenglishmale&speed=1&pitch=100&text="..text,"mono",function(snd)
			if IsValid(snd) then
				snd:Play()
				snd:SetVolume(1)
			end
		end)
	end
end)
concommand.Add("b1g_menu",pMenu.ToggleMenu)

local DNum = 0;
local Anti_pResolver = {}
Anti_pResolver[1] = 70;
Anti_pResolver[2] = 125;
Anti_pResolver[3] = 180;
Anti_pResolver[4] = 290;


hook.Add( "entity_killed", "", function( data )
	local inflictor_index = data.entindex_inflictor 
	local victim_index = data.entindex_killed
	local killer = EntIndexToEnt(inflictor_index);
	if victim_index == LocalPlayer():EntIndex() then
		DNum = DNum + 1;
		if DNum > 5 then
			DNum = 1;
		end
		if pMenuVars.CheckBoxes[killer:SteamID().."Anti pResolver"].value then
			pMenuVars.Sliders["HvH Fake Ang"].value = Anti_pResolver[DNum]
		end
	end
	if victim_index != inflictor_index && inflictor_index == LocalPlayer():EntIndex() then
		LocalPlayer():ConCommand('"say lmao ez"')
	end
end)


hook.Add("Tick","hkTickBTrack",function()
	local maxlog = backtrackamt / engine.TickInterval()
	for k,v in pairs(player.GetAll()) do
		if BackTrack[v:SteamID()] == nil then
			BackTrack[v:SteamID()] = {}
			BackTrack[v:SteamID()].LastKey = 0;
		end

		local key = BackTrack[v:SteamID()].LastKey;
		key = key + 1;
		if key > maxlog then
			key = 1;
		end
		BackTrack[v:SteamID()].LastKey = key 
		if pMenuVars.CheckBoxes[v:SteamID().."Baim"] != nil && pMenuVars.CheckBoxes[v:SteamID().."Baim"].value then
			local center = v:OBBCenter()
			local poz = v:GetPos() + center;
			BackTrack[v:SteamID()][key] = {pos = poz}
		else
			local poz = v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Head1"));
			BackTrack[v:SteamID()][key] = {pos = poz}
		end
	end
end)

local Marker = Material( "test.png" )
function doHitMarker()
	surface.PlaySound("hitmarker.wav")
	local Frame = vgui.Create( "DFrame" )
	Frame:SetTitle( "" )
	Frame:SetSize( 30, 30 )
	Frame:Center()
	Frame:ShowCloseButton(false)
	Frame.Paint = function( self, w, h )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( Marker	)
		surface.DrawTexturedRect( 0, 0, w, h )
	end
	timer.Simple(0.2,function()
		Frame:Close()
	end)
end
gameevent.Listen( "player_hurt" )
hook.Add( "player_hurt", "player_hurt_example", function( data )
	local health = data.health
	local id = data.userid
	local attackerid = data.attacker
	if data.attacker == LocalPlayer():UserID() then
		doHitMarker()
	end
end )
local crossdist = 0;
local crossdist2 = 15
hook.Add("HUDPaint","Paint",function()
	if bSendPacket then
		draw.SimpleText(bSendPacket,FontL,0,0,Color(0,0,255,255))
	else
		draw.SimpleText(bSendPacket,FontL,0,0,Color(255,0,0,255))
	end
	
	pMenu.Drawline(ScrW() / 2 - 10,ScrH() / 2 - 10,ScrW() / 2 + 10,ScrH() / 2 + 10,Color(255,255,255,255))
	pMenu.Drawline(ScrW() / 2 - 10,ScrH() / 2 + 10,ScrW() / 2 + 10,ScrH() / 2 - 10,Color(255,255,255,255))
end)
local aa_mod = NULL
local aa_m_pos = 0;
local aa_modPos = {}
local last = RealTime()
hook.Add("RenderScene","AA Model",function()
	if pMenuVars.CheckBoxes["HvH Enable"] != nil && pMenuVars.CheckBoxes["HvH Enable"].value then
		if aa_mod == NULL then
			aa_mod = ClientsideModel( LocalPlayer():GetModel(),1 )
		end
		aa_mod:SetNoDraw(true)
		aa_mod:SetSequence(LocalPlayer():GetSequence())
		aa_mod:SetCycle( LocalPlayer():GetCycle() )
		local End = 1;
		local flAmt = 0
		if pMenuVars.Sliders["HvH Choke Packet"] != nil then
			flAmt = pMenuVars.Sliders["HvH Choke Packet"].value
		end
		if aa_m_pos - flAmt < 0 then
			End = 15 + (aa_m_pos - flAmt)
		elseif aa_m_pos - flAmt == 0 then
			End = 15;
		elseif aa_m_pos - flAmt > 0 then
			End = aa_m_pos - flAmt
		end
		if #aa_modPos >= 15 && LocalPlayer():Alive() then
			local poz = aa_modPos[End].pos
			aa_mod:SetModel(LocalPlayer():GetModel())
			aa_mod:SetPos(poz)
			aa_mod:SetAngles(Angle(0,FakeAngles.y,0))
			aa_mod:SetPoseParameter("aim_pitch", FakeAngles.p);
			aa_mod:SetPoseParameter("move_x", LocalPlayer():GetPoseParameter("move_x"));
			aa_mod:SetPoseParameter("move_y", LocalPlayer():GetPoseParameter("move_y"));
			aa_mod:SetPoseParameter("head_pitch",FakeAngles.p);
			aa_mod:SetPoseParameter("body_yaw", FakeAngles.y );
			aa_mod:SetPoseParameter("aim_yaw", 0);
			aa_mod:InvalidateBoneCache();
			aa_mod:SetRenderAngles(Angle(0, FakeAngles.y, 0));
		end
	end
end)
hook.Add("Tick","PrevPosaamod",function()
	aa_m_pos = aa_m_pos + 1;
	if aa_m_pos > 15 then
		aa_m_pos = 1
	end
	aa_modPos.LastKey = aa_m_pos;
	if aa_modPos[aa_m_pos] == nil then
		aa_modPos[aa_m_pos] = {pos = LocalPlayer():GetPos(),angle = LocalPlayer():EyeAngles()}
	else
		aa_modPos[aa_m_pos].pos = LocalPlayer():GetPos()
		aa_modPos[aa_m_pos].angle = LocalPlayer():EyeAngles()
	end
end)
function pMenu.DrawFakeAngle(v)
	cam.Start3D()
		render.SuppressEngineLighting(false)
		if v:IsValid() then
			render.MaterialOverride(chamsmat2)
			render.SetColorModulation(0.6,0.6,0.6)
			v:DrawModel()
		end
	cam.End3D()
end
hook.Add("RenderScreenspaceEffects","Cancer ",function()
	if IsFake  && pMenuVars.CheckBoxes["HvH Show FA"] != nil && pMenuVars.CheckBoxes["HvH Show FA"].value && pMenuVars.CheckBoxes["HvH Enable"].value then
		pMenu.DrawFakeAngle(aa_mod)
	end
	render.SuppressEngineLighting( false )
end) 
local SourceSkyname = GetConVar("sv_skyname"):GetString()
local orgskyname = SourceSkyname;
local SourceSkyPre  = {"lf","ft","rt","bk","dn","up",}
local SourceSkyMat  = {
    Material("skybox/"..SourceSkyname.."lf"),
    Material("skybox/"..SourceSkyname.."ft"),
    Material("skybox/"..SourceSkyname.."rt"),
    Material("skybox/"..SourceSkyname.."bk"),
    Material("skybox/"..SourceSkyname.."dn"),
    Material("skybox/"..SourceSkyname.."up"),
}
function ChangeSkybox(skyboxname)
    for i = 1,6 do
        local D = Material("skybox/"..skyboxname..SourceSkyPre[i]):GetTexture("$basetexture")
        SourceSkyMat[i]:SetTexture("$basetexture",D)
    end
end
hook.Add("RenderScene", "Get cancer and die", function()
	if pMenuVars.CheckBoxes["MISC Night-mode"] != nil && pMenuVars.CheckBoxes["MISC Night-mode"].value then
		ChangeSkybox("sky_borealis01")
		for k,v in pairs(game.GetWorld():GetMaterials()) do
			Material(v):SetVector("$color",Vector(0.05,0.05,0.05))
		end
		render.SuppressEngineLighting( true )
		render.ResetModelLighting(0.2,0.2,0.2)
	else
		ChangeSkybox("sky_day03_05")
		for k,v in pairs(game.GetWorld():GetMaterials()) do
			Material(v):SetVector("$color",Vector(1,1,1))
		end
	end
end)
