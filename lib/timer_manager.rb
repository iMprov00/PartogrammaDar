class TimerManager
  def self.check_expired_timers
    patients_in_labor = Patient.where(status: 'в родах', delivery_completed: false)
    
    expired_patients = patients_in_labor.select do |patient|
      patient.timer_status == 'danger'
    end
    
    # Здесь можно добавить отправку уведомлений
    if expired_patients.any?
      puts "ВНИМАНИЕ! Следующие пациентки требуют срочного измерения:"
      expired_patients.each do |patient|
        minutes = patient.minutes_since_last_measurement
        puts " - #{patient.full_name}: #{minutes} минут с последнего измерения"
      end
    end
    
    expired_patients
  end
end