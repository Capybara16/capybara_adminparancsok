
ESX = exports["es_extended"]:getSharedObject()


RegisterCommand('setskintoplayer', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' then --bármit berakhatsz ide amilyen adminparancsaid vannak, ez lesz a mint az össze commandnál
        if args[1] ~= nil then
            local xTarget = ESX.GetPlayerFromId(args[1])
            if xTarget ~= nil then
                xTarget.triggerEvent('esx_skin:openSaveableMenu')
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nem megfelelő ID!')
            end
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nem megfelelő ID!')
        end
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nem vagy admin!')
    end
end, false)


RegisterCommand('setplayercoord', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' then --bármit berakhatsz ide amilyen adminparancsaid vannak, ez lesz a mint az össze commandnál
        if args[1] ~= nil then
            local xTarget = ESX.GetPlayerFromId(args[1])
            if xTarget ~= nil then
                xTarget.triggerEvent('capybara_adminsystem:tpm')
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nem megfelelő ID!')
            end
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nem megfelelő ID!')
        end
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nem vagy admin!')
    end
end, false)

RegisterCommand('unflip', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' then
        if args[1] and args[1] ~= 'me' then
            local xTarget = ESX.GetPlayerFromId(args[1])
            if xTarget then
                TriggerClientEvent('capybara_adminsystem:unflipcar', xTarget.source)
                TriggerClientEvent('esx:showNotification', xPlayer.source, "Sikeresen felfordítottad ".. GetPlayerName(xTarget.source) .. " nevű játékosnak a kocsiját!")
                TriggerClientEvent('esx:showNotification', xTarget.source, GetPlayerName(xPlayer.source) .. " felfordította a kocsidat")
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nem megfelelő ID!')
            end
        else
            TriggerClientEvent('capybara_adminsystem:unflipcar', xPlayer.source)
        end
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nem vagy admin!')
    end
end, false)

RegisterCommand("boost", function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' then
        if args[1] == nil or args[1] == 'me' then
            if xPlayer then
                xPlayer.triggerEvent("capybara_adminsystem:fix")
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Sikeresen megfixáltad a kocsid!')
            end
        else
            local xTarget = ESX.GetPlayerFromId(args[1])
            if xTarget then
                xTarget.triggerEvent("capybara_adminsystem:fix")
                TriggerClientEvent('esx:showNotification', xPlayer.source, "Sikeresen megfixáltad a következő játékos kocsiját: " .. GetPlayerName(xTarget.source))
                TriggerClientEvent('esx:showNotification', xTarget.source, GetPlayerName(xPlayer.source) .. " megfixálta a kocsidat!")
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nem megfelelő ID!')
            end
        end
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nem vagy admin!')
	end
end, false)

RegisterCommand("fix", function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'tulajdonos' or xPlayer.getGroup() == 'operator' or xPlayer.getGroup() == 'szervermanager' or xPlayer.getGroup() == 'vezeradmin'  or xPlayer.getGroup() == 'communitymanager' or xPlayer.getGroup() == 'vezerfejlesztö' or xPlayer.getGroup() == 'fejlesztötanuló' or xPlayer.getGroup() == 'fejlesztö' then
        if args[1] == nil or args[1] == 'me' then
            if xPlayer then
                xPlayer.triggerEvent("capybara_adminsystem:fix")
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Sikeresen megfixáltad a kocsid!')
            end
        else
            local xTarget = ESX.GetPlayerFromId(args[1])
            if xTarget then
                xTarget.triggerEvent("capybara_adminsystem:fix")
                TriggerClientEvent('esx:showNotification', xPlayer.source, "Sikeresen megfixáltad a következő játékos kocsiját: " .. GetPlayerName(xTarget.source))
                TriggerClientEvent('esx:showNotification', xTarget.source, GetPlayerName(xPlayer.source) .. " megfixálta a kocsidat!")
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nem megfelelő ID!')
            end
        end
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nem vagy admin!')
	end
end, false)

RegisterCommand('delgun', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' then
        TriggerClientEvent('capybara_adminsystem:delObjects', xPlayer.source)
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nem vagy admin!')
    end
end, false)

RegisterNetEvent('capybara_adminsystem:server_fly')
AddEventHandler('capybara_adminsystem:server_fly', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' then
        if source ~= 0 then
            TriggerClientEvent("capybara_adminsystem:fly", xPlayer.source)
        end
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nem vagy admin!')
    end
end, false)

RegisterCommand("reviveinradius", function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
    local players = ESX.GetPlayers()
	if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' then
        if args[1] ~= nil then
            for _,v in ipairs(players) do
                if #(xPlayer.getCoords(true) - ESX.GetPlayerFromId(v).getCoords(true)) <= tonumber(args[1]) then
                    TriggerClientEvent("capybara_adminsystem:reviveRadius", ESX.GetPlayerFromId(v).source)
                end
            end
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nem megfelelő ID!')
        end
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nem vagy admin!')
    end
end, false)

RegisterCommand("fixradius", function(source, args, rawCommand) 
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' then
        if args[1] ~= nil then
            TriggerClientEvent("capybara_adminsystem:fixRadius", xPlayer.source, tonumber(args[1]))
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nem megfelelő radius!')
        end
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nem vagy admin!')
    end
end, false)


