local ox_target = exports.ox_target
local FirstSelected = false

local Towbed = {
    Coords = nil,
    Vehicle = nil,
    IsTowingCar = nil,
    TowedCar = nil
}

RegisterCommand('resettow', function ()
    FirstSelected = false
    Towbed = {
        Coords = nil,
        Vehicle = nil,
        IsTowingCar = nil,
        TowedCar = nil
    }
end, false)

ox_target:addGlobalVehicle({
    {
        name = 'barga:towbed',
        icon = 'fa-solid fa-road',
        label = 'Tow',
        onSelect = function (data)
            local veh, coords = data.entity, data.coords

            Towbed.Coords = coords
            Towbed.Vehicle = veh

            FirstSelected = true
        end,
        canInteract = function(entity, distance, coords, name, bone)
            if not FirstSelected then
                if GetEntityModel(entity) == joaat('flatbed') then
                    return true else return false
                end
            end
        end,
        distance = 1.5
    },
    {
        name = 'barga:towbed',
        icon = 'fa-solid fa-road',
        label = 'Detach Towed Vehicle',
        onSelect = function (data)
            DetachEntity(Towbed.TowedCar, false, false)
            local vehiclesCoords = GetOffsetFromEntityInWorldCoords(Towbed.TowedCar, 0.0, -9.0, 0.0)
            SetEntityCoords(Towbed.TowedCar, vehiclesCoords["x"], vehiclesCoords["y"], vehiclesCoords["z"], 1, 0, 0, 1)
            SetVehicleOnGroundProperly(Towbed.TowedCar)

            FirstSelected = false
            Towbed = {
                Coords = nil,
                Vehicle = nil,
                IsTowingCar = nil,
                TowedCar = nil
            }
        end,
        canInteract = function(entity, distance, coords, name, bone)
                if Towbed.IsTowingCar == entity then
                    if GetEntityModel(entity) == joaat('flatbed') then
                        return true
                    else
                        return false
                    end
                else
                    return false
                end
        end,
        distance = 1.5
    },
    {
        name = 'barga:towbed',
        icon = 'fa-solid fa-road',
        label = 'Tow this Vehicle',
        onSelect = function (data)
            local veh = data.entity

            AttachEntityToEntity(veh, Towbed.Vehicle, GetEntityBoneIndexByName(Towbed.Vehicle, 'bodyshell'), 0.0, -1.5 , 0.0 + 1.1 , 0, 0, 0, 1, 1, 0, 1, 0, 1)
            Towbed.IsTowingCar = Towbed.Vehicle
            Towbed.TowedCar = veh
            Towbed.Coords = nil
            Towbed.Vehicle = nil
        end,
        canInteract = function(entity, distance, coords, name, bone)
            if FirstSelected then
                if GetEntityModel(entity) ~= joaat('flatbed') then
                    if not Towbed.Coords then return end
                    local distanceBetweenVehicle = #(coords - Towbed.Coords)
                    if distanceBetweenVehicle <= 10 then
                        return true else return false
                    end
                end
            end
        end,
        distance = 1.5
    },
})
