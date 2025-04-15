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

ActiveRecord::Schema[8.0].define(version: 2025_04_15_034008) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "doctors", force: :cascade do |t|
    t.string "name", null: false
    t.string "document_number", null: false
    t.integer "crm", null: false
    t.string "crm_location", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_number"], name: "unique_doctor_documents", unique: true
  end

  create_table "medical_procedure_details", force: :cascade do |t|
    t.decimal "price", precision: 10, scale: 2
    t.bigint "medical_procedure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medical_procedure_id"], name: "index_medical_procedure_details_on_medical_procedure_id"
  end

  create_table "medical_procedures", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patients", force: :cascade do |t|
    t.string "name", limit: 510, null: false
    t.string "document_number", limit: 510, null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
