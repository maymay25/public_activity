class CreateFollowedSubjects < ActiveRecord::Migration
  def change
    create_table :followed_subjects do |t|
      t.integer :uid
      t.integer :subject_id
      t.string :subject_title, limit: 80
      t.string :subject_identify, limit: 80

      t.timestamps
    end
    add_index :followed_subjects,:uid
    add_index :followed_subjects,:subject_id
  end
end
