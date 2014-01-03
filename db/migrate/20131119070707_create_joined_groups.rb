class CreateJoinedGroups < ActiveRecord::Migration
  def change
    create_table :joined_groups do |t|
      t.integer :uid
      t.integer :group_id
      t.string :group_title, limit: 80
      t.string :group_name, limit: 80

      t.timestamps
    end
    add_index :joined_groups,:uid
    add_index :joined_groups,:group_id
  end
end
