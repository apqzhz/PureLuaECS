local Player = Class("Player")



function Player:Ctor()
    self._selfEntity = nil
end


function Player:Born()
    self._selfEntity = World.Instance:CreateEntity()
end



return Player