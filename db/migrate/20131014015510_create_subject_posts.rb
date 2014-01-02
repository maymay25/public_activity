class CreateSubjectPosts < ActiveRecord::Migration
  def change
    create_table :subject_posts do |t|
      t.string :title, limit: 80
      t.text :content
      t.string :tags, default: ''
      t.string :summary, limit: 600
      t.integer :subject_id
      t.string :subject_title, limit: 80
      t.string :subject_identify, limit: 80
      t.string :cover_path
      t.integer :view_sum, default: 0
      t.integer :comment_sum, default: 0
      t.boolean :is_publish, default: false
      t.integer :content_type, default: 0
      t.string :embed_summary, limit: 999
      t.integer :favorite_sum, default: 0
      t.timestamps
    end
    add_index :subject_posts, :subject_identify
    add_index :subject_posts, :subject_id
  end
end
