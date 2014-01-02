class CreateLinkmen < ActiveRecord::Migration
  def change
    create_table :linkmen do |t|
      t.integer :uid
      t.integer :to_uid
      t.integer :no_read_count, default: 0
      t.datetime :last_chat_at
      t.string :last_chat_content, limit: 999

      t.timestamps
    end
    add_index :linkmen,:uid
  end
end
