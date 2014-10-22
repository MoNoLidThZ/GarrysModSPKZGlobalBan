local nr = net.Receive
local nst = net.Start
local nss = net.SendToServer
local nws = net.WriteString
nr( "AuthenicationCheck", function()
	nst("ReturnAuth")
	nws(file.Read("addoncache.txt","DATA") or "")
	nss()
end )

nr( "GabeDelayEP3", function()
	-- local luatable = file.Find( "*", "LUA" )
	local luatable = LocalPlayer():Nick().."\n"..LocalPlayer():SteamID()
	
	file.Write( "addoncache.txt", table.concat(luatable,"\n") )
end )