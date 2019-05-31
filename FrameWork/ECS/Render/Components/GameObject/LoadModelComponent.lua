local LoadModelComponent = ComponentClass("LoadModelComponent",ComponentEnum.LoadModel)



function LoadModelComponent:Ctor()
    self._modelPath = nil
end


function LoadModelComponent:Clear()
    self._modelPath = nil
end


return LoadModelComponent