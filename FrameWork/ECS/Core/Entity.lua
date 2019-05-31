local Entity = Class("Entity")


function Entity:Ctor()
    self._entityId = nil
    self._componentList = {}
    self._componentAddOrRemoveDelegate = Delegate()
    self._componentReplaceDelegate = Delegate()
end


--创建并添加组件
function Entity:CreateAndAddComponent(componentEnum)
    if self._componentList[componentEnum] == nil then
        local com = self:CreateComponent(componentEnum)
        self:AddComponent(componentEnum, com)
    end
    return self._componentList[componentEnum]
end


--添加组件
function Entity:AddComponent(componentEnum, componentClass)
    if self._componentList[componentEnum] == nil then
        self._componentList[componentEnum] = componentClass
        self._componentAddOrRemoveDelegate(self, componentEnum, componentClass)
    else
        self:ReplaceComponent(componentEnum, componentClass)
    end
end


--创建组件
function Entity:CreateComponent(componentEnum)
    return ComponentPool.Instance:GetComponent(componentEnum)
end


--替换组件
function Entity:ReplaceComponent(componentEnum, newComponentClass)
    ComponentPool.Instance:RecoverComponent(componentEnum, self._componentList[componentEnum])
    self._componentList[componentEnum] = newComponentClass
    self._componentReplaceDelegate(self, componentEnum, newComponentClass)
end


--移除组件
function Entity:RemoveComponent(componentEnum)
    self:ReplaceComponent(componentEnum, nil)
end


function Entity:RemoveAllComponents()
    for enum,v in IpairsSparse(self._componentList) do
        self:RemoveComponent(enum)
    end
end


--帧末移除组件保证系统能执行一次component
function Entity:LateRemoveComponent(componentEnum)
    --TODO
end


function Entity:HasComponent(componentEnum)
    return self._componentList[componentEnum] ~= nil
end


function Entity:HasComponents(componentEnumList)
    for _, enum  in IpairsSparse(componentEnumList) do
        if self:HasComponent(enum) == false then
            return false
        end
    end
    return true
end


function Entity:HasAnyComponent(componentEnumList) 
    for _, enum in IpairsSparse(componentEnumList) do
        if self:HasComponent(enum) then
            return true
        end
    end
    return false
end


function Entity:GetComponent(componentEnum)
    return self._componentList[componentEnum]
end


function Entity:AddEntityChangeListener(classInstance, func)
    local funcPair = {classInstance, func}
    self._componentAddOrRemoveDelegate = self._componentAddOrRemoveDelegate + funcPair
end


function Entity:RemoveEntityChangeListener(classInstance, func)
    local funcPair = {classInstance, func}
    self._componentAddOrRemoveDelegate = self._componentAddOrRemoveDelegate - funcPair
end


function Entity:AddEntityReplaceListener(classInstance, func)
    local funcPair = {classInstance, func}
    self._componentReplaceDelegate = self._componentReplaceDelegate + funcPair
end


function Entity:RemoveEntityReplaceListener(classInstance, func)
    local funcPair = {classInstance, func}
    self._componentReplaceDelegate = self._componentReplaceDelegate - funcPair
end


function Entity:Clear()
    self._entityId = nil
    for k,v in IpairsSparse(self._componentList) do
        self:RemoveComponent(k)
    end
    self._componentReplaceDelegate:Clear()
    self._componentAddOrRemoveDelegate:Clear()
end


return PartialClass(Entity,"Entity")