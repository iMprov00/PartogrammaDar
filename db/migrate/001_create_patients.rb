class CreatePatients < ActiveRecord::Migration[6.1]
  def change
    create_table :patients do |t|
      t.string :full_name, null: false
      t.date :date_of_birth, null: false
      t.integer :pregnancy_number
      t.integer :birth_number
      t.date :expected_delivery_date
      t.datetime :labor_start_time
      t.datetime :water_break_time
      t.string :status, default: 'роды не начались'
      t.datetime :last_measurement_time
      t.boolean :delivery_completed, default: false
      t.timestamps
    end
  end
end