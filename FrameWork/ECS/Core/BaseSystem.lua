
local BaseSystem = Class("BaseSystem")



function BaseSystem:Ctor(requireComs,className)
    print("=================BaseSystem:Ctor=============")
    self._group = nil
    self._matcher = nil
    self._requireComs = requireComs
    self:Initialize()
    self._group._sysClassName = className
end


local function CopyEnumTable(t)
    local newT = {}
    for k,v in ipairs(t) do
        --第一个参数不是枚举，而是matcher类型
        if k ~= 1 then
            table.insert(newT, v)
        end
    end
    return newT
end


function BaseSystem:Initialize()
    local matchType = self._requireComs[1]
    if type(matchType) ~= "number" then
        error("BaseSystem.Initialize: system matchType is not a Enum")
    end

    if matchType == MatchEnum.AllOf then
        self._matcher = Match:AllOfMatcher(CopyEnumTable(self._requireComs))
    elseif matchType == MatchEnum.AnyOf then
        self._matcher = Match:AnyOfMatcher(CopyEnumTable(self._requireComs))
    elseif matchType == MatchEnum.NoneOf then
        self._matcher = Match:NoneOfMatcher(CopyEnumTable(self._requireComs))      
    end
    self._group = World.Instance._entityPool:GetGroup(self._matcher)
end


--Tobe override
function BaseSystem:Execute()

end


--Tobe override
function BaseSystem:Destroy()

end

return BaseSystem