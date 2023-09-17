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
                    title = "Supprimer un blip",
                    description = "Supprimer un blip à proximité",
                    icon = "fa-solid fa-card",
                    onSelect = function()
                        if DebugMode then
                            print("Running blip deletion")
                        end
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
                max = 255
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