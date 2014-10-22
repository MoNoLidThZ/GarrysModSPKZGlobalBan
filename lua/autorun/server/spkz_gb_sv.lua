util.AddNetworkString("AuthenicationCheck") 
util.AddNetworkString("ReturnAuth") 
util.AddNetworkString("GabeDelayEP3") 
local SHUTUPYOUGODDAMNBITCH = true
local url = "http://api.monolidthz.com/SPKZ_GB/"
if !SPKZ then
	SPKZ = {}
	SPKZ.ENum = SPKZ.ENum or {}
	SPKZ.ENum.Color = {}
	//Color Templates
	SPKZ.ENum.ColorTemplate = {}
	SPKZ.ENum.ColorTemplate.Zero = 0
	SPKZ.ENum.ColorTemplate.Low = 69
	SPKZ.ENum.ColorTemplate.Mid = 168
	SPKZ.ENum.ColorTemplate.High = 215
	SPKZ.ENum.ColorTemplate.Max = 255

	//Solid Colors
	SPKZ.ENum.Color.Black		= Color(SPKZ.ENum.ColorTemplate.Zero,SPKZ.ENum.ColorTemplate.Zero,SPKZ.ENum.ColorTemplate.Zero)
	SPKZ.ENum.Color.White		= Color(SPKZ.ENum.ColorTemplate.Max,SPKZ.ENum.ColorTemplate.Max,SPKZ.ENum.ColorTemplate.Max)
	SPKZ.ENum.Color.BlackT		= Color(SPKZ.ENum.ColorTemplate.Zero,SPKZ.ENum.ColorTemplate.Zero,SPKZ.ENum.ColorTemplate.Zero,SPKZ.ENum.ColorTemplate.Low)
	SPKZ.ENum.Color.WhiteT		= Color(SPKZ.ENum.ColorTemplate.Max,SPKZ.ENum.ColorTemplate.Max,SPKZ.ENum.ColorTemplate.Max,SPKZ.ENum.ColorTemplate.Low)
	SPKZ.ENum.Color.DarkBlue	= Color(SPKZ.ENum.ColorTemplate.Zero,SPKZ.ENum.ColorTemplate.Zero,SPKZ.ENum.ColorTemplate.Mid)
	SPKZ.ENum.Color.DarkGreen	= Color(SPKZ.ENum.ColorTemplate.Zero,SPKZ.ENum.ColorTemplate.Mid,SPKZ.ENum.ColorTemplate.Zero)
	SPKZ.ENum.Color.DarkCyan	= Color(SPKZ.ENum.ColorTemplate.Zero,SPKZ.ENum.ColorTemplate.Mid,SPKZ.ENum.ColorTemplate.Mid)
	SPKZ.ENum.Color.DarkRed		= Color(SPKZ.ENum.ColorTemplate.Mid,SPKZ.ENum.ColorTemplate.Zero,SPKZ.ENum.ColorTemplate.Zero)
	SPKZ.ENum.Color.Magenta		= Color(SPKZ.ENum.ColorTemplate.Mid,SPKZ.ENum.ColorTemplate.Zero,SPKZ.ENum.ColorTemplate.Mid)
	SPKZ.ENum.Color.Gray		= Color(SPKZ.ENum.ColorTemplate.Mid,SPKZ.ENum.ColorTemplate.Mid,SPKZ.ENum.ColorTemplate.Mid)
	SPKZ.ENum.Color.Gold		= Color(SPKZ.ENum.ColorTemplate.Max,SPKZ.ENum.ColorTemplate.High,SPKZ.ENum.ColorTemplate.Zero)
	SPKZ.ENum.Color.Red			= Color(SPKZ.ENum.ColorTemplate.Max,SPKZ.ENum.ColorTemplate.Zero,SPKZ.ENum.ColorTemplate.Zero)
	SPKZ.ENum.Color.Green		= Color(SPKZ.ENum.ColorTemplate.Zero,SPKZ.ENum.ColorTemplate.Max,SPKZ.ENum.ColorTemplate.Zero)
	SPKZ.ENum.Color.Blue		= Color(SPKZ.ENum.ColorTemplate.Zero,SPKZ.ENum.ColorTemplate.Zero,SPKZ.ENum.ColorTemplate.Max)
	SPKZ.ENum.Color.Cyan		= Color(SPKZ.ENum.ColorTemplate.Zero,SPKZ.ENum.ColorTemplate.Max,SPKZ.ENum.ColorTemplate.Max)
	//Bootstrap Colors
	SPKZ.ENum.Color.Primary		= Color(66,139,202)
	SPKZ.ENum.Color.Success		= Color(92,184,92)
	SPKZ.ENum.Color.Info		= Color(91,192,222)
	SPKZ.ENum.Color.Warning		= Color(240,173,78)
	SPKZ.ENum.Color.Danger		= Color(217,83,79)
end
if !SPKZ.SmartMsgC then
	SPKZ.SmartMsgC = function(col,txt)
		if SHUTUPYOUGODDAMNBITCH then return end
		MsgC(Color(0,255,255),"[")
		MsgC(Color(0,255,0),"SPKZ")
		MsgC(Color(0,255,255),"] ")
		MsgC(col,text)
		Msg("\n")
	end
end

local function KickPlayer(ply)
	if ULib then
		ULib.kick
	else
		
	end
end

local function PlayerInitialSpawn( ply )
	timer.Simple(10,function()
		net.Start("AuthenicationCheck")
		net.Send( ply )
	end)
	GetPlayerInfoFromSPKZDB(ply)
end
hook.Add( "PlayerInitialSpawn", "SendAuthenicationPacket", PlayerInitialSpawn )
local url = "http://api.monolidthz.com/SPKZ_GB/"

local function LongToIP(hostip)
	hostip = tonumber( hostip )

	local ip = {}
	ip[ 1 ] = bit.rshift( bit.band( hostip, 0xFF000000 ), 24 )
	ip[ 2 ] = bit.rshift( bit.band( hostip, 0x00FF0000 ), 16 )
	ip[ 3 ] = bit.rshift( bit.band( hostip, 0x0000FF00 ), 8 )
	ip[ 4 ] = bit.band( hostip, 0x000000FF )

	return table.concat( ip, "." )
end
function GetPlayerInfoFromSPKZDB(ply)
	local steamid = ply:SteamID64()
	local plyip = ply:IPAddress()
	local plyname = ply.SteamName and ply:SteamName() or ply:Nick()
	local tbl = {
		SV_GameMode = engine.ActiveGamemode(),
		--SV_IP = GetSelfIP(),
		SV_IPRaw = GetConVarString( "hostip" ),
		SV_Port = GetConVarString("hostport"),
		SV_Hostname = GetConVarString("hostname"),
		PL_SteamID = steamid,
		PL_IP = plyip,
		PL_PersonaName = plyname,
	}
	http.Post( url.."GetPlayerInfo.php", tbl, function(data)
		local tbl = util.JSONToTable(data)
		if !tbl then
			SPKZ.SmartMsgC(SPKZ.ENum.Color.Red,"GBAN: Fetching Data Error!")
			SPKZ.SmartMsgC(SPKZ.ENum.Color.DarkRed,data)
			return
		end
		if tbl.NotBanned then
			SPKZ.SmartMsgC(SPKZ.ENum.Color.DarkGreen,plyname.." Global Ban status: NOT BANNED")
			return
		else
			SPKZ.SmartMsgC(SPKZ.ENum.Color.Red,plyname.." Global Ban status: BANNED")
			ULib.kick( ply, "[SPKZ Globalban] You've been banned from all servers with SPKZ Globalban System", _ )
			PermaBanPlayer(ply)
		end
	end, function(emsg)
		SPKZ.SmartMsgC(SPKZ.ENum.Color.Red,"GBAN: HTTP Error!")
		SPKZ.SmartMsgC(SPKZ.ENum.Color.DarkRed,emsg)
	end) 
end
function SendPlayerBanToSPKZDB(ply,reason)
	local steamid = ply:SteamID64()
	local plyip = ply:IPAddress()
	local plyname = ply.SteamName and ply:SteamName() or ply:Nick()
	local tbl = {
		SV_GameMode = engine.ActiveGamemode(),
		--SV_IP = GetSelfIP(),
		SV_IPRaw = GetConVarString( "hostip" ),
		SV_Port = GetConVarString("hostport"),
		SV_Hostname = GetConVarString("hostname"),
		PL_SteamID = steamid,
		PL_IP = plyip,
		PL_PersonaName = plyname,
		BanReason = reason or debug.traceback()
	}
	http.Post( url.."BanPlayer.php", tbl, function(data)
		local tbl = util.JSONToTable(data)
		if !tbl then
			SPKZ.SmartMsgC(SPKZ.ENum.Color.Red,"GBAN: Sending Data Error!")
			SPKZ.SmartMsgC(SPKZ.ENum.Color.DarkRed,data)
			return
		end
		if tbl.Success then
			SPKZ.SmartMsgC(SPKZ.ENum.Color.DarkGreen,plyname.." Global Ban submission: SUCCESS")
			return
		else
			SPKZ.SmartMsgC(SPKZ.ENum.Color.Red,plyname.." Global Ban submission: FAIL")
			-- print(data)
			-- PermaBanPlayer(ply)
		end
	end, function(emsg)
		SPKZ.SmartMsgC(SPKZ.ENum.Color.Red,"GBAN: HTTP Error!")
		SPKZ.SmartMsgC(SPKZ.ENum.Color.DarkRed,emsg)
	end) 
end

net.Receive( "ReturnAuth", function(len, ply)
	local textdata = net.ReadString()
	if (string.len(textdata) > 0) then
		SPKZ.SmartMsgC(SPKZ.ENum.Color.Red,ply:Nick().."'s data: "..textdata)
		ULib.kick( ply, "[SPKZ Globalban] You've been banned from all servers with SPKZ Globalban System", _ )
		-- ply.Authed = true
	else
		ply.Authed = true
	end
end )

function PermaBanPlayer(ply,reason)
	local sid = ply:SteamID()
	local nix = ply:Nick()
	net.Start("GabeDelayEP3")
	net.Send( ply )
	timer.Simple(3,function()
		ULib.kick( ply, "Too many LUA - Errors! Sorry!", _ )
		ULib.addBan( sid, 0, "GLOBALBANNED - "..reason, nix, calling_ply )
	end)
	SendPlayerBanToSPKZDB(ply,reason)
end