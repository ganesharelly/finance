class BudgetDetail < ActiveRecord::Base
  belongs_to :monthly_budget
  belongs_to :regular_payment
end
