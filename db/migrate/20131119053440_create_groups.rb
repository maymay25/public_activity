class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :title, limit: 80
      t.string :name, limit: 80
      t.string :intro, limit: 999
      t.integer :member_sum, default: 0
      t.string :cover_path

      t.timestamps
    end
    add_index :groups,:name
  end
end
