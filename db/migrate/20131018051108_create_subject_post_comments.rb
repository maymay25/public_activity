class CreateSubjectPostComments < ActiveRecord::Migration
  def change
    create_table :subject_post_comments do |t|
      t.integer :post_id
      t.string :post_title, limit: 80
      t.integer :uid
      t.string :nickname, limit: 80
      t.integer :subject_id
      t.string :subject_title, limit: 80
      t.string :subject_identify, limit: 80
      t.string :content, limit: 999
      t.boolean :is_verify, default: false
      t.integer :is_public, default: 0

      t.timestamps
    end
    add_index :subject_post_comments,:uid
    add_index :subject_post_comments,:subject_id
  end
end
