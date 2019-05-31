--引入全局加载函数
_G.importedModules = {}
_G.modulesPaths = {}


function SetGlobal(key,value)
    local strValue
    if type(value) ~= "string" then
        strValue = type(value)
    else
        strValue = value
    end
    --print(string.format( "SetGlobal:  key:%s / value:%s", key, strValue ))
    rawset(_G,key,value)
end


function GetGlobal(key)
    --print(string.format( "GetGlobal:  key: %s ", key))
    return rawget(_G,key)
end


function Using(modulePath,moduleName)
    if not moduleName then
        error("Using: moduleName cannot be nil")
    end

    if not modulesPaths[moduleName] then
        modulesPaths[moduleName] = modulePath
    else
        --确认没有重复的moduleName
        if modulesPaths[moduleName] ~= modulePath then
            error(string.format( "Using： %s has same value in cache",moduleName ))
        end
    end
end


function UsingNow(modulepath, modulename)
    if modulename and importedModules[modulename] then
        return importedModules[modulename]
    end

    --如果之前未加载过
    Using(modulepath, modulename)

    local table
    table = require(modulepath)	
    if type(table) ~= "table" then
        importedModules[modulename] = nil
        --error("can not find ModuleTable for path="..modulepath)
    else
        importedModules[modulename] = table 
        SetGlobal(modulename,table)
    end

    return table
end


--主函数入口
function Start()
    UsingNow("Setting.FrameworkModulePath","FrameworkModulePath")
    UsingNow("Setting.LogicModulePath","LogicModulePath")
end


gmetatable = {}
gmetatable.__index = function(gTable, key)
    local table = importedModules[key]
    print("find global var for key="..key)
    if not table then
        local path = modulesPaths[key]

        if path then
            table = require(path)	
            if type(table) ~= "table" then
                importedModules[key] = gTable[key]
                return gTable[key]
                --error("can not find Module for path="..path)
            else
                importedModules[key] = table 
                SetGlobal(key,table)
            end
        end
    end
    return table
end


gmetatable.__newindex = function(_,key,value)
    if key ~= "FrameWork" and key~="Logic" then 
        error("set global vairable directly is not allowed,please use SetGlobal instead!,key="..key)
    end
end

--防止逻辑代码随意写入_G
setmetatable(_G,gmetatable)


SetGlobal("Using",Using)
SetGlobal("UsingNow",UsingNow)
SetGlobal("SetGlobal",SetGlobal)
SetGlobal("GetGlobal",GetGlobal)

Start()
