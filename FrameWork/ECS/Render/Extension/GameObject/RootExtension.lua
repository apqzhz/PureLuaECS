
local Entity = Class("Entity")

function Entity:RootComponent()
    return self:GetComponent(ComponentEnum.Root)
end


function Entity:CreateRoot(name)
    if self:RootComponent() then
        self:RootComponent()._rootGameObject.name = name
        return self:RootComponent()
    else
        local com = self:CreateAndAddComponent(ComponentEnum.Root)
        com._rootName = name

        --创建UnityGameObject
        --此处调用unity接口实现
        --可以参考下面注释代码(使用xlua导出的unity接口)

        -- com._rootGameObject = CS.UnityEngine.GameObject(name)
        -- if World.Instance.WorldRoot then
        --     com._rootGameObject.transform.SetParent(World.Instance.WorldRoot)
        -- end
        
        return com
    end
end


return PartialClass(Entity,"Entity")