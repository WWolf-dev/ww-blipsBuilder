if FrameworkUse == "ESX" then
    if versionESX == "older" then
        ESX = nil
        TriggerEvent(getSharedObjectEvent, function(obj) ESX = obj end)
    elseif versionESX == "newer" then
        FrameworkExport()
    end

    -- Cette fonction vérifie si le grade est autorisé
    local function IsGradeAuthorized(grade)
        for _, authorizedGrade in ipairs(AuthorizedGrade) do
            if grade == authorizedGrade then
                return true
            end
        end
        return false
    end

    ESX.RegisterServerCallback('getAdminGrade', function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        
        if IsGradeAuthorized(xPlayer.getGroup()) then
            cb(true)
        else
            cb(false)
        end
    end)




    
    -- Soon QBCore support
elseif FrameworkUse == "QBCore" then
    return nil
end
