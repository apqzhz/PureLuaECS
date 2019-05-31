local function ComponentClass(className, componentEnum)
    local class = Class(className, BaseComponent)
    ComponentTypeCache.Instance:AddType(componentEnum, class)
    return class
end

SetGlobal("ComponentClass",ComponentClass)