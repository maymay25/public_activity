class CreateFavoritePosts < ActiveRecord::Migration
  def change
    create_table :favorite_posts do |t|
      t.integer :post_id
      t.string :post_title, limit: 80
      t.integer :subject_id
      t.string :subject_title, limit: 80
      t.string :subject_identify, limit: 80
      t.integer :uid
      t.string :nickname, limit: 80
      t.string :summary, limit: 600
      t.integer :content_type, default: 0
      t.string :embed_summary, limit: 999
      
      t.timestamps
    end
    add_index :favorite_posts,:uid
    add_index :favorite_posts,:post_id
  end
end
