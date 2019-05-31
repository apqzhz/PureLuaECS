
local BaseComponent = Class("BaseComponent")

BaseComponent._retainCount = 0


function BaseComponent:Ctor()
    --注册自身到全局的类型表中
    ComponentType.AddType(self._className, self)
end

--ToBe override
function BaseComponent:Clear()
end


function BaseComponent:Retain()
    self._retainCount = self._retainCount - 1
end


function BaseComponent:Release()
    self._retainCount = self._retainCount + 1
end


return BaseComponent