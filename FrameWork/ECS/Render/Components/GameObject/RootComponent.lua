local RootComponent = ComponentClass("RootComponent",ComponentEnum.Root)



function RootComponent:Ctor()
    self._rootGameObject = nil
    self._rootName = nil
end


function RootComponent:Clear()
    --用到的unity对象要销毁
    if self._rootGameObject then
        --使用C#接口
        --CS.UnityEngine.GameObject:Destroy(self._rootGameObject)
        self._rootGameObject = nil
    end
end


return RootComponent