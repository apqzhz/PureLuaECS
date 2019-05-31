local World = Class("World")


function World:Ctor()
    self._componentPool = ComponentPool.New()
    self._entityPool = EntityPool.New()
    self._logicSystemPool = SystemPool.New()
    self._renderSystemPool = SystemPool.New()

    --世界启动总时长
    self._worldTime = 0
    --当前帧时间间隔
    self._intervalTime = 0
    --时间比例
    self._timeScale = 1
    --世界当前帧数
    self._frameIndex = 0
    --世界对象父节点
    self._worldRoot = nil
end


function World:Initialize()
    print("======================Initialize Lua World")
    self:InitSystems()
    self._logicSystemPool:Initialize()
    self._renderSystemPool:Initialize()
end


function World:InitSystems()
    --Logic
    self._logicSystemPool:AddSystem(MoveSystem.New())
    --Render
    self._renderSystemPool:AddSystem(LoadModelSystem.New())
end


function World:Update(deltaTime)
    self._frameIndex = self._frameIndex + 1
    self._worldTime = self._worldTime + deltaTime
    self._intervalTime = deltaTime
    self._logicSystemPool:Execute()
    self._renderSystemPool:Execute()
end


function World:CreateEntity()
    local e =  self._entityPool:GetEntity()
    e:CreateRoot("entity_"..e._entityId)
    return e
end


function World:FindEntity(id)
    return self._entityPool:CheckEntity(id)
end


function World:DestroyEntity(entity)
    entity:RemoveAllComponents()
    self._entityPool:RemoveEntity(entity)
end


function World:SetWorldRoot(root)
    self._worldRoot = root
end


World.Instance =  World.New()

--For C# call lua
World.GetInstance = function()
    return World.Instance
end

return World