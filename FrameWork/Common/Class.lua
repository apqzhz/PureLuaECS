
--单继承的class实现
local function Class(classname, ...)
    local cls = {_className = classname, _isClass = true}

    local supers = {...}

    --不允许多继承
    if #supers >= 2 then
        error("Class can not has more than one parent!!")
    end

    --两个class可以对比
    local function equal(a, b)
        for k,v in pairs(a) do
            if b[k]~=v then return false end
            end
            for k,v in pairs(b) do
            if a[k]~=v then return false end
            end
        return true
    end

    local super = supers[1]

    --访问所有父类寻找成员
    if not supers or #supers == 1 then
        if super then
            setmetatable(cls, {__index = super,
            __eq = equal
            }
        )
        end
   
        local superType = type(super)
        assert(superType == "nil" or superType == "table" or superType == "function",
            string.format("class() - create class \"%s\" with invalid super class type \"%s\"",
                classname, superType))

        if superType == "function" then
            assert(cls.Create == nil,
                string.format("class() - create class \"%s\" with more than one creating function",
                    classname));
            -- 如果父类是函数,将其设给 __create(构造函数)
            cls.Create = super

        elseif superType == "table" then
            if super[".isNativeclass"] then
                -- 父类是原生class
                assert(cls.Create == nil,
                    string.format("class() - create class \"%s\" with more than one creating function or native class",
                        classname));
                cls.Create = function() return super:Create() end
            else
                -- 父类是 lua class
                local cursuper = rawget(cls, "_curSuper")
                --if super._isClass then
                if rawget(super, "_isClass") then
                    if not cursuper then
                        --将第一个lua class设为当前父类
                        --cls._curSuper = super
                        rawset(cls, "_curSuper", super)
                    end
                end
            end

        else
            error(string.format("class() - create class \"%s\" with invalid super type",
                        classname), 0)
        end
    end

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

        --查找可用的类构造函数(super是 lua class)
        local objWithCtor = FindNearestCtorObj(instance)
        if objWithCtor then
            objWithCtor.Ctor(instance,...)
        end

        return instance
    end

    return cls
end


local function SetMetatableIndex(t, index)
    if type(t) ~= "userdata" then
        local mt = getmetatable(t)
        if not mt then 
            mt = {} 
        end

        if not mt.__index then
            mt.__index = index
            setmetatable(t, mt)
        --如果元表中存在__index,则添加新的元表到旧的元表上
        elseif mt.__index ~= index then
            SetMetatableIndex_(mt, index)
        end
    end
end


local function FindNearestCtorObj(instance)
    local obj = nil
    local temp = instance 
    while temp do
        if temp.Ctor then
            obj = temp
            break
        end
        temp = temp._curSuper
    end
    return obj
end 



local function RecursiveCopy(object)
    local cacheTable = {}
    --循环拷贝
    local function DoCopy(orig)
        --值拷贝过程中，如果发现有同一个拷贝目标，直接使用缓存值
        if cacheTable[orig] then
            return cacheTable[orig]
        end

        local origType = type(orig)
        local copy
        if origType == "table" then
            copy = {}
            cacheTable[orig] = copy
            for origKey, origValue in next, orig, nil do
                copy[DoCopy(origKey)] = DoCopy(origValue)
            end
            local mt = getmetatable(orig)
            if mt then
                setmetatable(copy, DoCopy(mt))
            end      
        else -- number, string, boolean, etc
            copy = orig
        end
        return copy
    end
    return DoCopy(object)
end



SetGlobal("Class",Class)
SetGlobal("SetMetatableIndex",SetMetatableIndex)
SetGlobal("FindNearestCtorObj",FindNearestCtorObj)
SetGlobal("RecursiveCopy",RecursiveCopy)