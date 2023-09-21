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

    RegisterServerEvent('ww-blipsbuilder:Server:storeBlipInDB')
    AddEventHandler('ww-blipsbuilder:Server:storeBlipInDB', function(blipData)
        -- Convertir les coordonnées en chaîne JSON pour le stockage
        local coordsJSON = json.encode(blipData.coords)

        local query = 'INSERT INTO blips (blip_name, blip_sprite, blip_size, blip_color, blip_alpha, blip_coords) VALUES (@name, @sprite, @size, @color, @alpha, @coords)'
        local values = {
            ['@name'] = blipData.name,
            ['@sprite'] = blipData.sprite,
            ['@size'] = blipData.size,
            ['@color'] = blipData.color,
            ['@alpha'] = blipData.alpha,
            ['@coords'] = coordsJSON
        }

        MySQL.Async.execute(query, values, function(rowsChanged)
            if rowsChanged > 0 then
                print("Blip saved !")
            else
                print("Error while saving blip !")
            end
        end)
    end)

    ESX.RegisterServerCallback('getAllBlipsFromDB', function(source, cb)
        local query = 'SELECT * FROM blips'

        MySQL.Async.fetchAll(query, {}, function(result)
            if result and #result > 0 then
                cb(result)
            else
                cb(nil)
            end
        end)
    end)

    RegisterServerEvent('ww-blipsbuilder:Server:updateBlipInDB')
    AddEventHandler('ww-blipsbuilder:Server:updateBlipInDB', function(blipData)
        local query = 'UPDATE blips SET blip_name = @name, blip_sprite = @sprite, blip_size = @size, blip_color = @color, blip_alpha = @alpha, blip_coords = @coords WHERE id = @id'
        local values = {
            ['@id'] = blipData.id,
            ['@name'] = blipData.name,
            ['@sprite'] = blipData.sprite,
            ['@size'] = blipData.size,
            ['@color'] = blipData.color,
            ['@alpha'] = blipData.alpha,
            ['@coords'] = json.encode(blipData.coords)
        }

        MySQL.Async.execute(query, values, function(rowsChanged)
            if rowsChanged > 0 then
                print("Blip updated!")
            else
                print("Error updating blip!")
            end
        end)
    end)

    RegisterServerEvent('ww-blipsbuilder:Server:deleteBlipInDB')
    AddEventHandler('ww-blipsbuilder:Server:deleteBlipInDB', function(blipId)
        local query = 'DELETE FROM blips WHERE id = @id'
        local values = {
            ['@id'] = blipId
        }

        MySQL.Async.execute(query, values, function(rowsChanged)
            if rowsChanged > 0 then
                print("Blip deleted!")
            else
                print("Error deleting blip!")
            end
        end)
    end)




    
    -- Soon QBCore support
elseif FrameworkUse == "QBCore" then
    return nil
end
