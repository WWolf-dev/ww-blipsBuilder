-- Determine the framework in use (ESX or QBCore)
if FrameworkUse == "ESX" then 

    -- Check the ESX Version and initialize the framework
    if versionESX == "older" then 
        ESX = nil
        CreateThread(function()
            -- Wait for ESX to be initialized
            while ESX == nil do
                TriggerEvent(getSharedObjectEvent, function(obj) ESX = obj end)
                Wait(0)
            end
        end)
    elseif versionESX == "newer" then 
        FrameworkExport()  -- Export new ESX functionalities
    end

    -- Register an event when the player is loaded
    RegisterNetEvent(playerLoadedEvent)
    AddEventHandler(playerLoadedEvent, function(xPlayer)
        ESX.PlayerData = xPlayer  -- Store player data locally
        PlayerLoaded = true
    end)

    AddEventHandler("onResourceStart", function(resource)
        if resource == GetCurrentResourceName() then
            LoadAllBlipsFromDB()
        end
    end)


    -- Local function to display the Blips creation menu
    local function BlipsCreatorMenu()
        -- Menu structure
        lib.registerContext({
            id = "main_menu_blips_creator",
            title = "Gestion des Blips",
            options = {
                {
                    title = "Crée un blip",
                    description = "Crée un blips avec toutes les options souhaitées",
                    icon = "fa-solid fa-card",
                    onSelect = function()
                        if DebugMode then
                            print("Access to the blips creator menu")
                        end
                        BlipSettings()
                    end
                },
                {
                    title = "Liste des blips",
                    description = "Liste des blips à proximité",
                    icon = "fa-solid fa-card",
                    onSelect = function()
                        if DebugMode then
                            print("Running blip List")
                        end
                        BlipsListMenu()
                    end
                }
            }
        })

        -- Show the menu to the user
        lib.showContext("main_menu_blips_creator")
    end

    -- Function to handle blip settings
    function BlipSettings()
        -- Input dialogue for Blip settings
        local input = lib.inputDialog('Paramètres du blip', {
            {
                type = 'number',
                label = 'Sprite du Blip',
                description = 'Voici un lien pour choisir votre sprite : \n https://wiki.rage.mp/index.php?title=Blips',
                icon = 'hashtag',
                required = true,
                min = 1,
                max = 866
            },
            {
                type = 'slider',
                label = 'Taille du Blip',
                description = 'Choisissez la taille de votre blip',
                icon = 'hashtag',
                required = true,
                min = 0.1,
                max = 2.0,
                step = 0.1  -- définit la précision du curseur, ajustez selon vos besoins
            },
            {
                type = 'number',
                label = 'Couleur du Blip',
                description = "Voici un lien pour choisir votre couleur : \n https://wiki.rage.mp/index.php?title=Blips",
                icon = 'hashtag',
                required = true,
                min = 1,
                max = 85
            },
            {
                type = 'number',
                label = 'Opacité du Blip',
                description = "Choisissez l'opacité de votre blip",
                icon = 'hashtag',
                required = true,
                min = 1,
                max = 254
            },
            {
                type = 'input',
                label = 'Nom de votre Blip',
                description = 'Choisissez le nom de votre blip qui sera affiché sur la carte',
                placeholder = 'Nom du blip',
                icon = 'hashtag',
                required = true,
                min = 2,
                max = 20
            }
        })

        -- If user provided input, create blip with those settings
        if input then
            Blip(input)
        else
            if DebugMode then
                print("No input")
            end
            lib.showContext("main_menu_blips_creator")
        end
    end


    -- Function to create blip using provided settings
    function Blip(input)
        -- Create a blip at player's current location
        local blip = AddBlipForCoord(GetEntityCoords(PlayerPedId()))

        -- Set blip properties based on user input
        SetBlipSprite(blip, tonumber(input[1]))
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, tonumber(input[2]))
        SetBlipColour(blip, tonumber(input[3]))
        SetBlipAlpha(blip, tonumber(input[4]))
        SetBlipAsShortRange(blip, true)

        -- Set blip name
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(input[5])
        EndTextCommandSetBlipName(blip)

        -- Print the blip properties for debugging purposes
        if DebugMode then
            print("Blip sprite:", tonumber(input[1]))
            print("Blip scale:", tonumber(input[2]))
            print("Blip color:", tonumber(input[3]))
            print("Blip alpha:", tonumber(input[4]))
            print("Blip name:", input[5])
        end

        local coords = GetEntityCoords(PlayerPedId())
        local blipData = {
            name = input[5],
            sprite = tonumber(input[1]),
            size = tonumber(input[2]),
            color = tonumber(input[3]),
            alpha = tonumber(input[4]),
            coords = {
                x = coords.x,
                y = coords.y,
                z = coords.z,
            }
        }

        TriggerServerEvent('ww-blipsbuilder:Server:storeBlipInDB', blipData)
    end

    -- Tableau pour stocker les blips avec leur ID comme clé
local blipsOnMap = {}

function LoadAllBlipsFromDB()
    -- Fetch all blips from the server
    ESX.TriggerServerCallback('getAllBlipsFromDB', function(blips)
        if blips then
            for _, blipData in ipairs(blips) do
                -- Convert stored JSON coords back to a table
                local coords = json.decode(blipData.blip_coords)

                -- Create the blip using the retrieved data
                local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

                SetBlipSprite(blip, blipData.blip_sprite)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, blipData.blip_size)
                SetBlipColour(blip, blipData.blip_color)
                SetBlipAlpha(blip, blipData.blip_alpha)
                SetBlipAsShortRange(blip, true)

                -- Set blip name
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentSubstringPlayerName(blipData.blip_name)
                EndTextCommandSetBlipName(blip)

                -- Stockez le blip dans le tableau en utilisant l'ID du blip comme clé
                blipsOnMap[blipData.id] = blip
            end
        end
    end)
end


    function BlipsListMenu()
        -- Demande au serveur la liste de tous les blips
        ESX.TriggerServerCallback('getAllBlipsFromDB', function(blips)

            -- Si aucune donnée n'est renvoyée, terminez la fonction ici
            if not blips then return end

            -- Construire le tableau des options pour le menu basé sur les blips reçus
            local options = {}
            for _, blipData in ipairs(blips) do
                local coords = json.decode(blipData.blip_coords)

                table.insert(options, {
                    title = blipData.blip_name,
                    description = string.format("Sprite: %s, Taille: %s, Couleur: %s, Opacité: %s",
                        blipData.blip_sprite,
                        blipData.blip_size,
                        blipData.blip_color,
                        blipData.blip_alpha
                    ),
                    onSelect = function()
                        lib.registerContext({
                            id = "blip_options_menu",
                            title = "Options du Blip",
                            menu = "blips_list_menu",
                            options = {
                                {
                                    title = "Téléporter sur le blip",
                                    description = "Téléporte le joueur au blip",
                                    icon = "fa-solid fa-map-marker",
                                    onSelect = function()
                                        DoScreenFadeOut(2000)
                                        Wait(2000)
                                        ESX.Game.Teleport(PlayerPedId(), coords)
                                        Wait(1000)
                                        DoScreenFadeIn(2000)
                                    end
                                },
                                {
                                    title = "Modifier le blip",
                                    description = "Modifier le blip avec toutes les options souhaitées",
                                    icon = "fa-solid fa-map-marker",
                                    onSelect = function()
                                        local input = lib.inputDialog('Paramètres du blip', {
                                            {
                                                type = 'number',
                                                label = 'Sprite du Blip',
                                                default = blipData.blip_sprite,
                                                icon = 'hashtag',
                                                required = true,
                                                min = 1,
                                                max = 866
                                            },
                                            {
                                                type = 'slider',
                                                label = 'Taille du Blip',
                                                default = blipData.blip_size,
                                                icon = 'hashtag',
                                                required = true,
                                                min = 0.1,
                                                max = 2.0,
                                                step = 0.1
                                            },
                                            {
                                                type = 'number',
                                                label = 'Couleur du Blip',
                                                default = blipData.blip_color,
                                                icon = 'hashtag',
                                                required = true,
                                                min = 1,
                                                max = 85
                                            },
                                            {
                                                type = 'number',
                                                label = 'Opacité du Blip',
                                                default = blipData.blip_alpha,
                                                icon = 'hashtag',
                                                required = true,
                                                min = 1,
                                                max = 254
                                            },
                                            {
                                                type = 'input',
                                                label = 'Nom de votre Blip',
                                                default = blipData.blip_name,
                                                icon = 'hashtag',
                                                required = true,
                                                min = 2,
                                                max = 20
                                            }
                                        })
    
                                        -- Si l'utilisateur fournit une entrée, mettez à jour le blip avec ces paramètres
                                        if input then
                                            
                                            local hasChanged = false
                                
                                            -- Compare les nouvelles valeurs avec les anciennes pour détecter les changements
                                            if tonumber(input[1]) ~= blipData.blip_sprite or
                                               tonumber(input[2]) ~= blipData.blip_size or
                                               tonumber(input[3]) ~= blipData.blip_color or
                                               tonumber(input[4]) ~= blipData.blip_alpha or
                                               input[5] ~= blipData.blip_name then
                                                hasChanged = true
                                            end
                                
                                            if hasChanged then
                                                local updatedBlipData = {
                                                    id = blipData.id,
                                                    name = input[5],
                                                    sprite = tonumber(input[1]),
                                                    size = tonumber(input[2]),
                                                    color = tonumber(input[3]),
                                                    alpha = tonumber(input[4]),
                                                    coords = {
                                                        x = coords.x,
                                                        y = coords.y,
                                                        z = coords.z,
                                                    }
                                                }
                                                TriggerServerEvent('ww-blipsbuilder:Server:updateBlipInDB', updatedBlipData)

                                                local existingBlip = blipsOnMap[blipData.id]
                                                if existingBlip then
                                                    RemoveBlip(existingBlip)
                                                end
                                                
                                                -- Now create a new blip with the updated data
                                                local newBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
                                                SetBlipSprite(newBlip, tonumber(input[1]))
                                                SetBlipDisplay(newBlip, 4)
                                                SetBlipScale(newBlip, tonumber(input[2]))
                                                SetBlipColour(newBlip, tonumber(input[3]))
                                                SetBlipAlpha(newBlip, tonumber(input[4]))
                                                SetBlipAsShortRange(newBlip, true)
                                                
                                                BeginTextCommandSetBlipName("STRING")
                                                AddTextComponentSubstringPlayerName(input[5])
                                                EndTextCommandSetBlipName(newBlip)
                                                
                                                -- Store the new blip in the table, replacing the old reference
                                                blipsOnMap[blipData.id] = newBlip
                                            else
                                                print("Aucun changement n'a été fait!")
                                            end
                                        else
                                            lib.showContext("blip_options_menu")
                                            print("No input provided!")
                                        end
                                    end
                                },
                                {
                                    title = "Supprimer le Blip",
                                    description = "Supprime le blip de la carte",
                                    icon = "fa-solid fa-trash",
                                    onSelect = function()
                                        local existingBlip = blipsOnMap[blipData.id]
                                        if existingBlip then
                                            RemoveBlip(existingBlip)
                                        end
                                        TriggerServerEvent('ww-blipsbuilder:Server:deleteBlipInDB', blipData.id)
                                    end
                                }
                            }
                        })
                        lib.showContext("blip_options_menu")
                    end
                })
            end

            -- Enregistrement et affichage du menu
            lib.registerContext({
                id = "blips_list_menu",
                title = "Liste des Blips",
                menu = "main_menu_blips_creator",
                options = options
            })

            lib.showContext("blips_list_menu")
        end)
    end

    -- Register a command for admin users to create blips
    RegisterCommand(CommandName, function()
        ESX.TriggerServerCallback('getAdminGrade', function(isAdmin)
            if isAdmin then
                if DebugMode then
                    print("You can acces blip creator menu")
                end
                BlipsCreatorMenu()
            else
                if DebugMode then
                    print("You do not have the rights to do this !.")
                end
            end
        end)
    end)





-- If using QBCore, this script is currently not supported
elseif FrameworkUse == "QBCore" then
    return nil
end