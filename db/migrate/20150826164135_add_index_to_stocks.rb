class AddIndexToStocks < ActiveRecord::Migration
  def change
    add_index :stocks, :user_id
    add_index :stocks, :run_id
  end
end
