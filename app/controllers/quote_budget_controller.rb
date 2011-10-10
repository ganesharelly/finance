class QuoteBudgetController < ApplicationController

   layout 'layouts/main'

  def budget_details
    render :template => 'quote_budget/budget_details' , :locals => {  :new_budget =>  true}
  end

  def edit_budget
      if  params[:monthly_budget_id]
      @budget_details = MonthlyBudget.find(params[:monthly_budget_id]).budget_details

    end
    render :template => 'quote_budget/budget_details', :locals => {  :new_budget => false}
  end

  def new_budget_detail
    if  params[:monthly_budget_id]
      @budget_details = MonthlyBudget.find(params[:monthly_budget_id]).budget_details
      @new_budget_detail = 'quote_budget/new_budget_detail' if params[:type] == 'new'
    end
    render :template => 'quote_budget/budget_details' , :locals => {  :new_budget =>  true}
  end

  def new_quote
    date =   params[:new_quote]["date(2i)"] + '-' +  params[:new_quote]["date(1i)"]
    b = MonthlyBudget.new({:month => date})
    b.save!
    redirect_to :action => 'new_budget_detail', :monthly_budget_id => b.id
  end

  def create_budget_detail
    bd = BudgetDetail.new({:amount => params[:budget_detail][:amount], :monthly_budget_id => params[:budget_detail][:monthly_budget_id],
                                              :comment => params[:budget_detail][:description]})
    begin
      bd.save
      redirect_to :action => 'new_budget_detail', :monthly_budget_id =>   params[:budget_detail][:monthly_budget_id]
    rescue e
      puts 'in rescue'
      #couldn't save bd, render failure info
    end
  end

  def edit_budget_detail
    @edit_id = params[:id]
    params[:monthly_budget_id] =  BudgetDetail.find(params[:id]).monthly_budget_id
    @budget_details = MonthlyBudget.find(params[:monthly_budget_id]).budget_details
    render :template => 'quote_budget/budget_details', :locals => {  :new_budget => false}
  end

   def update_budget_detail
    puts params.inspect
    bd = BudgetDetail.find(params[:id])
    begin
      bd.update_attributes!({:amount => params[:budget_detail][:amount],
                                              :comment => params[:budget_detail][:description]})
      redirect_to :action => 'new_budget_detail', :monthly_budget_id =>   BudgetDetail.find(params[:id]).monthly_budget_id
    rescue 
      puts 'in rescue'
      #couldn't save bd, render failure info
    end
  end
end
