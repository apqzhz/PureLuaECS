
local Entity = Class("Entity")

function Entity:MoveComponent()
    return self:GetComponent(ComponentEnum.Move)
end



function Entity:MoveTo(speed, destination)
    local moveCom
    if self:MoveComponent() then
        moveCom = self:MoveComponent()
    else
        moveCom= self:CreateAndAddComponent(ComponentEnum.Move)
    end
    moveCom._moveType = MoveEnum.MoveByDelta
    moveCom._moveSpeed = speed
    moveCom._destination = destination
end





return PartialClass(Entity,"Entity")