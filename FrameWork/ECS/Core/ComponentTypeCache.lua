local ComponentTypeCache = Class("ComponentTypeCache")


function ComponentTypeCache:Ctor()
    self._classCache = {}
end


function ComponentTypeCache:AddType(newComponentEnum, newComponentClass)
    if self._classCache[newComponentEnum] == nil then
        self._classCache[newComponentEnum] = newComponentClass
    end
end


function ComponentTypeCache:GetType(componentEnum)
    if self._classCache[componentEnum] then
        return self._classCache[componentEnum]
    else
        error(string.format("ComponentTypeCache.GetType: can not find type %s ", componentEnum))
    end
end


ComponentTypeCache.Instance = ComponentTypeCache.New()

return ComponentTypeCache

