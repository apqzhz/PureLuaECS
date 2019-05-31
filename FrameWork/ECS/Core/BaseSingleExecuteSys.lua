local BaseSingleExecuteSys = Class("BaseSingleExecuteSys",BaseSystem)


function BaseSingleExecuteSys:Ctor(requireComs)
    print("=================BaseSingleExecuteSys:Ctor=============")
    self._changedEntities = {}
end


function BaseSingleExecuteSys:AddGroupChangeListener()
    self._group:AddGroupChangeListener(self, self.HandleGroupChange)
end


function BaseSingleExecuteSys:RemoveGroupChangeListener()
    self._group:RemoveGroupChangeListener(self, self.HandleGroupChange)
end


function BaseSingleExecuteSys.HandleGroupChange(self, entity, isAdd)
    if self._changedEntities[entity._entityId] and isAdd == false then
        self._changedEntities[entity._entityId] = nil
    elseif not self._changedEntities[entity._entityId] and isAdd == true then
        self._changedEntities[entity._entityId] = entity
    end
end


function BaseSingleExecuteSys:Execute()
    for id,entity in IpairsSparse(self._changedEntities) do
        self:OnExecuteOnce(entity)
    end
end


--Tobe override
function BaseSingleExecuteSys:OnExecuteOnce(entity)

end


function BaseSingleExecuteSys:CleanEntities()
    self._changedEntities = {}
end


return BaseSingleExecuteSys