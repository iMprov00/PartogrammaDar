class CreateMeasurements < ActiveRecord::Migration[6.1]
  def change
    create_table :measurements do |t|
      t.references :patient, null: false
      t.integer :fetal_heart_rate
      t.string :amniotic_fluid
      t.string :head_configuration
      t.decimal :cervix_dilation, precision: 3, scale: 1
      t.integer :head_position
      t.integer :uterine_contractions
      t.text :medications
      t.string :oxytocin
      t.string :iv_fluids
      t.integer :pulse
      t.integer :systolic_bp
      t.integer :diastolic_bp
      t.decimal :temperature, precision: 3, scale: 1
      t.string :urine
      t.datetime :measurement_time
      t.timestamps
    end
  end
end