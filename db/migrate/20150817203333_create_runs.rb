class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.references :group, index: true, foreign_key: true
      t.timestamps null: false
      t.datetime :started_at, null: true
      t.datetime :ended_at, null: true
      t.integer :status, default: 0
      t.float :duration, null: false
      t.string :name, null: false
    end
  end
end
