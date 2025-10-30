// Основные функции JavaScript для приложения

document.addEventListener('DOMContentLoaded', function() {
    // Инициализация всех компонентов
    initTimerUpdates();
    initFormValidations();
});

// Функция для обновления таймеров
function initTimerUpdates() {
    console.log('Timer system initialized');
}

// Функция для валидации форм
function initFormValidations() {
    const forms = document.querySelectorAll('form');
    
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            const requiredFields = form.querySelectorAll('[required]');
            let valid = true;
            
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    valid = false;
                    field.classList.add('is-invalid');
                } else {
                    field.classList.remove('is-invalid');
                }
            });
            
            if (!valid) {
                e.preventDefault();
                alert('Пожалуйста, заполните все обязательные поля');
            }
        });
    });
}

// Функция для форматирования времени
function formatTime(minutes) {
    const hrs = Math.floor(minutes / 60);
    const mins = minutes % 60;
    return `${hrs.toString().padStart(2, '0')}:${mins.toString().padStart(2, '0')}`;
}

// Утилиты для работы с датами
const DateUtils = {
    formatDateTime: function(dateString) {
        const date = new Date(dateString);
        return date.toLocaleString('ru-RU');
    },
    
    formatDate: function(dateString) {
        const date = new Date(dateString);
        return date.toLocaleDateString('ru-RU');
    },
    
    getCurrentDateTime: function() {
        return new Date().toISOString().slice(0, 16);
    }
};

// Функция для подтверждения удаления
function confirmDelete(patientName) {
  return confirm(`Вы уверены, что хотите удалить пациентку "${patientName}"? Это действие нельзя отменить.`);
}

// Автоматическое обновление полей при изменении статуса
document.addEventListener('DOMContentLoaded', function() {
  const statusSelects = document.querySelectorAll('select[name="patient[status]"]');
  
  statusSelects.forEach(select => {
    select.addEventListener('change', function() {
      const deliveryCompletedCheckbox = document.querySelector('input[name="patient[delivery_completed]"]');
      if (this.value === 'роды завершены' && deliveryCompletedCheckbox) {
        deliveryCompletedCheckbox.checked = true;
      } else if (deliveryCompletedCheckbox) {
        deliveryCompletedCheckbox.checked = false;
      }
    });
  });
});