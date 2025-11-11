# models/measurement.rb
class Measurement < ActiveRecord::Base
  belongs_to :patient
  
  validates :patient_id, presence: true
  validates :measurement_time, presence: true
  
  after_create :update_patient_timer
  
  # Поля с предопределенными значениями
  COMPANION_OPTIONS = ['Да', 'Нет', 'Отказ']
  PAIN_RELIEF_OPTIONS = ['Да', 'Нет', 'Отказ']
  ORAL_FLUIDS_OPTIONS = ['Да', 'Нет', 'Отказ']
  POSITION_OPTIONS = ['На спине', 'Мобильна']
  
  FETAL_DECELERATION_OPTIONS = ['Нет', 'Ранние', 'Поздние', 'Вариабельные']
  AMNIOTIC_FLUID_OPTIONS = ['Целые', 'Светлая', 'Меконий +', 'Меконий ++', 'Меконий +++', 'Кровь']
  FETAL_POSITION_OPTIONS = ['Передний вид', 'Задний вид', 'Поперечное']
  CAPUT_SUC_OPTIONS = ['0', '+', '++', '+++']
  
  URINE_PROTEIN_OPTIONS = ['-', 'след', '1+', '2+', '3+']
  URINE_ACETONE_OPTIONS = ['-', '1+', '2+', '3+', '4+']
  
  OXYTOCIN_OPTIONS = ['Нет', 'Да']
  IV_FLUIDS_OPTIONS = ['Да', 'Нет']
  
  private
  
  def update_patient_timer
    if patient.measurements.count == 1
      patient.start_labor
    else
      patient.reset_timer
    end
  end
end