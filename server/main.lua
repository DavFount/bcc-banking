local VORPcore = {}
Banks = nil

TriggerEvent('getCore', function(core)
  VORPcore = core
end)

VORPcore.addRpcCallback('CheckBankerStatus', function(source, cb, bankId)
  local _source = source
  cb(Banks[bankId].status == true)
end)

VORPcore.addRpcCallback('createAccount', function(source, cb, args)
  local _source = source
  local character = VORPcore.getUser(_source).getUsedCharacter
  local charId = character.charIdentifier

  local accountName = args.accountName
  local bankId = args.bankId

  local accountCount = MySQL.query.await(
    "SELECT COUNT(*) FROM bcc_bank_accounts WHERE bcc_bank_accounts.OwnerID = ? AND bcc_bank_accounts.BankID = ?;",
    { charId, bankId });

  -- Access the count returned from the DB
  accountCount = accountCount[1]["COUNT(*)"]

  local newAccountData = nil
  if accountCount < Config.maxAccounts then
    newAccountData = MySQL.query.await(
      "INSERT INTO bcc_bank_accounts (Name, BankID, OwnerID) VALUES (?, ?, ?) RETURNING *;",
      { accountName, tonumber(bankId), charId })

    if newAccountData[1] then
      MySQL.query.await("INSERT INTO bcc_accounts_allowed_access (AccountID, CharID, level) VALUES (?, ?, ?)",
        { newAccountData[1]["ID"], charId, 1 })
    end
  end

  cb(newAccountData[1])
end)

VORPcore.addRpcCallback('GetUserBankData', function(source, cb, id)
  local _source = source
  local character = VORPcore.getUser(_source).getUsedCharacter
  local charId = character.charIdentifier

  local accountData = MySQL.query.await(
    'SELECT bcc_bank_accounts.ID, bcc_bank_accounts.Name, bcc_bank_accounts.OwnerID, bcc_bank_accounts.cash, bcc_bank_accounts.gold, bcc_bank_accounts.locked, bcc_accounts_allowed_access.level FROM bcc_bank_accounts INNER JOIN bcc_accounts_allowed_access ON bcc_bank_accounts.ID = bcc_accounts_allowed_access.AccountID INNER JOIN bcc_banks on bcc_banks.ID = bcc_bank_accounts.BankID WHERE bcc_bank_accounts.OwnerID = 1 AND bcc_banks.ID = 1;',
    { charId, id })

  cb(accountData, charId)
end)
