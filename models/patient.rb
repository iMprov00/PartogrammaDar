class Patient < ActiveRecord::Base
  has_many :measurements, dependent: :destroy
  
  STATUSES = ['роды не начались', 'в родах', 'роды завершены']
  
  validates :full_name, presence: true
  validates :date_of_birth, presence: true
  validates :status, inclusion: { in: STATUSES }
  
  before_save :sync_status_with_delivery_completed
  after_save :log_patient_changes
  
  # Запуск таймера при первом измерении
  def start_labor
    return if labor_start_time.present?
    
    update(
      labor_start_time: Time.now,
      last_measurement_time: Time.now,
      status: 'в родах',
      delivery_completed: false
    )
  end
  
  # Сброс таймера при новом измерении
  def reset_timer
    return if delivery_completed?
    
    update(last_measurement_time: Time.now)
  end
  
  # Завершение родов
  def complete_delivery
    update(
      delivery_completed: true,
      status: 'роды завершены',
      last_measurement_time: nil
    )
  end
  
  def timer_status
    return 'completed' if delivery_completed?
    return 'not_started' if labor_start_time.nil? || last_measurement_time.nil?
    
    time_since_last_measurement = (Time.now - last_measurement_time).to_i
    
    if time_since_last_measurement > 1800 # 30 минут
      'danger'
    elsif time_since_last_measurement > 1500 # 25 минут
      'warning'
    else
      'normal'
    end
  end
  
  def minutes_since_last_measurement
    return nil if last_measurement_time.nil?
    ((Time.now - last_measurement_time) / 60).to_i
  end
  
  def seconds_since_last_measurement
    return nil if last_measurement_time.nil?
    (Time.now - last_measurement_time).to_i
  end
  
  def time_until_next_measurement
    return nil if last_measurement_time.nil?
    [1800 - (Time.now - last_measurement_time).to_i, 0].max
  end
  
  private
  
  def sync_status_with_delivery_completed
    puts "=== DEBUG: sync_status_with_delivery_completed called ==="
    puts "  Before changes:"
    puts "  - status: #{status}"
    puts "  - status_was: #{status_was}" if respond_to?(:status_was)
    puts "  - delivery_completed: #{delivery_completed}"
    puts "  - delivery_completed_was: #{delivery_completed_was}" if respond_to?(:delivery_completed_was)
    puts "  - labor_start_time: #{labor_start_time}"
    puts "  - last_measurement_time: #{last_measurement_time}"
    
    # Основная логика синхронизации
    if delivery_completed?
      puts "  - Setting status to 'роды завершены' because delivery_completed is true"
      self.status = 'роды завершены'
      self.last_measurement_time = nil
    elsif status == 'роды завершены' && !delivery_completed?
      puts "  - Setting status to 'в родах' because status was 'роды завершены' but delivery_completed is false"
      self.status = 'в родах'
    end
    
    # Устанавливаем labor_start_time, если статус "в родах" и время не установлено
    if status == 'в родах' && labor_start_time.nil?
      puts "  - Setting labor_start_time to now because status is 'в родах' and labor_start_time is nil"
      self.labor_start_time = Time.now
      self.last_measurement_time = Time.now if last_measurement_time.nil?
    end
    
    # Если статус "роды не начались", сбрасываем таймер
    if status == 'роды не начались'
      puts "  - Resetting timer because status is 'роды не начались'"
      self.labor_start_time = nil
      self.last_measurement_time = nil
      self.delivery_completed = false
    end
    
    puts "  After changes:"
    puts "  - status: #{status}"
    puts "  - delivery_completed: #{delivery_completed}"
    puts "  - labor_start_time: #{labor_start_time}"
    puts "  - last_measurement_time: #{last_measurement_time}"
    puts "=== DEBUG: sync_status_with_delivery_completed finished ==="
  end
  
  def log_patient_changes
    puts "=== DEBUG: Patient saved successfully ==="
    puts "  Final values:"
    puts "  - id: #{id}"
    puts "  - status: #{status}"
    puts "  - delivery_completed: #{delivery_completed}"
    puts "  - labor_start_time: #{labor_start_time}"
    puts "  - last_measurement_time: #{last_measurement_time}"
    puts "=== DEBUG: Patient save finished ==="
  end
end