console.log("Status button JavaScript loaded successfully!");
$(document).ready(function() {
    // Определение переменных

    console.log( availableStatuses );

    // Данные для кнопок на основе вашей таблицы
    let buttonData = [
        { name: "Новая", status: "Новая", icon: "icon-unread" },
        { name: "Назначить", status: "Назначена", icon: "icon-assign" },
        { name: "Анализ", status: "Анализ", icon: "icon-analysis" },
        { name: "В работу", status: "В работе", icon: "icon-inwork" },
        { name: "Завершить", status: "Решена", icon: "icon-done" },
        //... (и так далее для всех остальных кнопок из вашей таблицы)
    ];

    // Функция для добавления кнопок на основе доступных статусов
    function addButtons() {
        $("#content > .contextual").each(function() {
            let SearchButton = $(this).find(".icon-edit");

            // Перебор доступных статусов и добавление соответствующих кнопок
            availableStatuses.forEach(function(status) {
                let matchedButton = buttonData.find(b => b.status === status.name);

                if (matchedButton && !$("#" + matchedButton.name).length) {
                    let buttonHtml = `<a href="#" id="${matchedButton.name.replace(/ /g, '_')}" class="${matchedButton.icon}" data-issue-id="${issueId}" data-user-id="${CurrentUserId}">${matchedButton.name}</a>`;
                    SearchButton.before(buttonHtml);
                }
            });
        });
    }

    // Вызываем функцию при инициализации скрипта
    addButtons();

    // Обработчик для автообновления кнопок при смене статуса задачи
    $(document).on('ajax:complete', function() {
        // Если статусы обновляются асинхронно, перезагрузите availableStatuses
        // (здесь может потребоваться дополнительная логика)
        // Затем вызовите функцию добавления кнопок снова
        addButtons();
    });
});



