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

ActiveRecord::Schema.define(version: 20171124084529) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "publisher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publisher_id"], name: "index_books_on_publisher_id"
  end

  create_table "publisher_shops", force: :cascade do |t|
    t.bigint "publisher_id"
    t.bigint "shop_id"
    t.integer "books_sold_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["books_sold_count"], name: "index_publisher_shops_on_books_sold_count"
    t.index ["publisher_id", "shop_id"], name: "index_publisher_shops_on_publisher_id_and_shop_id", unique: true
    t.index ["publisher_id"], name: "index_publisher_shops_on_publisher_id"
    t.index ["shop_id"], name: "index_publisher_shops_on_shop_id"
  end

  create_table "publishers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shop_books", force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "book_id"
    t.integer "copies_in_stock", default: 0, null: false
    t.integer "copies_sold", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_shop_books_on_book_id"
    t.index ["copies_in_stock"], name: "index_shop_books_on_copies_in_stock"
    t.index ["shop_id", "book_id"], name: "index_shop_books_on_shop_id_and_book_id", unique: true
    t.index ["shop_id"], name: "index_shop_books_on_shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "books", "publishers"
  add_foreign_key "publisher_shops", "publishers"
  add_foreign_key "publisher_shops", "shops"
  add_foreign_key "shop_books", "books"
  add_foreign_key "shop_books", "shops"
end
