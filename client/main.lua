local VORPcore = {}

local Banks = {}
local IsReady = false

local State = false

-- FOR DEBUG ONLY
RegisterCommand('make_ready', function()
  Banks = {}
  ClearBlips(Banks)
  ClearNPCs(Banks)
  IsReady = false
  TriggerServerEvent('bcc-banking:getBanks')
end)
---

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

      for _, bank in pairs(Banks) do
        if bank.OpenHour and bank.CloseHour then
          local hour = GetClockHours()
          if hour >= bank.CloseHour or hour < bank.OpenHour then
            -- After Hours Blip
            if Config.ShowBlipClosed then
              if bank.BlipHandle then
                RemoveBlip(bank.BlipHandle)
                bank.BlipHandle = nil
              end
              bank.BlipHandle = AddBlip(bank, false)
            else
              if bank.BlipHandle then
                RemoveBlip(bank.BlipHandle)
                bank.BlipHandle = nil
              end
            end

            -- Remove NPC if he's present
            if bank.NPC then
              DeleteEntity(bank.NPC)
              bank.NPC = nil
            end

            local pcoords = vector3(coords.x, coords.y, coords.z)
            local scoords = vector3(tonumber(bank.X), tonumber(bank.Y), tonumber(bank.Z))
            local sDistance = #(pcoords - scoords)

            if sDistance <= Config.PromptDistance then
              sleep = false
              local bankClosed = CreateVarString(10, 'LITERAL_STRING', bank.Name .. _U('closed'))
              PromptSetActiveGroupThisFrame(GetClosedPromptGroup(), bankClosed)

              if Citizen.InvokeNative(0xC92AC953F0A982AE, GetClosedPrompt()) then -- UiPromptHasStandardModeCompleted
                Wait(100)
                VORPcore.NotifyRightTip(
                  bank.Name ..
                  _U('hours') .. bank.OpenHour .. _U('to') .. bank.CloseHour .. _U('hundred'), 4000)
              end
            end
          elseif hour >= bank.OpenHour then
            -- During Hours
            local pcoords = vector3(coords.x, coords.y, coords.z)
            local scoords = vector3(tonumber(bank.X), tonumber(bank.Y), tonumber(bank.Z))
            local sDistance = #(pcoords - scoords)

            -- Prompts
            if sDistance <= Config.PromptDistance then
              sleep = false
              local bankOpen = CreateVarString(10, 'LITERAL_STRING', bank.Name)
              PromptSetActiveGroupThisFrame(GetOpenPromptGroup(), bankOpen)

              if Citizen.InvokeNative(0xC92AC953F0A982AE, GetOpenPrompt()) then -- UiPromptHasStandardModeCompleted
                VORPcore.RpcCall('CheckBankerStatus', function(isBusy)
                  if isBusy then
                    VORPcore.NotifyRightTip("The banker is currently busy. Try again later.", 4000)
                  else
                    TriggerServerEvent("bcc-banking:setBankerBusy", bank.ID, true)
                    SendNUIMessage({
                      type = 'toggle',
                      visible = true
                    })
                  end
                end, bank.ID)
              end
            end

            -- Blip
            if Config.ShowBlips and not bank.BlipHandle then
              bank.BlipHandle = AddBlip(bank, true)
            end

            if sDistance <= Config.SpawnDistance then
              if Config.ShowNPC and not bank.NPC then
                bank.NPC = AddNPC(bank)
              end
            end
          end
        else
          -- Not Using Hours
          local pcoords = vector3(coords.x, coords.y, coords.z)
          local scoords = vector3(tonumber(bank.X), tonumber(bank.Y), tonumber(bank.Z))
          local sDistance = #(pcoords - scoords)

          -- Prompts
          if sDistance <= Config.PromptDistance then
            sleep = false
            local bankPrompt = CreateVarString(10, 'LITERAL_STRING', bank.Name)
            PromptSetActiveGroupThisFrame(GetOpenPromptGroup(), bankPrompt)
            if Citizen.InvokeNative(0xC92AC953F0A982AE, GetOpenPrompt()) then -- UiPromptHasStandardModeCompleted
              VORPcore.RpcCall('CheckBankerStatus', function(isBusy)
                if isBusy then
                  print('Banker is Busy!')
                else
                  TriggerServerEvent("bcc-banking:setBankerBusy", bank.ID, true)
                  SendNUIMessage({
                    type = 'toggle',
                    visible = true
                  })
                end
              end, bank.ID)
            end
          end


          -- Blip
          if Config.ShowBlips and not bank.BlipHandle then
            bank.BlipHandle = AddBlip(bank, true)
          end

          if sDistance <= Config.SpawnDistance then
            if Config.ShowNPC and not bank.NPC then
              bank.NPC = AddNPC(bank)
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
  ClearNPCs(Banks)
end)

RegisterNUICallback('updatestate', function(args, cb)
  print('State change received!', State)
  State = args.state
  SetNuiFocus(State, State)

  if not State then
    TriggerServerEvent("bcc-banking:setBankerBusy", 1, false)
  end
  cb('ok')
end)
