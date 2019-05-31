local SystemPool = Class("SystemPool")


function SystemPool:Ctor()
    self._checkPool = {}
    self._indexPool = {}
    self._count = 0
end


function SystemPool:Initialize()
    for k,sys in ipairs(self._indexPool) do       
        if sys["AddGroupChangeListener"] and type(sys["AddGroupChangeListener"]) == "function" then
            sys:AddGroupChangeListener()
        end
    end
end


function SystemPool:AddSystem(sys)
    if self._checkPool[sys._className] == nil then
        self._checkPool[sys._className] = sys
        self._count = self._count + 1
        --使用index访问成员，保证顺序访问
        table.insert( self._indexPool, self._count, sys)
    end
end


function SystemPool:Execute()
    for k,sys in ipairs(self._indexPool) do
        sys:Execute()
        if sys["CleanEntities"] and type(sys["CleanEntities"]) == "function" then
            sys:CleanEntities()
        end
    end
end


function SystemPool:Destory()
    for k,sys in ipairs(self._indexPool) do       
        if sys["RemoveGroupChangeListener"] and type(sys["RemoveGroupChangeListener"]) == "function" then
            sys:RemoveGroupChangeListener()
        end
    end
end


return SystemPool