RegisterServerEvent("bcc-banking:getBanks", function()
  local _source = source
  if Banks == nil then
    Banks = MySQL.query.await("SELECT * FROM bcc_banks;")
  end


  TriggerClientEvent('bcc-banking:returnBanks', _source, Banks)
end)
