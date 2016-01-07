class AddStartPriceAndEndPriceToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :start_price, :float
    add_column :stocks, :end_price, :float
  end
end
