function ulx.permaban( calling_ply, target_ply, reason )
	if target_ply:IsBot() then
		ULib.tsayError( calling_ply, "Cannot ban a bot", true )
		return
	end
	if calling_ply:SteamID() == target_ply:SteamID() then
		ULib.tsayError( calling_ply, "Cannot ban yourself!", true )
		return
	end
	if reason and reason ~= "" then
		ulx.fancyLogAdmin( calling_ply, "#A banned #T permanently from all Thailand servers (#s)", target_ply, reason )
	else
		reason = nil
		ulx.fancyLogAdmin( calling_ply, "#A banned #T permanently from all Thailand servers", target_ply )
	end
	local admin_name, admin_steamid
	if calling_ply then
		admin_name = "(Console)"
		admin_steamid = "STEAM_ID_SERVER"
		if calling_ply:IsValid() then
			admin_name = calling_ply:Name()
			admin_steamid = calling_ply:SteamID()
		end
	end
	if SPKZ then
		if !SPKZ.ULibOverriden then
			hook.Run( "SPKZ_PlayerBanned", target_ply:SteamID(), 0, reason, target_ply:Nick(), calling_ply, admin_name,admin_steamid )
		end
	end
	PermaBanPlayer(target_ply)

end
local permaban = ulx.command( "Global Ban", "ulx permaban", ulx.permaban, "!permban" )
permaban:addParam{ type=ULib.cmds.PlayerArg }
permaban:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
permaban:defaultAccess( ULib.ACCESS_ADMIN )
permaban:help( "Permanently Ban target. (THIS BAN IS IRREVERSIBLE!)" )