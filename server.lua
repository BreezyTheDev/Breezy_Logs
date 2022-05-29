--================================--
--      Breezy_Logs 1.0       --
--      by BreezyTheDev             --
--      License: GNU GPL 3.0      --
--================================--

-- Events
AddEventHandler('playerDropped', function(reason)
	-- Disconnect
	local id = source
	local name = GetPlayerName(source)
	local ids = ExtractIdentifiers(id);
	local steam = ids.steam:gsub("steam:", "");
	local steamDec = tostring(tonumber(steam,16));
	steam = "https://steamcommunity.com/profiles/" .. steamDec;
	local gameLicense = ids.license;
	local discord = ids.discord;
	DisconnectionLog("❌ ".. name .." Disconnected", 
		'__**Reason:**__\n Player was disconnected from the server for: '..reason..'\n' ..
		'\n__**Identifiers:**__'..
		'\n' ..
		'**Server ID:** \n'..id.. '\n' ..
		'**Discord Tag:** \n<@'.. discord:gsub('discord:', '').. '>\n' ..
		'**Discord UID:** \n' .. discord:gsub('discord:', '').. '\n ' ..
		'**Steam URL:** \n' .. steam .. '\n' ..
		'**GameLicense:** \n' .. gameLicense .. '\n', "Connection Logs")
end)

RegisterNetEvent('playerConnecting')
AddEventHandler('playerConnecting', function()
	-- Connect
	local id = source
	local name = GetPlayerName(source)
	local ids = ExtractIdentifiers(id);
	local steam = ids.steam:gsub("steam:", "");
	local steamDec = tostring(tonumber(steam,16));
	steam = "https://steamcommunity.com/profiles/" .. steamDec;
	local gameLicense = ids.license;
	local discord = ids.discord;
	ConnectionLog("✔️ ".. name .." Connected", 
		'\n__**Identifiers:**__'..
		'\n' ..
		'**Discord Tag:** \n<@'.. discord:gsub('discord:', '').. '>\n' ..
		'**Discord UID:** \n' .. discord:gsub('discord:', '').. '\n ' ..
		'**Steam URL:** \n' .. steam .. '\n' ..
		'**GameLicense:** \n' .. gameLicense .. '\n', "Connection Logs")
end)

-- Functions
function DisconnectionLog(title, message, footer)
	local embed = {}
	embed = {
		{
			["color"] = Config.webhooks["dwebhookcolor"], 
			["title"] = "**".. title .."**",
			["description"] = "" .. message ..  "",
			["footer"] = {
				["text"] = footer,
			},
		}
	}
	-- Start
	-- TODO Input Webhook
	PerformHttpRequest(Config.webhooks["all"], function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed, content = ""}), { ['Content-Type'] = 'application/json' })
	PerformHttpRequest(Config.webhooks["disconnectionlogs"], function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed, content = ""}), { ['Content-Type'] = 'application/json' })
  -- END
end
function ConnectionLog(title, message, footer)
	local embed = {}
	embed = {
		{
			["color"] = Config.webhooks["cwebhookcolor"], 
			["title"] = "**".. title .."**",
			["description"] = "" .. message ..  "",
			["footer"] = {
				["text"] = footer,
			},
		}
	}
	-- Start
	-- TODO Input Webhook
	PerformHttpRequest(Config.webhooks["all"], function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed, content = ""}), { ['Content-Type'] = 'application/json' })
	PerformHttpRequest(Config.webhooks["connectionlogs"], function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed, content = ""}), { ['Content-Type'] = 'application/json' })
  -- END
end

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end