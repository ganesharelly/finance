class Transaction < ActiveRecord::Base
  def self.init
    Transaction.delete_all()
    
    #main_dir = "C:/Users/Ganesh/Documents/v3 Documents/Banking/Nordea/"
    main_dir = "C:/Documents and Settings/Arelly/My Documents/Downloads/"
    Dir.chdir(main_dir)
    
    #Nordea
    nordea_statement_file_name =  "Transactions_FI3714783500227116_20110101_20111231.txt"
    parse_nordea_statement(nordea_statement_file_name)
    puts $nordea_raw_transactions.first.inspect
    save_nordea_transactions_to_db
  end
  
  def self.transactions
    @transactions
  end
  
  private
  #Nordea Helpers
  $nordea_raw_transactions = nil
  def self.parse_nordea_statement(stmt_name)
    $nordea_raw_transactions = Array.new()
    f = File.open(stmt_name, "r")  
    f.each_line do |line|
      s = line.split("\t") 
      $nordea_raw_transactions << s
    end
    puts $nordea_raw_transactions.length
    $nordea_raw_transactions = $nordea_raw_transactions.select{ |item| item.length > 2}
    $nordea_raw_transactions.slice!(0)
    puts $nordea_raw_transactions.length
  end
  
  def self.save_nordea_transactions_to_db
    puts 'in save_nordea_transactions_to_db'
    $nordea_raw_transactions.each do |t|
      if t.length > 1
        row = Transaction.new(nordea_change_tranasaction_format_to_suit_db_column t )
        row.save!
      end
    end
  end
  
  def self.nordea_debits
    nordea_debits_and_credits
  end
  
  def self.nordea_credits
    nordea_debits_and_credits(false)
  end
  
  def self.nordea_debits_or_credits(debits = true)
    begin
    @transactions = Array.new()
    $nordea_raw_transactions.each do |tx|
      amount = tx[3].to_f
      if debits ? amount <0 : amount > 0
        tx[3] =  tx[3].to_i.abs
        @transactions << tx
      end
    end
    rescue Exception => e
      puts e
    end  
  end
  
  def self.nordea_debits_and_credits
    begin
      @transactions = Array.new()
      $nordea_raw_transactions.each do |tx|
        @transactions << tx
      end
    rescue Exception => e
      puts e
    end  
    #Entrydate	Valuedate	Paymentdate	Amount	Beneficiary/Remitter	Accountnumber	
    #BIC	Transaction	Referencenumber	Originator'sreference	Message	Cardnumber	Receipt	
    #["02.08.2010", "02.08.2010", "02.08.2010", 51, "MATKAHUOLTO OY AB", "", 
    #"", "Visa Electron purch.", "100730001607", "", "JYVASKYLA ", "4920109013181100", "", "\n"]
  end
  
  
  def self.nordea_change_tranasaction_format_to_suit_db_column(h)
    categories = {:grocery => %w[K SIWA], 
      :clothes => %w[HENNES],
      :benifits => %w[KELA], :salary => %w[QVANTEL ARC],
      :medicines => %w[Apteekki]
      }
    rh = {}
    puts h.inspect
    rh[:dated] =  Date.strptime(h[0], "%d.%m.%y")
    rh[:benificiary] =  h[4]
    rh[:message] =  h[10]
    rh[:amount]  =  h[3].gsub(',', '.').to_f
    rh[:type] = h[3].to_i > 0 ? 'D' :  'C'
    categories.each do |key,value| 
      if value.include?(h[4])
        rh[:category] = key.to_s
        break
      end
    end
    rh[:account] = 'Nordea'
    #rh[:owner] =
    rh
  end
end
