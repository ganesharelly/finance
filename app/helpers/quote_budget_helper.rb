module QuoteBudgetHelper
  
  def pretty_budget_month id
    months 	= 	%w(January February March April May June July August September October November December)
     months[MonthlyBudget.find(id).month[0..1].to_i-1].to_s + '\'' +
       MonthlyBudget.find(id).month[3..6].to_s
  end
end
