walletServices = angular.module("myWalletServices", [])
walletServices.factory "MyWallet", ($window) ->
    myWallet = {}
    accounts = []
    accountsOnServer = [{label: "Savings", archived: false, balance: 2.0}]
    transactions = []
    transactionsOnServer = [{balance: 0.5, result: 0.5, hash: "aaaa", confirmations: 1, doubleSpend: false, coinbase: false, sender: "sender", receipient: "receipient", intraWallet: false, note: "Incoming", txTime: null}]
    monitorFunc = undefined  # New system
    eventListener = undefined # Old system
    
    mockRules = {shouldFailToSend: false}

    myWallet.restoreWallet = (password) ->
      this.refresh()
      return
      
    myWallet.setGUID = (uid) ->
      return
      
    myWallet.getLanguage = () ->
      return "en"
      
    myWallet.getAccounts = () ->
      return accounts
      
    myWallet.generateNewAccount = () ->
      accounts.push {label: "Mobile", archived: false, balance: 0}
      
    myWallet.getTransactions = () ->
      return transactions
      
    myWallet.parseTransaction = (tx) ->
      return tx
      
    myWallet.quickSendNoUI = (to, value, listener) ->
      if mockRules.shouldFailToSend
        listener.on_error({message: "Reason for failure"})
        return
        
      # A few sanity checks (not complete)
      if value > addresses[0].balance
        listener.on_error({message: "Insufficient funds"})
        return
      
      listener.on_start()
      listener.on_begin_signing()
      listener.on_sign_progress()
      listener.on_finish_signing()
      listener.on_before_send()
      
      addressesOnServer[0].balance = addressesOnServer[0].balance - value
      
      listener.on_success()
      
      return
      
    myWallet.addEventListener = (func) ->
      eventListener = func
      
    myWallet.monitor = (func) ->
      monitorFunc = func
      
    # Pending refactoring of MyWallet:
    $window.symbol_local = {code: "USD",conversion: 250000.0, local: true, name: "Dollar", symbol: "$", symbolAppearsAfter: false}
      
    ###################################
    # Fake methods useful for testing #
    ###################################
    
    myWallet.refresh = () ->
      angular.copy(accountsOnServer, accounts)
      angular.copy(transactionsOnServer, transactions)
      
      
    #####################################
    # Tell the mock to behave different # 
    #####################################
    myWallet.mockShouldFailToSend = () ->
      mockRules.shouldFailToSend = true
      
    myWallet.mockShouldReceiveNewTransaction = () ->
      transactions.push {balance: 1.0, result: 1.0, hash: "abcd", confirmations: 1, doubleSpend: false, coinbase: false, sender: "sender", receipient: "receipient", intraWallet: false, note: "Incoming", txTime: null}

      eventListener("on_tx")
      
    myWallet.mockShouldReceiveNewBlock = () ->
      eventListener("on_block")
    
    return myWallet 