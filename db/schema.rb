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

ActiveRecord::Schema.define(version: 0) do

  create_table "categories", force: :cascade do |t|
    t.integer "recipe_id"
    t.integer "tag_id"
  end

  add_index "categories", ["recipe_id"], name: "index_categories_on_recipe_id"
  add_index "categories", ["tag_id"], name: "index_categories_on_tag_id"

  create_table "recipes", force: :cascade do |t|
    t.string   "title"
    t.string   "photo_url"
    t.string   "instruction"
    t.datetime "date"
    t.integer  "stars"
  end

  create_table "reviews", force: :cascade do |t|
    t.string   "title"
    t.text     "comment"
    t.integer  "rating"
    t.datetime "date"
    t.integer  "recipe_id"
  end

  add_index "reviews", ["recipe_id"], name: "index_reviews_on_recipe_id"

  create_table "tags", force: :cascade do |t|
    t.string "name"
  end

end