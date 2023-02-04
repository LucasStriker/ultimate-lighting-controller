print("[ULC]: Cruise lights Loaded")

-- 0 on, 1 off
local function setCruiseLights(newState)
    print("Setting cruise " .. newState)
    for _, v in pairs(MyVehicleConfig.steadyBurnConfig.sbExtras) do
        SetStageByExtra(v, newState, false)
    end
end

RegisterNetEvent('ulc:checkLightTime', function(delay)
    print("Checking cruise")
    CreateThread(function()
        local vehicle = GetVehiclePedIsIn(PlayerPedId())
        if MyVehicle then
            if delay then Wait(2000) end
            if (MyVehicleConfig.steadyBurnConfig.disableWithLights or false) and Lights then print("Not running") return end
            if not AreVehicleDoorsClosed(vehicle) or not IsVehicleHealthy(vehicle) then return end
            if MyVehicleConfig.steadyBurnConfig.forceOn then setCruiseLights(0) return end
            if GetClockHours() > Config.SteadyBurnSettings.nightStartHour or GetClockHours() < Config.SteadyBurnSettings.nightEndHour then
                setCruiseLights(0)
            else
                setCruiseLights(1)
            end
        end
    end)
end)

CreateThread(function()
    while true do
        if MyVehicle then
            TriggerEvent('ulc:checkLightTime', false)
        end
        Wait(Config.SteadyBurnSettings.delay * 1000)
    end
end)

--TODO: disable when lights are on, disable when lights are off

AddEventHandler('ulc:lightsOn', function()
    print("Lights on")
    if MyVehicle and (MyVehicleConfig.steadyBurnConfig.disableWithLights or false) then
        setCruiseLights(1)
    end
end)

AddEventHandler('ulc:lightsOff', function()
    print("Lights off")
    if MyVehicle and (MyVehicleConfig.steadyBurnConfig.disableWithLights or false) then
        TriggerEvent('ulc:checkLightTime', false)
    end
end)
