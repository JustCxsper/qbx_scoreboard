local config = require 'config.client'
print("[DEBUG] config.illegalActions loaded:", json.encode(config.illegalActions or {}))
print("[DEBUG] enablePlayerList:", config.enablePlayerList or false)
print("[DEBUG] showPlayers:", config.showPlayers)
print("[DEBUG] showAdmins:", config.showAdmins)

local isScoreboardOpen = false
local onDutyAdmins = {}

local function shouldShowPlayerId(targetServerId)
    if config.idVisibility == 'all' then return true end
    if onDutyAdmins[cache.serverId] then return true end
    if config.idVisibility == 'admin_only' then return false end
    if config.idVisibility == 'admin_excluded' and onDutyAdmins[targetServerId] then return false end
    return true
end

local function openScoreboard()
    local totalPlayers, policeCount, receivedOnDutyAdmins = lib.callback.await('qbx_scoreboard:server:getScoreboardData')
    if not totalPlayers then return end

    onDutyAdmins = receivedOnDutyAdmins or {}

    local adminCount = 0
    for _ in pairs(onDutyAdmins) do
        adminCount += 1
    end

    local options = {}

    if config.showPlayers then
        local playersItem = {
            title       = ("Players: %s/%s"):format(totalPlayers, config.maxPlayers),
            description = ("Police Online: %s"):format(policeCount),
            icon        = "fas fa-users",
            iconColor   = "#60A5FA",
            readOnly    = true,
        }

        if config.enablePlayerList then
            playersItem.readOnly = false
            playersItem.arrow    = true
            playersItem.onSelect = function()
                lib.callback('qbx_scoreboard:server:getOnlinePlayers', false, function(playerList)
                    if not playerList or #playerList == 0 then
                        lib.notify({ title = 'Scoreboard', description = 'No players found', type = 'inform' })
                        return
                    end

                    local playerOptions = {}

                    table.insert(playerOptions, {
                        title       = ('Online Players (%s)'):format(#playerList),
                        description = 'Sorted by name',
                        icon        = 'fas fa-list',
                        readOnly    = true,
                        disabled    = true,
                    })

                    for _, p in ipairs(playerList) do
                        table.insert(playerOptions, {
                            title       = p.name,
                            description = ('ID: %s • %s'):format(p.id, p.job),
                            icon        = 'fas fa-user',
                            iconColor   = '#A1A1AA',
                            readOnly    = true,
                        })
                    end

                    table.insert(playerOptions, {
                        title     = 'Back to Scoreboard',
                        icon      = 'fas fa-arrow-left',
                        iconColor = '#F87171',
                        onSelect  = function()
                            openScoreboard()
                        end,
                    })

                    exports.lation_ui:registerMenu({
                        id       = 'scoreboard_players_list',
                        title    = 'Online Players',
                        position = 'top-right',
                        options  = playerOptions
                    })

                    exports.lation_ui:showMenu('scoreboard_players_list')
                end)
            end
        end

        table.insert(options, playersItem)
    end

    if config.showAdmins then
        table.insert(options, {
            title     = ("Admins On Duty: %s"):format(adminCount),
            icon      = "fas fa-shield-halved",
            iconColor = "#3B82F6",
            readOnly  = true
        })
    end

    local illegalGlobal = GlobalState.illegalActions or {}
    local illegalConfig = config.illegalActions or {}
    local available = {}
    local busyList = {}
    local locked = {}

    for key, cfg in pairs(illegalConfig) do
        local state = illegalGlobal[key] or {}
        local busy = state.busy or false
        local requiredPolice = cfg.minimumPolice or 0

        local statusText, icon, iconColor

        if busy then
            statusText = "In Progress"
            icon = "fas fa-hourglass-half"
            iconColor = "#F59E0B"
        elseif policeCount < requiredPolice then
            statusText = ("Requires %s Police"):format(requiredPolice)
            icon = "fas fa-lock"
            iconColor = "#EF4444"
        else
            statusText = "Available"
            icon = "fas fa-check-circle"
            iconColor = "#10B981"
        end

        local item = {
            title       = cfg.label or key,
            description = statusText,
            icon        = icon,
            iconColor   = iconColor,
            readOnly    = true,
        }

        if cfg.image then
            item.image = cfg.image
        end

        if busy then
            table.insert(busyList, item)
        elseif policeCount < requiredPolice then
            table.insert(locked, item)
        else
            table.insert(available, item)
        end
    end

    for _, item in ipairs(available) do table.insert(options, item) end
    for _, item in ipairs(busyList) do table.insert(options, item) end
    for _, item in ipairs(locked) do table.insert(options, item) end

    exports.lation_ui:registerMenu({
        id       = 'scoreboard_menu',
        title    = 'Scoreboard',
        position = 'top-right',
        options  = options,
        canClose = true,
        onExit   = function()
            isScoreboardOpen = false
        end
    })

    exports.lation_ui:showMenu('scoreboard_menu')
    isScoreboardOpen = true
end

local function closeScoreboard()
    exports.lation_ui:hideMenu('scoreboard_menu')
    isScoreboardOpen = false
end

if config.toggle then
    lib.addKeybind({
        name        = 'scoreboard',
        description = 'Open Scoreboard',
        defaultKey  = config.openKey,
        onPressed   = function()
            if isScoreboardOpen then
                closeScoreboard()
            else
                openScoreboard()
            end
        end,
    })
else
    lib.addKeybind({
        name        = 'scoreboard',
        description = 'Open Scoreboard',
        defaultKey  = config.openKey,
        onPressed   = openScoreboard,
        onReleased  = closeScoreboard
    })
end

CreateThread(function()
    while true do
        if isScoreboardOpen then
            local players = cache('nearbyPlayers', function()
                local p = lib.getNearbyPlayers(GetEntityCoords(cache.ped), config.visibilityDistance, true)
                for i = #p, 1, -1 do
                    p[i].serverId = GetPlayerServerId(p[i].id)
                    if not shouldShowPlayerId(p[i].serverId) then
                        p[i] = p[#p]
                        p[#p] = nil
                    end
                end
                return p
            end, 500)

            for i = 1, #players do
                local player = players[i]
                if DoesEntityExist(player.ped) then
                    local pedCoords = GetEntityCoords(player.ped)
                    qbx.drawText3d({
                        text = '[' .. player.serverId .. ']',
                        coords = vec3(pedCoords.x, pedCoords.y, pedCoords.z + 1.0),
                    })
                end
            end

            Wait(0)
        else
            Wait(500)
        end
    end
end)