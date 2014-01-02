class CreateSubjectTags < ActiveRecord::Migration
  def change
    create_table :subject_tags do |t|
      t.integer :subject_id
      t.string :tag, limit: 40
      t.integer :post_sum, default: 0

      t.timestamps
    end
    add_index :subject_tags, :subject_id
    add_index :subject_tags, :tag
  end
end
