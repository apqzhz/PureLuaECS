
local Entity = Class("Entity")

function Entity:LoadModelComponent()
    return self:GetComponent(ComponentEnum.LoadModel)
end



return PartialClass(Entity,"Entity")