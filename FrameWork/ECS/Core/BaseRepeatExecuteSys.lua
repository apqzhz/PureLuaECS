local BaseRepeatExecuteSys = Class("BaseRepeatExecuteSys",BaseSystem)


function BaseRepeatExecuteSys:Ctor(requireComs)
    print("=================BaseRepeatExecuteSys:Ctor=============")
end


function BaseRepeatExecuteSys:Execute()
    local entities = self._group:GetEntities()
    for id,entity in IpairsSparse(entities) do
        self:OnExecute(entity)
    end
end


--Tobe override
function BaseRepeatExecuteSys:OnExecute(entity)

end



return BaseRepeatExecuteSys