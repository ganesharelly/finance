class HdfcDebitTransactions < ActiveRecord::Base
  def self.init
    HdfcDebitTransactions.delete_all()

    file = File.new("/home/ganesh/Desktop/2010HDFCDebitTransactions", "r")
    #08/07/10 05141130000199-TPT-CITIEMI 6127A1 08/07/10 6,037.00 34,568.27
    while (line = file.gets)
      h = []
      if line
        comment = ''
        line.each(' ') do |s|
          if h.length > 0 and h.length < 3 #for 2nd , 3rd word
            if s.index('/') == 2  and s.rindex('/') == 5  #13/09/83
              #yes it is date
              h<< comment[1..comment.length-1]
              h<<s
            else
              comment = comment + ' ' + s.chop
            end
          else
            h<< s
          end
        end
      end
      #row = HdfcDebitTransactions.new(:transaction_date =>  Date.strptime(h[0], "%d/%m/%y"),
        #:comment => h[1] , :amount =>  h[3].gsub(',', '').to_i , :account_balance => h[4].gsub(',', '').to_i )
      row = HdfcDebitTransactions.new(process_hash h )
        row.save!
    end
  end

  def self.process_hash(h)
    rh = {}
    rh[:transaction_date] =  Date.strptime(h[0], "%d/%m/%y")
    rh[:comment] =  h[1]
    rh[:amount]  =  h[3].gsub(',', '').to_i
    rh[:account_balance] =  h[4].gsub(',', '').to_i
    last = HdfcDebitTransactions.last
     rh[:transaction_type]  =  last ?( last.account_balance.to_i > rh[:account_balance] ?   "Debit" : "Credit") : "N/A"
     rh
    #rh[:transfer_type] = check NEFT/CC/
  end

end
