

local EntityPool = Class("EntityPool")


function EntityPool:Ctor()
    --entity缓存表
    self._entityCache = Stack.New()
    --使用中的entity
    self._entityTable = {}
    --所有系统groups
    self._groups = {}
    --当前使用的实体序号
    self._currentEntityId = 0
end


--当实体组件产生变化时通知各个Group
function EntityPool.OnEntityComponentAddedOrRemoved(self, entity, componentEnum, componentClass)
    for k,v in pairs(self._groups) do
        v:HandleEntityChange(entity, componentEnum)
    end
end


--当实体组件产生替换时通知各个Group
function EntityPool.OnEntityComponentReplaced(self, entity,componentEnum,newComponentClass)
    for k,v in pairs(self._groups) do
        v:HandleEntityReplace(entity, componentEnum, newComponentClass)
    end
end


function EntityPool:CreateEntity()
    local entity = Entity.New()
    entity:AddEntityChangeListener(self, self.OnEntityComponentAddedOrRemoved)  
    entity:AddEntityReplaceListener (self, self.OnEntityComponentReplaced)  
    return entity
end


function EntityPool:GetEntity()
    self._currentEntityId = self._currentEntityId + 1
    local entity
    if self._entityCache._count ~= 0 then
        entity = self._entityCache:Pop()
    else
        entity = self:CreateEntity()
    end
    entity._entityId = self._currentEntityId
    --table.insert(self._entityTable,entity._entityId,entity)
    self._entityTable[entity._entityId] = entity
    return entity
end


function EntityPool:RemoveEntity(entity)
    table.remove(self._entityTable, entity._id)
    entity:Clear()
    self._entityCache:Push(entity)
end


function EntityPool:CheckEntity(entityId)
    if self._entityTable[entityId] then
        return self._entityTable[entityId]
    else
        return nil
    end
end


--通过匹配器来查找Group
function EntityPool:GetGroup(matcher)
    --table address as key
    local key = tostring(matcher)
    if self._groups[key] then
        return self._groups[key]
    else
        local group = Group.New(matcher)
        self._groups[key] = group
        return group
    end
end


return EntityPool