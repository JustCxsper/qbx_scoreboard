local config = require 'config.server'
GlobalState.illegalActions = config.illegalActions

lib.callback.register('qbx_scoreboard:server:getScoreboardData', function()
    local totalPlayers = 0
    local policeCount = 0
    local onDutyAdmins = {}

    for _, v in pairs(exports.qbx_core:GetQBPlayers()) do
        if v then
            totalPlayers += 1

            if v.PlayerData.job.type == 'leo' and v.PlayerData.job.onduty then
                policeCount += 1
            end

            onDutyAdmins[v.PlayerData.source] = IsPlayerAceAllowed(v.PlayerData.source, 'admin') and v.PlayerData.metadata.optin and true or nil
        end
    end

    return totalPlayers, policeCount, onDutyAdmins
end)

lib.callback.register('qbx_scoreboard:server:getOnlinePlayers', function(source)
    local players = {}

    for _, player in pairs(exports.qbx_core:GetQBPlayers()) do
        if player then
            local charInfo = player.PlayerData.charinfo
            local name = charInfo and (charInfo.firstname .. ' ' .. charInfo.lastname) or 'Unknown'
            local id = player.PlayerData.source
            local jobLabel = player.PlayerData.job.label or player.PlayerData.job.name or 'Civilian'
            local onDuty = player.PlayerData.job.onduty and ' (On Duty)' or ''

            table.insert(players, {
                name = name,
                id   = id,
                job  = jobLabel .. onDuty,
            })
        end
    end

    table.sort(players, function(a, b) return a.name < b.name end)

    return players
end)

local function setActivityBusy(name, bool)
    local illegalActions = GlobalState.illegalActions
    illegalActions[name].busy = bool
    GlobalState.illegalActions = illegalActions
end

RegisterNetEvent('qb-scoreboard:server:SetActivityBusy', setActivityBusy)
exports('SetActivityBusy', setActivityBusy)