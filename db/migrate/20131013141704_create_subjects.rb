class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :title, limit: 80
      t.string :identify, null: false
      t.integer :post_sum, default: 0
      t.integer :tag_sum, default: 0
      t.string :intro
      t.string :cover_path

      t.timestamps
    end
    add_index :subjects, :identify
  end
end
