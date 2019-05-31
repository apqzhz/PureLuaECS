local LoadModelSystem = SystemClass("LoadModelSystem",BaseSingleExecuteSys)


function LoadModelSystem:Ctor()
    self._requireComs = {MatchEnum.AllOf, ComponentEnum.Root}
end


function LoadModelSystem:OnExecuteOnce(entity)
    local loadCom = entity:LoadModelComponent()
    --调用unity接口加载模型
    --CS.UnityEngine.Resources.Load(loadCom._modelPath)
end


function LoadModelSystem:Destory()

end


return LoadModelSystem