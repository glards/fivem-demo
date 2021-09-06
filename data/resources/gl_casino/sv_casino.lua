
local casinoPeds = {}

function playerEnterCasino()
    print('Entering casino ', source)
end

function playerLeaveCasino()
    print('Leaving casino ', source)
end

RegisterNetEvent('gl_casino:playerEnterCasino', playerEnterCasino)
RegisterNetEvent('gl_casino:playerLeaveCasino', playerLeaveCasino)

