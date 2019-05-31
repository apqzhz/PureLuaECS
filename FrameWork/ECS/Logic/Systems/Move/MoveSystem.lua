local MoveSystem = SystemClass("MoveSystem",BaseRepeatExecuteSys)


function MoveSystem:Ctor()
    self._requireComs = {MatchEnum.AllOf, ComponentEnum.Move, ComponentEnum.Root} 
end


function MoveSystem:OnExecute(entity)
    local moveCom = entity:MoveComponent()
    if moveCom._moveType == MoveEnum.MoveByDelta then
        --利用速度更改物体的位置
        --需要使用C#接口
        --local dir = (moveCom._destination - entity.Position).normalized
        --entity.Position = entity.Position + entity.Position * dir * World.Instance._intervalTime
    end
end


function MoveSystem:Destroy()

end


return MoveSystem