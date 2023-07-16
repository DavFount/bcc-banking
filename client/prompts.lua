local OpenBanks
local CloseBanks
local BusyBanker
local OpenGroup = GetRandomIntInRange(0, 0xffffff)
local ClosedGroup = GetRandomIntInRange(0, 0xffffff)
local BankerBusyGroup = GetRandomIntInRange(0, 0xffffff)

function GetOpenPromptGroup()
  return OpenGroup
end

function GetOpenPrompt()
  return OpenBanks
end

function GetClosedPromptGroup()
  return ClosedGroup
end

function GetClosedPrompt()
  return CloseBanks
end

function GetBusyPromptGroup()
  return BankerBusyGroup
end

function GetBusyPrompt()
  return BusyBanker
end

function BankOpen()
  local str = _U('shopPrompt')
  OpenBanks = PromptRegisterBegin()
  PromptSetControlAction(OpenBanks, Config.key)
  str = CreateVarString(10, 'LITERAL_STRING', str)
  PromptSetText(OpenBanks, str)
  PromptSetEnabled(OpenBanks, 1)
  PromptSetVisible(OpenBanks, 1)
  PromptSetStandardMode(OpenBanks, 1)
  PromptSetGroup(OpenBanks, OpenGroup)
  PromptRegisterEnd(OpenBanks)
end

function BankClosed()
  local str = _U('shopPrompt')
  CloseBanks = PromptRegisterBegin()
  PromptSetControlAction(CloseBanks, Config.key)
  str = CreateVarString(10, 'LITERAL_STRING', str)
  PromptSetText(CloseBanks, str)
  PromptSetEnabled(CloseBanks, 1)
  PromptSetVisible(CloseBanks, 1)
  PromptSetStandardMode(CloseBanks, 1)
  PromptSetGroup(CloseBanks, ClosedGroup)
  PromptRegisterEnd(CloseBanks)
end

function BankerBusy()
  local str = _U('shopPrompt')
  BusyBanker = PromptRegisterBegin()
  PromptSetControlAction(BusyBanker, Config.key)
  str = CreateVarString(10, 'LITERAL_STRING', str)
  PromptSetText(BusyBanker, str)
  PromptSetEnabled(BusyBanker, 1)
  PromptSetVisible(BusyBanker, 1)
  PromptSetStandardMode(BusyBanker, 1)
  PromptSetGroup(BusyBanker, BusyBanker)
  PromptRegisterEnd(BusyBanker)
end

function DeletePrompts()
  PromptDelete(OpenBanks)
  PromptDelete(CloseBanks)
end
