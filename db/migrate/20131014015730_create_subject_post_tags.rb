class CreateSubjectPostTags < ActiveRecord::Migration
  def change
    create_table :subject_post_tags do |t|
      t.integer :subject_id
      t.integer :post_id
      t.string :tag, limit: 40

      t.timestamps
    end
    add_index :subject_post_tags, :subject_id
    add_index :subject_post_tags, :post_id
    add_index :subject_post_tags, :tag
  end
end
