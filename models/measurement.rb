class Measurement < ActiveRecord::Base
  belongs_to :patient
  
  validates :patient_id, presence: true
  validates :measurement_time, presence: true
  
  before_create :set_measurement_time
  after_create :update_patient_timer
  
  private
  
  def set_measurement_time
    self.measurement_time ||= Time.now
  end
  
  def update_patient_timer
    # Если это первое измерение - начинаем роды
    if patient.measurements.count == 1
      patient.start_labor
    else
      # Иначе сбрасываем таймер
      patient.reset_timer
    end
  end
end