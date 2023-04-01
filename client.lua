ESX = nil
local WaypointHandle
local delgun = false
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports["es_extended"]:getSharedObject()
        Citizen.Wait(5)
    end
end)

Citizen.CreateThread(function()
	while true do
		if (IsControlJustPressed(0, Keys['HOME'])) then
			TriggerServerEvent('capybara_adminsystem:server_fly')
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		if (IsControlJustPressed(0, Keys['Z'])) then
			TriggerServerEvent('capybara_adminsystem:server_boost')
		end
		Citizen.Wait(0)
	end
end)


local Raycast = function()
    local offset = GetOffsetFromEntityInWorldCoords(GetCurrentPedWeaponEntityIndex(ESX.PlayerData.ped), 0, 0, -0.01)
    local direction = GetGameplayCamRot()
    direction = vector2(direction.x * math.pi / 180.0, direction.z * math.pi / 180.0)
    local num = math.abs(math.cos(direction.x))
    direction = vector3((-math.sin(direction.y) * num), (math.cos(direction.y) * num), math.sin(direction.x))
    local destination = vector3(offset.x + direction.x * 30, offset.y + direction.y * 30, offset.z + direction.z * 30)
    local rayHandle, result, hit, endCoords, surfaceNormal, entityHit = StartShapeTestLosProbe(offset, destination, -1, ESX.PlayerData.ped, 0)
    repeat
        result, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
        Citizen.Wait(0)
    until result ~= 1
    SetEntityDrawOutline(entityHit, true)
    if IsControlPressed(0, 24) then
        SetEntityAsMissionEntity(entityHit)
        DeleteObject(entityHit)
        DeleteEntity(entityHit)
    end
end

RegisterNetEvent('getSelectedWayPoint') 
AddEventHandler('getSelectedWayPoint', function()
    WaypointHandle = GetFirstBlipInfoId(8)
end)

RegisterNetEvent("capybara_adminsystem:tpm")
AddEventHandler("capybara_adminsystem:tpm", function()
	WaypointHandle = GetFirstBlipInfoId(8)
    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                break
            end

            Citizen.Wait(5)
        end
        TriggerEvent('chatMessage', 'Egy admin elteleportált!')
    else
        TriggerEvent('chatMessage', 'Nincs kiválasztva vagypoint')
	end
end)

RegisterNetEvent('capybara_adminsystem:unflipcar')
AddEventHandler('capybara_adminsystem:unflipcar', function()
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped, true) then
        SetEntityCoords(GetVehiclePedIsIn(ped, true), GetEntityCoords(GetVehiclePedIsIn(ped, true)), 0.0, 0.0, 0.0, true)
	else
		if (GetClosestVehicle(GetEntityCoords(ped), 5.0, 0, 70) ~= 0) then
			SetEntityCoords(GetClosestVehicle(GetEntityCoords(ped), 5.0, 0, 70), GetEntityCoords(ped), 0.0, 0.0, 0.0, true)
		end
	end
end)

RegisterNetEvent('capybara_adminsystem:fix')
AddEventHandler('capybara_adminsystem:fix', function()
	local playerPed = PlayerPedId()
	if IsPedInAnyVehicle(playerPed, true) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn( vehicle, true, true )
		SetVehicleFixed(vehicle)
		SetVehicleFuelLevel(vehicle, 100.0)
	end
end)

RegisterNetEvent('capybara_adminsystem:boost')
AddEventHandler('capybara_adminsystem:boost', function()
	    local vehicle = SetVehicleBoostActive(vehicle, 100, 100)
end)

RegisterNetEvent('capybara_adminsystem:delObjects')
AddEventHandler('capybara_adminsystem:delObjects', function()
    delgun = not delgun
    if not delgun then
        local objects = GetGamePool('CObject')
        for _, entity in ipairs(objects) do
            local model = GetEntityModel(entity)
            SetEntityDrawOutline(entity, false)
        end
    end
    while delgun do
        if IsPlayerFreeAiming(PlayerId()) then
            Raycast()
        end
        Citizen.Wait(0) 
    end
end)

function getCamDirection()
	local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
	local pitch = GetGameplayCamRelativePitch()
  
	local x = -math.sin(heading*math.pi/180.0)
	local y = math.cos(heading*math.pi/180.0)
	local z = math.sin(pitch*math.pi/180.0)
  
	-- normalize
	local len = math.sqrt(x*x+y*y+z*z)
	if len ~= 0 then
	  x = x/len
	  y = y/len
	  z = z/len
	end
  
	return x,y,z
  end

  function getPosition()
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	return x,y,z
  end
  
local vanish = false

  RegisterNetEvent("vanish")
  AddEventHandler("vanish", function()
	vanish = not vanish
	while vanish do
		SetEntityVisible(GetPlayerPed(-1), false, false)
		Citizen.Wait(0)
	end
  end)

local fly = false
local fly_speed = 1.0
RegisterNetEvent("capybara_adminsystem:fly")
AddEventHandler("capybara_adminsystem:fly", function(input)
    local player = PlayerId()
	local ped = PlayerPedId()
	
    local msg = "kikapcsolva"
	if(fly == false) then
		local msg = "kikapcsolva."

		end

		fly = not fly

		if(fly)then
			msg = "bekapcsolva."
		end
	TriggerEvent("chatMessage", "Noclip sikeresen ^2^*" .. msg)
	local heading = 0

	while fly do
		Citizen.Wait(0)
		if(fly)then
		local ped = GetPlayerPed(-1)
		local x,y,z = getPosition()
		local dx,dy,dz = getCamDirection()
		local speed = fly_speed
		SetEntityVisible(GetPlayerPed(-1), false, false)
		--SetEntityInvincible(GetPlayerPed(-1), true)

		-- reset velocity
		SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)
		if IsControlPressed(0, 21) then
			speed = speed + 20
			end
		if IsControlPressed(0, 19) then
			speed = speed -0.5
		end
		-- forward
				if IsControlPressed(0,32) then -- MOVE UP
				x = x+speed*dx
				y = y+speed*dy
				z = z+speed*dz
				end

		-- backward
				if IsControlPressed(0,269) then -- MOVE DOWN
				x = x-speed*dx
				y = y-speed*dy
				z = z-speed*dz
				end
		SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
			else
			SetEntityVisible(GetPlayerPed(-1), true, false)
			--SetEntityInvincible(GetPlayerPed(-1), false)

			end
	end
end)

RegisterNetEvent('capybara_adminsystem:reviveRadius')
AddEventHandler('capybara_adminsystem:reviveRadius', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
	TriggerEvent('esx_basicneeds:resetStatus')
	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(50)
	end

	local formattedCoords = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1)
	}

	RespawnPed(playerPed, formattedCoords, 0.0)

	StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)
end)

 -- az összes parancs

    TriggerEvent('chat:addSuggestion', '/fix', 'Kocsi megjavítása', {
        { name="id", help="Játékos id" },
    })
	
	    TriggerEvent('chat:addSuggestion', '/unflip', 'Kocsi visszaállítása', {
    })
	
	    TriggerEvent('chat:addSuggestion', '/reviveinradius', 'Játékosok felszedése a környezetedbe', {
        { name="radius", help="A körölötted lévő embereket felszedi. Max radius 20" },
    })
	
	    TriggerEvent('chat:addSuggestion', '/goto', 'Játékoshoz teleportálás', {
        { name="id", help="Játékos id" },
    })
	
					TriggerEvent('chat:addSuggestion', '/setplayercoord', 'Amit bejelől a játékos oda teleportálja', {
        { name="id", help="Játékos id" },
    })


RegisterNetEvent('capybara_adminsystem:fixRadius')
AddEventHandler('capybara_adminsystem:fixRadius', function(radius)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local vehicles = ESX.Game.GetVehicles()
	
	for k,v in ipairs(vehicles) do
		if #(coords - GetEntityCoords(v)) < radius then
			SetVehicleEngineHealth(v, 1000)
			SetVehicleEngineOn( v, true, true )
			SetVehicleFixed(v)
			SetVehicleFuelLevel(v, 100.0)
		end
	end
end)

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)

	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned') -- compatibility with old scripts, will be removed soon
end