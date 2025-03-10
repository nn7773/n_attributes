ESX = exports['es_extended']:getSharedObject()

MySQL.ready(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS player_attributes (
            identifier VARCHAR(50) NOT NULL PRIMARY KEY,
            name VARCHAR(100) NOT NULL,
            age VARCHAR(10) NOT NULL,
            height VARCHAR(10) NOT NULL,
            description TEXT NOT NULL
        );
    ]])
end)

RegisterNetEvent('saveAttributes', function(age, height, description)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local identifier = xPlayer.identifier
    local characterName = xPlayer.getName()

    MySQL.update('REPLACE INTO player_attributes (identifier, name, age, height, description) VALUES (?, ?, ?, ?, ?)', {
        identifier,
        characterName,
        age,
        height,
        description
    })
end)

RegisterNetEvent('getAttributes', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local identifier = xPlayer.identifier

    MySQL.query('SELECT age, height, description FROM player_attributes WHERE identifier = ?', { identifier }, function(result)
        if result[1] then
            TriggerClientEvent('showUI', source, {
                age = result[1].age,
                height = result[1].height,
                description = result[1].description
            })
        else
            TriggerClientEvent('showUI', source, {
                age = "",
                height = "",
                description = ""
            })
        end
    end)
end)

-- Examine Command /ex
RegisterCommand("examine", function(source, args)
    if #args < 1 then
        TriggerClientEvent("chat:addMessage", source, { args = { "^1[!] ^0 /examine [playerID]" } })
        return
    end

    local targetID = tonumber(args[1])
    local xPlayer = ESX.GetPlayerFromId(targetID)
    if not xPlayer then
        TriggerClientEvent("chat:addMessage", source, { args = { "^1[!]", "^0Invalid player ID." } })
        return
    end

    local identifier = xPlayer.identifier

    MySQL.query('SELECT * FROM player_attributes WHERE identifier = ?', { identifier }, function(result)
        if result[1] then
            local attributes = result[1]
            local message = "<div style='padding: 5px; background-color: rgba(0, 0, 0, 0); border-radius: 5px;'>\n"
            message = message .. string.format("<p style='color: #ffffff;'><strong>%s's Attributes:</strong></p>\n", attributes.name)
            message = message .. string.format("<p style='color: #ffffff;'>Age: %s</p>\n", attributes.age)
            message = message .. string.format("<p style='color: #ffffff;'>Height: %s</p>\n", attributes.height)
            message = message .. string.format("<p style='color: #ffffff;'>Description: %s</p>\n", attributes.description)
            message = message .. "</div>"

            TriggerClientEvent('chat:addMessage', source, { template = message })
        else
            TriggerClientEvent('chat:addMessage', source, { args = { '^1[!]', '^0No attributes found for the specified player ID.' } })
        end
    end)
end, false)
