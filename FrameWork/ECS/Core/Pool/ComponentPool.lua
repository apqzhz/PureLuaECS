

local ComponentPool = Class("ComponentPool")


-- function ComponentPool:Allocate()
--     for k, v in pairs(ComponentEnum) do
--         self._pool[v] = Stack.New()
--     end
-- end


function ComponentPool:Ctor()
    self._pool = {}
end


function ComponentPool:GetComponent(comEnum)
    if type(comEnum) ~= "number" then
        error("ComponentPool.GetComponent:  comEnum is not a number! ".. comEnum)
        return nil
    end

    local pool = self:GetComponentPool(comEnum)
    if pool and pool._count  ~= 0 then
        return pool:Pop()
    else
        return ComponentTypeCache.Instance:GetType(comEnum).New()
    end
end


function ComponentPool:GetComponentPool(comEnum)
    if self._pool[comEnum] then
        return self._pool[comEnum]
    else
        self._pool[comEnum] = Stack.New()
    end
end


function ComponentPool:RecoverComponent(comEnum, comClass)
    local pool = self:GetComponentPool(comEnum)
    if comClass and comClass._RetainCount == 0 then
        comClass:Clear()
        pool:Push(comClass)
    end
end

ComponentPool.Instance = ComponentPool.New()

return ComponentPool