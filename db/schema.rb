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

ActiveRecord::Schema[8.0].define(version: 2025_04_16_203053) do
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

  create_table "treatment_details", force: :cascade do |t|
    t.integer "status", default: 0
    t.bigint "medical_procedure_id", null: false
    t.bigint "doctor_id", null: false
    t.bigint "patient_id", null: false
    t.bigint "treatment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "medical_procedure_detail_id", null: false
    t.index ["doctor_id"], name: "index_treatment_details_on_doctor_id"
    t.index ["medical_procedure_detail_id"], name: "index_treatment_details_on_medical_procedure_detail_id"
    t.index ["medical_procedure_id"], name: "index_treatment_details_on_medical_procedure_id"
    t.index ["patient_id"], name: "index_treatment_details_on_patient_id"
    t.index ["treatment_id"], name: "index_treatment_details_on_treatment_id"
  end

  create_table "treatments", force: :cascade do |t|
    t.datetime "performed_at", null: false
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

  add_foreign_key "treatment_details", "doctors"
  add_foreign_key "treatment_details", "medical_procedure_details"
  add_foreign_key "treatment_details", "medical_procedures"
  add_foreign_key "treatment_details", "patients"
  add_foreign_key "treatment_details", "treatments"
end
