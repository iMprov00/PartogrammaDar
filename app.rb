require 'sinatra'
require 'sinatra/activerecord'
require './config/environment'
require './lib/timer_manager'


  enable :sessions
  
  get '/' do
    erb :index
  end
  
  get '/patients' do

    @patients = Patient.all
    @status_filter = params[:status]
    @search_query = params[:search]
    
    if @status_filter && !@status_filter.empty?
      @patients = @patients.where(status: @status_filter)
    end
    
    if @search_query && !@search_query.empty?
      @patients = @patients.where("full_name LIKE ?", "%#{@search_query}%")
    end
    
    @patients = @patients.order(created_at: :desc)
    erb :patients
  end
  
  get '/patients/new' do
    @patient = Patient.new
    erb :new_patient
  end
  
  post '/patients' do
    @patient = Patient.new(params[:patient])
    
    if @patient.save
      redirect '/patients'
    else
      erb :new_patient
    end
  end
  
  get '/patients/:id/partogram' do
    @patient = Patient.find(params[:id])
    @measurements = @patient.measurements.order(measurement_time: :asc)
    @measurement = Measurement.new
    erb :partogram
  end
  
# app.rb (обновленный метод для обработки измерений)
# app.rb

post '/patients/:id/measurements' do
  @patient = Patient.find(params[:id])
  
  # 1. Создаем копию параметров, чтобы не изменять оригинальный хэш
  measurement_params = params[:measurement].dup
  
  # 2. Обрабатываем поля с пользовательскими значениями
  # Если поле ..._custom заполнено, используем его значение вместо стандартного
  %w[companion_present pain_relief oral_fluids position fetal_heart_deceleration amniotic_fluid fetal_position caput_suc head_configuration urine_protein urine_acetone].each do |field|
    custom_key = "#{field}_custom"
    if measurement_params[custom_key] && !measurement_params[custom_key].empty?
      measurement_params[field] = measurement_params[custom_key]
    end
    # Удаляем лишний параметр, чтобы ActiveRecord не пытался его присвоить
    measurement_params.delete(custom_key)
  end
  
  # 3. Создаем объект с уже "очищенными" параметрами
  @measurement = @patient.measurements.new(measurement_params)
  
  if @measurement.save
    redirect "/patients/#{params[:id]}/partogram"
  else
    @measurements = @patient.measurements.order(measurement_time: :asc)
    erb :partogram
  end
end

post '/patients/:id/complete_delivery' do
  @patient = Patient.find(params[:id])
  @patient.complete_delivery
  redirect "/patients/#{params[:id]}/partogram"
end

# Новый endpoint для получения состояния таймера в реальном времени
get '/timer/status/:patient_id' do
  content_type :json
  patient = Patient.find(params[:patient_id])
  
  {
    status: patient.timer_status,
    minutes: patient.minutes_since_last_measurement,
    seconds: patient.seconds_since_last_measurement,
    time_until_next: patient.time_until_next_measurement,
    delivery_completed: patient.delivery_completed,
    labor_started: patient.labor_start_time.present?
  }.to_json
end

get '/patients/:id/edit' do
  @patient = Patient.find(params[:id])
  erb :edit_patient
end

put '/patients/:id' do
  @patient = Patient.find(params[:id])
  
  puts "=== DEBUG: Patient update started ==="
  puts "Params received: #{params[:patient].inspect}"
  puts "Current patient state:"
  puts "  - status: #{@patient.status}"
  puts "  - delivery_completed: #{@patient.delivery_completed}"
  
  if @patient.update(params[:patient])
    puts "=== DEBUG: Patient update successful ==="
    puts "New patient state:"
    puts "  - status: #{@patient.status}"
    puts "  - delivery_completed: #{@patient.delivery_completed}"
    redirect '/patients'
  else
    puts "=== DEBUG: Patient update failed ==="
    puts "Errors: #{@patient.errors.full_messages}"
    erb :edit_patient
  end
end

# Добавьте также маршрут для удаления пациента
delete '/patients/:id' do
  patient = Patient.find(params[:id])
  patient.destroy
  redirect '/patients'
end


get '/patients/:id/charts' do
  @patient = Patient.find(params[:id])
  @measurements = @patient.measurements.order(measurement_time: :asc)
  erb :charts
end

get '/patients/:id/print' do
  @patient = Patient.find(params[:id])
  @measurements = @patient.measurements.order(measurement_time: :asc)
  erb :print, layout: false
end

# Маршрут для редактирования измерения
get '/patients/:patient_id/measurements/:id/edit' do
  @patient = Patient.find(params[:patient_id])
  @measurement = @patient.measurements.find(params[:id])
  erb :edit_measurement
end

# Маршрут для обновления измерения
put '/patients/:patient_id/measurements/:id' do
  @patient = Patient.find(params[:patient_id])
  @measurement = @patient.measurements.find(params[:id])
  
  if @measurement.update(params[:measurement])
    redirect "/patients/#{params[:patient_id]}/partogram"
  else
    erb :edit_measurement
  end
end

# Маршрут для удаления измерения
delete '/patients/:patient_id/measurements/:id' do
  patient = Patient.find(params[:patient_id])
  measurement = patient.measurements.find(params[:id])
  measurement.destroy
  redirect "/patients/#{params[:patient_id]}/partogram"
end

# app.rb (добавить новый маршрут)
get '/patients/:id/who_partogram' do
  @patient = Patient.find(params[:id])
  @measurements = @patient.measurements.order(measurement_time: :asc)
  erb :who_partogram, layout: false  # Без основного макета для печати
end