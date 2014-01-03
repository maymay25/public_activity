# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 201308029173423) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "chats", force: true do |t|
    t.integer  "uid"
    t.integer  "to_uid"
    t.string   "content",    limit: 999
    t.boolean  "has_read",               default: false
    t.boolean  "is_in",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chats", ["to_uid"], name: "index_chats_on_to_uid", using: :btree
  add_index "chats", ["uid"], name: "index_chats_on_uid", using: :btree

  create_table "favorite_group_topics", force: true do |t|
    t.integer  "uid"
    t.integer  "topic_id"
    t.string   "topic_title",   limit: 80
    t.string   "topic_summary", limit: 600
    t.integer  "group_id"
    t.string   "group_name",    limit: 80
    t.string   "group_title",   limit: 80
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorite_group_topics", ["topic_id"], name: "index_favorite_group_topics_on_topic_id", using: :btree
  add_index "favorite_group_topics", ["uid"], name: "index_favorite_group_topics_on_uid", using: :btree

  create_table "favorite_posts", force: true do |t|
    t.integer  "post_id"
    t.string   "post_title",       limit: 80
    t.integer  "subject_id"
    t.string   "subject_title",    limit: 80
    t.string   "subject_identify", limit: 80
    t.integer  "uid"
    t.string   "nickname",         limit: 80
    t.string   "summary",          limit: 600
    t.integer  "content_type",                 default: 0
    t.string   "embed_summary",    limit: 999
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorite_posts", ["post_id"], name: "index_favorite_posts_on_post_id", using: :btree
  add_index "favorite_posts", ["uid"], name: "index_favorite_posts_on_uid", using: :btree

  create_table "follow_status", force: true do |t|
    t.integer  "uid"
    t.string   "nickname",    limit: 80
    t.integer  "to_uid"
    t.string   "to_nickname", limit: 80
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follow_status", ["to_uid"], name: "index_follow_status_on_to_uid", using: :btree
  add_index "follow_status", ["uid"], name: "index_follow_status_on_uid", using: :btree

  create_table "followed_subjects", force: true do |t|
    t.integer  "uid"
    t.integer  "subject_id"
    t.string   "subject_title",    limit: 80
    t.string   "subject_identify", limit: 80
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "followed_subjects", ["subject_id"], name: "index_followed_subjects_on_subject_id", using: :btree
  add_index "followed_subjects", ["uid"], name: "index_followed_subjects_on_uid", using: :btree

  create_table "group_topics", force: true do |t|
    t.string   "title",        limit: 80
    t.integer  "uid"
    t.string   "summary",      limit: 600
    t.text     "content"
    t.integer  "group_id"
    t.string   "group_title",  limit: 80
    t.string   "group_name",   limit: 80
    t.integer  "favorite_sum",             default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_topics", ["group_id"], name: "index_group_topics_on_group_id", using: :btree
  add_index "group_topics", ["group_name"], name: "index_group_topics_on_group_name", using: :btree
  add_index "group_topics", ["uid"], name: "index_group_topics_on_uid", using: :btree

  create_table "groups", force: true do |t|
    t.string   "title",      limit: 80
    t.string   "name",       limit: 80
    t.string   "intro",      limit: 999
    t.integer  "member_sum",             default: 0
    t.string   "cover_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["name"], name: "index_groups_on_name", using: :btree

  create_table "ip_tables", force: true do |t|
    t.integer "start_at",      limit: 8
    t.integer "end_at",        limit: 8
    t.string  "province_name"
    t.string  "city_name"
  end

  create_table "joined_groups", force: true do |t|
    t.integer  "uid"
    t.integer  "group_id"
    t.string   "group_title", limit: 80
    t.string   "group_name",  limit: 80
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "joined_groups", ["group_id"], name: "index_joined_groups_on_group_id", using: :btree
  add_index "joined_groups", ["uid"], name: "index_joined_groups_on_uid", using: :btree

  create_table "linkmen", force: true do |t|
    t.integer  "uid"
    t.integer  "to_uid"
    t.integer  "no_read_count",                 default: 0
    t.datetime "last_chat_at"
    t.string   "last_chat_content", limit: 999
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "linkmen", ["uid"], name: "index_linkmen_on_uid", using: :btree

  create_table "subject_activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subject_activities", ["owner_id", "owner_type"], name: "index_subject_activities_on_owner_id_and_owner_type", using: :btree
  add_index "subject_activities", ["recipient_id", "recipient_type"], name: "index_subject_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "subject_activities", ["trackable_id", "trackable_type"], name: "index_subject_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "subject_post_comments", force: true do |t|
    t.integer  "post_id"
    t.string   "post_title",       limit: 80
    t.integer  "uid"
    t.string   "nickname",         limit: 80
    t.integer  "subject_id"
    t.string   "subject_title",    limit: 80
    t.string   "subject_identify", limit: 80
    t.string   "content",          limit: 999
    t.boolean  "is_verify",                    default: false
    t.integer  "is_public",                    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subject_post_comments", ["subject_id"], name: "index_subject_post_comments_on_subject_id", using: :btree
  add_index "subject_post_comments", ["uid"], name: "index_subject_post_comments_on_uid", using: :btree

  create_table "subject_post_tags", force: true do |t|
    t.integer  "subject_id"
    t.integer  "post_id"
    t.string   "tag",        limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subject_post_tags", ["post_id"], name: "index_subject_post_tags_on_post_id", using: :btree
  add_index "subject_post_tags", ["subject_id"], name: "index_subject_post_tags_on_subject_id", using: :btree
  add_index "subject_post_tags", ["tag"], name: "index_subject_post_tags_on_tag", using: :btree

  create_table "subject_posts", force: true do |t|
    t.string   "title",            limit: 80
    t.text     "content"
    t.string   "tags",                         default: ""
    t.string   "summary",          limit: 600
    t.integer  "subject_id"
    t.string   "subject_title",    limit: 80
    t.string   "subject_identify", limit: 80
    t.string   "cover_path"
    t.integer  "view_sum",                     default: 0
    t.integer  "comment_sum",                  default: 0
    t.boolean  "is_publish",                   default: false
    t.integer  "content_type",                 default: 0
    t.string   "embed_summary",    limit: 999
    t.integer  "favorite_sum",                 default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subject_posts", ["subject_id"], name: "index_subject_posts_on_subject_id", using: :btree
  add_index "subject_posts", ["subject_identify"], name: "index_subject_posts_on_subject_identify", using: :btree

  create_table "subject_tags", force: true do |t|
    t.integer  "subject_id"
    t.string   "tag",        limit: 40
    t.integer  "post_sum",              default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subject_tags", ["subject_id"], name: "index_subject_tags_on_subject_id", using: :btree
  add_index "subject_tags", ["tag"], name: "index_subject_tags_on_tag", using: :btree

  create_table "subjects", force: true do |t|
    t.string   "title",      limit: 80
    t.string   "identify",                          null: false
    t.integer  "post_sum",              default: 0
    t.integer  "tag_sum",               default: 0
    t.string   "intro"
    t.string   "cover_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subjects", ["identify"], name: "index_subjects_on_identify", using: :btree

  create_table "users", force: true do |t|
    t.string   "nickname"
    t.string   "email"
    t.string   "avatar_path"
    t.string   "username"
    t.string   "encrypted_password",                default: ""
    t.string   "status"
    t.string   "slug"
    t.datetime "picked_at"
    t.boolean  "is_eraser",                         default: false
    t.integer  "gender",                            default: 0
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0
    t.datetime "last_sign_in_at"
    t.string   "last_sign_in_ip"
    t.integer  "come_from"
    t.string   "come_id",                limit: 32
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["come_from"], name: "index_users_on_come_from", using: :btree
  add_index "users", ["come_id"], name: "index_users_on_come_id", using: :btree

end
