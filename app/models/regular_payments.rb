class RegularPayments < ActiveRecord::Base
  has_many :budget_details
end
