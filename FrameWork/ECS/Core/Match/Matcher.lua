
local Matcher = Class("Matcher")


function Matcher:Ctor()
    self._allIndices = nil
    self._anyIndices = nil
    self._noneIndices = nil
end


function Matcher:Match(entity)
    return (self._allIndices == nil or entity:HasComponents(self._allIndices))
    and (self._anyIndices == nil or entity:HasAnyComponent(self._anyIndices))
    and (self.noneIndices == nil or not entity:HasAnyComponent(self._noneIndices))
end


function Matcher:DistinctIndices(indices)
    local uniqueIndices = {}
    for k,v in ipairs(indices) do
        if not uniqueIndices[k] then
            uniqueIndices[k] = v
        end
    end
    return uniqueIndices
end


return Matcher