
-- Импортёр пиксельного референса
-- Версия 0.1.0

local function showError(message)
    app.alert {
        title = "Импортёр пиксельного референса",
        text = message
    }
end

local function importReference()
    local path = app.fs.fileOpen {
        title = "Выберите PNG-референс",
        filetypes = {"png"}
    }

    if not path or path == "" then
        return
    end

    local ok, err = pcall(function()
        local source = Sprite { fromFile = path }

        if not source then
            error("Не удалось открыть изображение.")
        end

        -- Сохраняем исходное имя слоя.
        local originalLayer = source.layers[1]
        if originalLayer then
            originalLayer.name = "Референс"
        end

        -- Создаём копию изображения для основы.
        local baseLayer = source:newLayer()
        baseLayer.name = "Пиксельная основа"

        local sourceCel = originalLayer and originalLayer:cel(1)

        if sourceCel then
            local baseCel = source:newCel(
                baseLayer,
                sourceCel.frame,
                sourceCel.image,
                sourceCel.position
            )
        end

        app.activeSprite = source

        app.alert {
            title = "Импорт завершён",
            text = "Созданы слои:\nРеференс\nПиксельная основа\n\nОба слоя можно редактировать."
        }
    end)

    if not ok then
        showError("Ошибка импорта:\n" .. tostring(err))
    end
end

local function showDialog()
    local dlg = Dialog {
        title = "Импортёр пиксельного референса"
    }

    dlg:label {
        text = "Импорт PNG в Aseprite"
    }

    dlg:label {
        text = "Исходник сохранится на отдельном слое."
    }

    dlg:button {
        text = "Выбрать PNG",
        onclick = function()
            dlg:close()
            importReference()
        end
    }

    dlg:button {
        text = "Отмена",
        onclick = function()
            dlg:close()
        end
    }

    dlg:show()
end

showDialog()
