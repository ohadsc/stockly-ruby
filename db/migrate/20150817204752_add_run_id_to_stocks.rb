class AddRunIdToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :run_id, :integer
  end
end
