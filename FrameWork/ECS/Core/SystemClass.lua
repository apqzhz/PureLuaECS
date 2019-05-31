
local function SystemClass(classname, ...)
    local cls = Class(classname, ...)
    cls.New = function(...)
        local instance
        --调用super的构造函数(如果super是 function 或者 native class)
        if cls.Create then
            instance = cls.Create(...)
        else
            instance = {}
        end
        
        local copy = RecursiveCopy(cls)

        --为类实例添加__index元表
        if type(instance) ~= "userdata" then
            SetMetatableIndex(instance, copy)
            instance._class = copy
        end
    
        --递归查找可用的类构造函数(super是 lua class)
        local temp = instance 
        temp:Ctor()
        local requireComs = temp._requireComs
        while temp do
            temp = temp._curSuper
            if temp then
                temp:Ctor(requireComs,instance._className)
            end
        end

        return instance
    end
    
    return cls
end

SetGlobal("SystemClass",SystemClass)
