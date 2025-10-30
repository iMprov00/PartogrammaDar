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

ActiveRecord::Schema[8.0].define(version: 2) do
  create_table "measurements", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "fetal_heart_rate"
    t.string "amniotic_fluid"
    t.string "head_configuration"
    t.decimal "cervix_dilation", precision: 3, scale: 1
    t.integer "head_position"
    t.integer "uterine_contractions"
    t.text "medications"
    t.string "oxytocin"
    t.string "iv_fluids"
    t.integer "pulse"
    t.integer "systolic_bp"
    t.integer "diastolic_bp"
    t.decimal "temperature", precision: 3, scale: 1
    t.string "urine"
    t.datetime "measurement_time", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_measurements_on_patient_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "full_name", null: false
    t.date "date_of_birth", null: false
    t.integer "pregnancy_number"
    t.integer "birth_number"
    t.date "expected_delivery_date"
    t.datetime "labor_start_time", precision: nil
    t.datetime "water_break_time", precision: nil
    t.string "status", default: "роды не начались"
    t.datetime "last_measurement_time", precision: nil
    t.boolean "delivery_completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
