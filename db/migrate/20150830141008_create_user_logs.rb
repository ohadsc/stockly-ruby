class CreateUserLogs < ActiveRecord::Migration
  def change
    create_table :user_logs do |t|
      t.integer :user_id, index: true
      t.string :remote_addr
      t.string :session_id
      t.integer :status
      t.string :method
      t.string :controller
      t.string :action
      t.string :domain
      t.string :request_uri
      t.string :url
      t.string :protocol
      t.string :format
      t.string :host
      t.string :port
      t.text :user_params, limit: 1048576
      t.text :user_session
      t.string :query_string
      t.string :http_accept
      t.boolean :ssl
      t.boolean :xhr
      t.string :referer
      t.string :http_user_agent
      t.string :server_software
      t.string :content_type
      t.timestamps null: false
    end
  end
end