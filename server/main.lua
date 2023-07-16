local VORPcore = {}
Banks = nil

TriggerEvent('getCore', function(core)
  VORPcore = core
end)

VORPcore.addRpcCallback('CheckBankerStatus', function(source, cb, id)
  local _source = source
  cb(Banks[id].status == true)
end)
