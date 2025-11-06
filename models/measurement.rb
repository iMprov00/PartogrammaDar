class Measurement < ActiveRecord::Base
  belongs_to :patient
  
  validates :patient_id, presence: true
  validates :measurement_time, presence: true  # Включаем обратно валидацию
  
  # УБИРАЕМ колбэк before_create который устанавливает время
  # before_create :set_measurement_time
  
  after_create :update_patient_timer
  
  private
  
  # Убираем этот метод
  # def set_measurement_time
  #   self.measurement_time ||= Time.now
  # end
  
  def update_patient_timer
    if patient.measurements.count == 1
      patient.start_labor
    else
      patient.reset_timer
    end
  end
end