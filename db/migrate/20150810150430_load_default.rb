class LoadDefault < ActiveRecord::Migration

  def change
    create_table "stocks", force: :cascade do |t|
      t.datetime "created_at",           null: false
      t.datetime "updated_at",           null: false
      t.string   "symbol",               null: false
      t.integer  "user_id",              null: false
    end

    create_table "users", force: :cascade do |t|
      t.string   "name"
      t.string   "password_digest"
      t.datetime "created_at",      null: false
      t.datetime "updated_at",      null: false
    end

    create_table "groups", force: :cascade do |t|
      t.timestamps null: false
      t.string "name"
      t.string "admin_name"
    end

    add_foreign_key "stocks", "users"

  end

end
