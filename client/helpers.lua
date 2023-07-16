function LoadModel(model)
  RequestModel(model)
  while not HasModelLoaded(model) do
    RequestModel(model)
    Wait(100)
  end
end

function ClearBlips(banks)
  for _, v in pairs(banks) do
    if v.BlipHandle then
      RemoveBlip(v.BlipHandle)
      v.BlipHandle = nil
    end
  end
end

function ClearNPCs(banks)
  for _, v in pairs(banks) do
    if v.NPC then
      DeleteEntity(v.NPC)
      v.NPC = nil
    end
  end
end

function AddNPC(bank)
  print('Add NPC Called')
  local model = joaat(Config.NPCModel)
  LoadModel(model)
  local npc = CreatePed(Config.NPCModel, tonumber(bank.X), tonumber(bank.Y), tonumber(bank.Z) - 1, tonumber(bank.H),
    false, true, true, true)
  Citizen.InvokeNative(0x283978A15512B2FE, npc, true) -- SetRandomOutfitVariation
  SetEntityCanBeDamaged(npc, false)
  SetEntityInvincible(npc, true)
  Wait(500)
  FreezeEntityPosition(npc, true)
  SetBlockingOfNonTemporaryEvents(npc, true)
  return npc
end

function AddBlip(bank, isOpen)
  local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, tonumber(bank.X), tonumber(bank.Y), tonumber(bank.Z)) -- BlipAddForCoords
  SetBlipSprite(blip, bank.Blip, 1)
  SetBlipScale(blip, 0.2)
  local bankName = bank.Name .. " Bank"
  Citizen.InvokeNative(0x9CB1A1623062F402, blip, bankName)
  if isOpen then
    Citizen.InvokeNative(0x662D364ABF16DE2F, blip, joaat(Config.BlipColors[Config.BlipColor['open']]))   -- BlipAddModifier
  else
    Citizen.InvokeNative(0x662D364ABF16DE2F, blip, joaat(Config.BlipColors[Config.BlipColor['closed']])) -- BlipAddModifier
  end
  return blip
end
