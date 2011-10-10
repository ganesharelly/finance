class MonthlyBudget < ActiveRecord::Base
  has_many :budget_details
end
