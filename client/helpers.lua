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

function AddNPC(bank)
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
  local blip = N_0x554d9d53f696d002(1664425300, bank.X, bank.Y, bank.Z) -- BlipAddForCoords
  SetBlipSprite(bank.Blip, bank.blipSprite, 1)
  SetBlipScale(bank.Blip, 0.2)
  local bankName = bank.Name .. " Bank"
  Citizen.InvokeNative(0x9CB1A1623062F402, bank.Blip, bankName)
  if isOpen then
    Citizen.InvokeNative(0x662D364ABF16DE2F, blip, joaat(Config.BlipColors[Config.BlipColor['open']]))   -- BlipAddModifier
  else
    Citizen.InvokeNative(0x662D364ABF16DE2F, blip, joaat(Config.BlipColors[Config.BlipColor['closed']])) -- BlipAddModifier
  end
  return blip
end
