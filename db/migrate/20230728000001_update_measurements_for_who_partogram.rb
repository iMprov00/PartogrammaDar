# db/migrate/20230728000001_update_measurements_for_who_partogram.rb
class UpdateMeasurementsForWhoPartogram < ActiveRecord::Migration[6.1]
  def change
    # Раздел 2. Поддерживающий уход
    add_column :measurements, :companion_present, :string
    add_column :measurements, :pain_relief, :string
    add_column :measurements, :oral_fluids, :string
    add_column :measurements, :position, :string
    
    # Раздел 3. Оказание помощи ребенку
    add_column :measurements, :fetal_heart_deceleration, :string
    add_column :measurements, :fetal_position, :string
    add_column :measurements, :caput_suc, :string
    
    # Раздел 4. Оказание помощи матери
    add_column :measurements, :urine_protein, :string
    add_column :measurements, :urine_acetone, :string
    
    # Раздел 5. Ход родов
    add_column :measurements, :contractions_duration, :integer
    
    # Раздел 6. Введение лекарственных средств
    add_column :measurements, :oxytocin_dosage, :string
    add_column :measurements, :other_medications, :string  # ← ЗДЕСЬ ИСПРАВЛЕНО
    
    # Раздел 7. Совместное принятие решений
    add_column :measurements, :assessment, :text
    add_column :measurements, :plan, :text
  end
end