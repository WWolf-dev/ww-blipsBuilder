--██████╗░███████╗██████╗░██╗░░░██╗░██████╗░  ███╗░░░███╗░█████╗░██████╗░███████╗
--██╔══██╗██╔════╝██╔══██╗██║░░░██║██╔════╝░  ████╗░████║██╔══██╗██╔══██╗██╔════╝
--██║░░██║█████╗░░██████╦╝██║░░░██║██║░░██╗░  ██╔████╔██║██║░░██║██║░░██║█████╗░░
--██║░░██║██╔══╝░░██╔══██╗██║░░░██║██║░░╚██╗  ██║╚██╔╝██║██║░░██║██║░░██║██╔══╝░░
--██████╔╝███████╗██████╦╝╚██████╔╝╚██████╔╝  ██║░╚═╝░██║╚█████╔╝██████╔╝███████╗
--╚═════╝░╚══════╝╚═════╝░░╚═════╝░░╚═════╝░  ╚═╝░░░░░╚═╝░╚════╝░╚═════╝░╚══════╝


-- Activate or Desactivate the Debug Mode

DebugMode = true

--███████╗██████╗░░█████╗░███╗░░░███╗███████╗░██╗░░░░░░░██╗░█████╗░██████╗░██╗░░██╗
--██╔════╝██╔══██╗██╔══██╗████╗░████║██╔════╝░██║░░██╗░░██║██╔══██╗██╔══██╗██║░██╔╝
--█████╗░░██████╔╝███████║██╔████╔██║█████╗░░░╚██╗████╗██╔╝██║░░██║██████╔╝█████═╝░
--██╔══╝░░██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝░░░░████╔═████║░██║░░██║██╔══██╗██╔═██╗░
--██║░░░░░██║░░██║██║░░██║██║░╚═╝░██║███████╗░░╚██╔╝░╚██╔╝░╚█████╔╝██║░░██║██║░╚██╗
--╚═╝░░░░░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚══════╝░░░╚═╝░░░╚═╝░░░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝


---@param Set "ESX" if you are using ESX Framework
---@param Set "QBCore" if you are using QbCore Framework     /!\ QbCore is not supported yet /!\

FrameworkUse = "ESX"



---@param Set "older" if you are using ESX 1.7.5 or older
---@param Set "newer" if you are using ESX 1.8.5 or newer

versionESX = "newer"



--- @param Uncomment "First" line if you are using newer version of ESX and if you put "new" at line 19
--- @param Uncomment "Second" line if you are using QBCore and if you put "QbCore" at line 12
function FrameworkExport()
    ESX = exports['es_extended']:getSharedObject()
    -- QBCore = exports['qb-core']:GetCoreObject()
end

--░█▀▀▀ ░█▀▀▀█ ▀▄░▄▀
--░█▀▀▀ ─▀▀▀▄▄ ─░█──
--░█▄▄▄ ░█▄▄▄█ ▄▀░▀▄


getSharedObjectEvent = 'esx:getSharedObject' -- Modify your ESX-based framework event here.
playerLoadedEvent = 'esx:playerLoaded'       -- Modify your ESX-based framework event here.
setJobEvent = 'esx:setJob'                   -- Modify your ESX-based framework event here.


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--░█▀▀█ ░█▀▀█ ░█▀▀█ ░█▀▀▀█ ░█▀▀█ ░█▀▀▀
--░█─░█ ░█▀▀▄ ░█─── ░█──░█ ░█▄▄▀ ░█▀▀▀
--─▀▀█▄ ░█▄▄█ ░█▄▄█ ░█▄▄▄█ ░█─░█ ░█▄▄▄



--░█▀▀▀█ ░█▀▀▀█ ░█▀▀▀█ ░█▄─░█ 　 ─ ─ ─
--─▀▀▀▄▄ ░█──░█ ░█──░█ ░█░█░█ 　 ▄ ▄ ▄
--░█▄▄▄█ ░█▄▄▄█ ░█▄▄▄█ ░█──▀█ 　 █ █ █