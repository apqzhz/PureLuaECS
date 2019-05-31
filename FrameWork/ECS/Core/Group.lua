
local Group = Class("Group")



function Group:Ctor(matcher)
    self._entityList = {}
    self._groupChangeDelegate = Delegate()
    self._matcher = matcher
end


function Group:AddEntity(entity)
    if not self._entityList[entity._entityId] then
        self._entityList[entity._entityId] = entity
        --通知系统组内实体添加
        self._groupChangeDelegate(entity,true)
    end
end


function Group:RemoveEntity(entity)
    if self._entityList[entity._entityId] then
        self._entityList[entity._entityId] = nil
        --通知系统组内实体减少
        self._groupChangeDelegate(entity,false)
    end
end


function Group:HandleEntityChange(entity, componentEnum)
    if self._matcher:Match(entity) then
        self:AddEntity(entity)
    else
        self:RemoveEntity(entity)
    end
end


function Group:HandleEntityReplace(entity, componentEnum, newComponentClass)
    if not self._matcher:Match(entity) then
        --if not newComponentClass then
            self:RemoveEntity(entity)
        --end
    end
end


function Group:GetEntities()
    return self._entityList
end


function Group:AddGroupChangeListener(classInstance, callback)
    if self._groupChangeDelegate then
        local funcPair = {classInstance, callback}
        self._groupChangeDelegate = self._groupChangeDelegate + funcPair
    end
end


function Group:RemoveGroupChangeListener(classInstance, callback)
    if self._groupChangeDelegate then
        local funcPair = {classInstance, callback}
        self._groupChangeDelegate = self._groupChangeDelegate - funcPair
    end
end


return Group