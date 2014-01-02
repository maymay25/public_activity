class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :nickname
      t.string :email
      t.string :avatar_path
      t.string :username
      t.string :encrypted_password, default: ""
      t.string :status
      t.string :slug
      t.datetime :picked_at
      t.boolean :is_eraser, default: false
      t.integer :gender, default: 0

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0
      t.datetime :last_sign_in_at
      t.string   :last_sign_in_ip
      t.integer  :come_from
      t.column :come_id, 'VARCHAR(32)'

      t.timestamps
    end
    add_index :users, :come_id
    add_index :users, :come_from
  end
end
