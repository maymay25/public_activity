class CreateFavoriteGroupTopics < ActiveRecord::Migration
  def change
    create_table :favorite_group_topics do |t|
      t.integer :uid
      t.integer :topic_id
      t.string :topic_title, limit: 80
      t.string :topic_summary, limit: 600
      t.integer :group_id
      t.string :group_name, limit: 80
      t.string :group_title, limit: 80

      t.timestamps
    end
    add_index :favorite_group_topics,:topic_id
    add_index :favorite_group_topics,:uid
  end
end
