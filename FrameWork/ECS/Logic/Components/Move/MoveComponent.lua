
local MoveComponent = ComponentClass("MoveComponent",ComponentEnum.Move)


function MoveComponent:Ctor()
    self._moveType = nil
    self._destination = nil
    self._moveSpeed = nil
end


function MoveComponent:Clear()
    self._moveType = nil
    self._destination = nil
    self._moveSpeed = nil
end


return MoveComponent