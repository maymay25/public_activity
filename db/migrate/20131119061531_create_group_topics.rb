class CreateGroupTopics < ActiveRecord::Migration
  def change
    create_table :group_topics do |t|
      t.string :title, limit: 80
      t.integer :uid
      t.string :summary, limit: 600
      t.text :content
      t.integer :group_id
      t.string :group_title, limit: 80
      t.string :group_name, limit: 80
      t.integer :favorite_sum, default: 0

      t.timestamps
    end
    add_index :group_topics,:group_id
    add_index :group_topics,:group_name
    add_index :group_topics,:uid
  end
end
