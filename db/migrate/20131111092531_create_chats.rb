class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.integer :uid
      t.integer :to_uid
      t.string :content, limit: 999
      t.boolean :has_read, default: false
      t.boolean :is_in, default: false

      t.timestamps
    end
    add_index :chats,:uid
    add_index :chats,:to_uid
  end
end
