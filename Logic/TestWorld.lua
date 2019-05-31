local TestWorld = Class("TestWorld")

function TestWorld:Initialize()
    local player = Player.New()
    player:Born()
    player._selfEntity:CreateRoot("LuaEntity")
end


function TestWorld:Update(time)

end


return TestWorld