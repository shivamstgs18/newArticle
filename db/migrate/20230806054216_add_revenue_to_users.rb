class AddRevenueToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :revenue, :decimal, precision: 10, scale: 2, default: 0
  end
end
