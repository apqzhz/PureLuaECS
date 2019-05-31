local PartialClassCache = {}

local function PartialClass(newTable, oldClassName)
    if type(newTable) ~= "table" then
        error("Cannot set this noneTable class as partial class")
        return
    end

    local class = nil
    class = PartialClassCache[oldClassName]
    local needCtor = false

    --如果_G上已经存在这个类，则将新类中的值都赋值进去
    if class and not newTable._isClass then
        needCtor = false
                                                     --如果_G上已经存在这个类,不允许新类是class类型，只能是table类型
    elseif class and newTable._isClass then
        --error("PartialClass: oldClass exist, newTable must be table!!")
        needCtor = false
    --如果新类是个class且_G上不存在同名类，说明是首次创建
    elseif not class and newTable._isClass then
        needCtor = true
    else
        error("PartialClass: new or old table must has one class type!!")
    end

    if needCtor == false then
        for k, v in pairs(newTable) do
            if class[k] then
                print(string.format("PartialClass() \"%s\" : duplicate member variables %s!!", newTable._className, k))
            else
                rawset(class, k, v)
            end       
        end
        return class
    else
        PartialClassCache[newTable._className] = newTable
        return newTable
    end
end

SetGlobal("PartialClass",PartialClass)
SetGlobal("PartialClassCache",PartialClassCache)