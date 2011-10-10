class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.string :benificiary
      t.string :message
      t.float :amount
      t.date :dated
      t.integer :id
      t.string :account
      t.string :type
      t.string :category

      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
