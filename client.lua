RegisterNetEvent('showUI', function(data)
    SendNUIMessage({
        action = 'show',
        attributes = data 
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('closeUI', function(_, cb)
    SendNUIMessage({
        action = 'hide'
    })
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('saveAttributes', function(data, cb)
    local age = data.age
    local height = data.height
    local description = data.description

    TriggerServerEvent('saveAttributes', age, height, description)
    TriggerEvent('chat:addMessage', {
        args = { "^1[!]", "^0Attribution saved successfully!" }
    })

    cb('ok')
end)

--/attributes command
RegisterCommand('attributes', function()
    TriggerServerEvent('getAttributes')
end, false)
