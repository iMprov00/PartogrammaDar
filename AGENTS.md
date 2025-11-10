# Руководство для AI агентов - PartogrammaDar

## Команды
- Запуск: `bundle exec rackup` или `ruby app.rb`
- Миграции: `bundle exec rake db:migrate`
- Консоль: `bundle exec rake console`

## Стиль кода
- **Ruby**: Следуйте стандартному Ruby style guide
- **Имена**: snake_case для методов/переменных, CamelCase для классов
- **Модели**: `Patient`, `Measurement` - используйте ActiveRecord валидации
- **Маршруты**: RESTful структура Sinatra
- **Валидация**: Обязательные поля через `validates :field, presence: true`
- **Время**: Используйте `Time.now` для временных меток

## Архитектура
- Модели: `models/patient.rb`, `models/measurement.rb`
- Контроллер: `app.rb` (основной файл)
- Представления: `views/*.erb` с Bootstrap 5
- Таймеры: `lib/timer_manager.rb` для управления временем родов

## Особенности
- Статусы пациента: 'роды не начались', 'в родах', 'роды завершены'
- Таймер измерений: 30 минут между измерениями
- JSON API: `/timer/status/:patient_id` для реального времени