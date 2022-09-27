# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_09_27_065341) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "branch_id"
    t.string "accountable_type", null: false
    t.bigint "accountable_id", null: false
    t.decimal "balance", precision: 12, scale: 2, default: "0.0"
    t.date "open_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["accountable_type", "accountable_id"], name: "index_accounts_on_accountable"
    t.index ["branch_id"], name: "index_accounts_on_branch_id"
  end

  create_table "branches", force: :cascade do |t|
    t.string "name", limit: 64
    t.string "city", limit: 64
    t.decimal "assets", precision: 12, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "check_accounts", force: :cascade do |t|
    t.decimal "withdraw_amount", precision: 12, scale: 2, default: "0.0"
  end

  create_table "clients", force: :cascade do |t|
    t.string "person_id", limit: 18, null: false
    t.string "name", limit: 64
    t.string "phone", limit: 64
    t.string "address", limit: 256
    t.bigint "manager_id"
    t.integer "manager_type", limit: 2, default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_clients_on_manager_id"
  end

  create_table "clients_loans", force: :cascade do |t|
    t.bigint "loan_id"
    t.bigint "client_id"
    t.index ["client_id"], name: "index_clients_loans_on_client_id"
    t.index ["loan_id"], name: "index_clients_loans_on_loan_id"
  end

  create_table "contacts", primary_key: "client_id", force: :cascade do |t|
    t.string "name", limit: 64
    t.string "phone", limit: 64
    t.string "email", limit: 64, comment: "Email"
    t.string "relationship", limit: 64
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_contacts_on_client_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name", limit: 64
    t.string "kind", limit: 64
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deposit_accounts", force: :cascade do |t|
    t.float "interest_rate", default: 1.0
    t.string "currency", limit: 3, default: "BTC"
  end

  create_table "issues", force: :cascade do |t|
    t.bigint "loan_id"
    t.date "date"
    t.decimal "amount", precision: 12, scale: 2, default: "0.0"
    t.index ["loan_id"], name: "index_issues_on_loan_id"
  end

  create_table "loans", force: :cascade do |t|
    t.decimal "amount", precision: 12, scale: 2, default: "0.0"
    t.bigint "branch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_loans_on_branch_id"
  end

  create_table "ownerships", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "client_id"
    t.bigint "branch_id"
    t.string "accountable_type"
    t.datetime "last_access", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_ownerships_on_account_id"
    t.index ["branch_id", "accountable_type", "client_id"], name: "my_index", unique: true
    t.index ["branch_id"], name: "index_ownerships_on_branch_id"
    t.index ["client_id"], name: "index_ownerships_on_client_id"
  end

  create_table "staffs", force: :cascade do |t|
    t.string "person_id", limit: 18, null: false
    t.string "name", limit: 64
    t.string "phone", limit: 64
    t.string "address", limit: 256
    t.date "start_date"
    t.boolean "manager", default: false
    t.bigint "branch_id"
    t.bigint "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_staffs_on_branch_id"
    t.index ["department_id"], name: "index_staffs_on_department_id"
  end

  add_foreign_key "accounts", "branches", on_delete: :restrict
  add_foreign_key "clients", "staffs", column: "manager_id", on_delete: :restrict
  add_foreign_key "clients_loans", "clients", on_delete: :restrict
  add_foreign_key "clients_loans", "loans", on_delete: :cascade
  add_foreign_key "contacts", "clients", on_delete: :cascade
  add_foreign_key "issues", "loans", on_delete: :cascade
  add_foreign_key "loans", "branches", on_delete: :restrict
  add_foreign_key "ownerships", "accounts", on_delete: :cascade
  add_foreign_key "ownerships", "branches", on_delete: :restrict
  add_foreign_key "ownerships", "clients", on_delete: :restrict
  add_foreign_key "staffs", "branches", on_delete: :restrict
  add_foreign_key "staffs", "departments", on_delete: :restrict
end
