class MainController < ApplicationController
   layout 'layouts/main'

  def index
  end

  def filetodb
    #HdfcDebitTransactions.init
    #render some error page if there are some..
    Transaction.init
  end

  def transactions
    @transactions = Transaction.find :all
    render :template => "main/transactions"
  end

  def search_transactions
    puts params.inspect
    date = Date.new()
    @transactions = HdfcDebitTransactions.find :all
    @transactions  = @transactions .select do|t|
      t.comment.to_s =~ Regexp.new(params[:comment], Regexp::IGNORECASE) and 
        #date_match(params[:transaction], t.transaction_date) and
        params[:type].eql?("any") ?  true : params[:type].eql?(t.transaction_type.downcase) 
        #and amount_match( params[:amount_condition],  params[:amount], t.amount)
    end
    render :template => "main/transactions"
  end

  def budget
    @budgets = MonthlyBudget.find :all
  end

  private

  def date_match(params_date , t_date)
    (params_date["done_on(1i)"].empty? ? true : ( t_date.year ==  params_date["done_on(1i)"].to_i) ) and
    (params_date["done_on(2i)"].empty? ? true : ( t_date.month ==  params_date["done_on(2i)"].to_i)) and
    params_date["done_on(3i)"].empty? ? true : ( t_date.day ==  params_date["done_on(3i)"].to_i)
  end

  def amount_match(condition, amount, t_amount)
        if  condition.eql?("Any")
          true
        else
           if condition.eql?("equal")
                amount ? t_amount.to_i == amount.to_i : false
           elsif condition.eql?("gt")
                amount ? t_amount.to_i > amount.to_i : false
            elsif condition.eql?("lt")
                amount ? t_amount.to_i < amount.to_i : false
           else
             true
           end
        end
  end

  
  
end
