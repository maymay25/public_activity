class CreateFollowStatus < ActiveRecord::Migration
  def change
    create_table :follow_status do |t|
      t.integer :uid
      t.string :nickname, limit: 80
      t.integer :to_uid
      t.string :to_nickname, limit: 80

      t.timestamps
    end
    add_index :follow_status,:uid
    add_index :follow_status,:to_uid
  end
end
