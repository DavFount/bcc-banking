local VORPcore = {}

local Banks = {}
local IsReady = false

TriggerEvent('getCore', function(core)
  VORPcore = core
end)

-- Wait until client loads a character and get bank info
RegisterNetEvent('vorp:SelectedCharacter')
AddEventHandler('vorp:SelectedCharacter', function(charid)
  TriggerServerEvent('bcc-banking:getBanks')
end)

-- Set Banks and start the script
RegisterNetEvent('bcc-banking:returnBanks', function(banks)
  Banks = banks
  IsReady = true
end)

CreateThread(function()
  BankOpen()
  BankClosed()

  while true do
    Wait(0)
    local sleep = true
    if IsReady then
      local player = PlayerPedId()
      local coords = GetEntityCoords(player)
      local hour = GetClockHours()

      for _, v in pairs(Banks) do
        if v.OpenHour and v.CloseHour then
          if hour >= v.CloseHour or hour < v.OpenHour then
            -- After Hours Blip
            if Config.ShowBlipClosed then
              if v.BlipHandle then
                RemoveBlip(v.BlipHandle)
                v.BlipHandle = nil
              end
              v.BlipHandle = AddBlip(v, false)
            else
              if v.BlipHandle then
                RemoveBlip(v.BlipHandle)
                v.BlipHandle = nil
              end
            end

            -- Remove NPC if he's present
            if v.NPC then
              DeleteEntity(v.NPC)
              v.NPC = nil
            end

            local pcoords = vector3(coords.x, coords.y, coords.z)
            local scoords = vector3(tonumber(v.X), tonumber(v.Y), tonumber(v.Z))
            local sDistance = #(pcoords - scoords)

            if sDistance <= Config.PromptDistance then
              sleep = false
              local bankClosed = CreateVarString(10, 'LITERAL_STRING', v.Name .. _U('closed'))
              PromptSetActiveGroupThisFrame(GetClosedPromptGroup(), bankClosed)

              if Citizen.InvokeNative(0xC92AC953F0A982AE, GetClosedPrompt()) then -- UiPromptHasStandardModeCompleted
                Wait(100)
                VORPcore.NotifyRightTip(
                  v.Name ..
                  _U('hours') .. v.OpenHour .. _U('to') .. v.CloseHour .. _U('hundred'), 4000)
              end
            end
          elseif hour >= v.OpenHour then
            -- During Hours
            local pcoords = vector3(coords.x, coords.y, coords.z)
            local scoords = vector3(tonumber(v.X), tonumber(v.Y), tonumber(v.Z))
            local sDistance = #(pcoords - scoords)

            -- Prompts
            if sDistance <= Config.PromptDistance then
              sleep = false
              local bankOpen = CreateVarString(10, 'LITERAL_STRING', v.Name)
              PromptSetActiveGroupThisFrame(GetOpenPromptGroup(), bankOpen)

              if Citizen.InvokeNative(0xC92AC953F0A982AE, GetOpenPrompt()) then -- UiPromptHasStandardModeCompleted
                print('TODO: Prompt Pressed Open UI')
              end
            end

            -- Blip
            if Config.ShowBlips and not v.BlipHandle then
              v.BlipHandle = AddBlip(v, true)
            end

            if sDistance <= Config.SpawnDistance then
              if Config.ShowNPC and not v.NPC then
                v.NPC = AddNPC(v)
              end
            end
          end
        else
          -- During Hours
          local pcoords = vector3(coords.x, coords.y, coords.z)
          local scoords = vector3(tonumber(v.X), tonumber(v.Y), tonumber(v.Z))
          local sDistance = #(pcoords - scoords)

          -- Prompts
          if sDistance <= Config.PromptDistance then
            sleep = false
            local bankOpen = CreateVarString(10, 'LITERAL_STRING', v.Name)
            PromptSetActiveGroupThisFrame(GetOpenPromptGroup(), bankOpen)

            if Citizen.InvokeNative(0xC92AC953F0A982AE, GetOpenPrompt()) then -- UiPromptHasStandardModeCompleted
              print('TODO: Prompt Pressed Open UI')
            end
          end

          -- Blip
          if Config.ShowBlips and not v.BlipHandle then
            v.BlipHandle = AddBlip(v, true)
          end

          if sDistance <= Config.SpawnDistance then
            if Config.ShowNPC and not v.NPC then
              v.NPC = AddNPC(v)
            end
          end
        end
      end
    end
    if sleep then
      Wait(1000)
    end
  end
end)

-- Unlock Doors (Credits: vorp_banking)
CreateThread(function()
  for door, state in pairs(Config.Doors) do
    if not IsDoorRegisteredWithSystem(door) then
      Citizen.InvokeNative(0xD99229FE93B46286, door, 1, 1, 0, 0, 0, 0)
    end
    DoorSystemSetDoorState(door, state)
  end
end)

AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  DeletePrompts()
  ClearBlips(Banks)
end)
