local State = false

-- Nui Messages
function OpenUI(bank, accountData, charId)
  SendNUIMessage({
    type = 'toggle',
    visible = true,
    bank = bank,
    accountData = accountData,
    charId = charId
  })
end

-- Nui Callbacks
RegisterNUICallback('updatestate', function(args, cb)
  State = args.state
  SetNuiFocus(State, State)

  if not State then
    TriggerServerEvent("bcc-banking:setBankerBusy", 1, false)
  end
  cb('ok')
end)

RegisterNUICallback('createAccount', function(args, cb)
  cb('ok')

  VORPcore.RpcCall('createAccount', function(newAccount)
    SendNUIMessage({
      type = 'addAccount',
      accountData = newAccount
    })
  end, args)
end)
