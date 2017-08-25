function pMenu.IsNetString(netstring) // pmeme
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
function pMenu.MouseInArea(frame,minx,miny,maxx,maxy)
	local PosX,PosY = frame:GetPos()
	local posx,posy = gui.MousePos();
	return ((posx >= minx && posx <= maxx) && (posy >= miny && posy <= maxy));
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
