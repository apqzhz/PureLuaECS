local function Delegate()
    --初始化一个空函数对表
    --函数对格式{ “1” = classInstance, "2" =  function}
    return setmetatable({funcPair = {},
    add = function(self,funcPair)
        if self and funcPair then
            if type(funcPair) ~= "table" then
                error("Self, funcPair must be Table, got "..type(self)..", "..type(funcPair))
            end

            if type(funcPair[1]) ~= "table" then
                error("Self, Table expected, got "..type(self)..", "..type(funcPair[1]))
            end

            if type(funcPair[2]) ~= "function" then
                error("Self, Function expected, got "..type(self)..", "..type(funcPair[2]))
            end

            self.funcPair[#self.funcPair + 1] = funcPair
        else
            error("Self, Function expected, got "..type(self)..", "..type(funcPair[2]),2)
        end
        return self
    end,
    sub = function(self,funcPair)
        if self and funcPair then
            if type(funcPair) ~= "table" then
                error("Self, funcPair must be Table, got "..type(self)..", "..type(funcPair))
            end

            if type(funcPair[1]) ~= "table" then
                error("Self, Table expected, got "..type(self)..", "..type(funcPair[1]))
            end

            if type(funcPair[2]) ~= "function" then
                error("Self, Function expected, got "..type(self)..", "..type(funcPair[2]))
            end

            for i=1,#self.funcPair do
                local v = self.funcPair[i]
                --如果函数对中的class实例以及函数相等
                if v[1] == funcPair[1] and v[2] == funcPair[2] then
                    table.remove(self.funcPair,i)
                end
            end
        else
            error("Self, Function expected, got "..type(self)..", "..type(funcPair[2]),2)
        end
        return self
    end,
    --清空所有注册函数
    Clear = function(self)
        self.funcPair = {}
    end
    },   
    --设定函数表的增删方式,在调用函数对表时，同时调用所有表内函数
    {__call = function(tbl,...)
            if type(tbl.funcPair) == "table" then
                local c,r = 0,{}
                for k,v in pairs(tbl.funcPair) do
                    local classIns = v[1]
                    local func = v[2]
                    if type(func) == "function" then
                        c = c+1
                        if  type(classIns) == "table" then
                            r[c] = {pcall(func, classIns ,...)}
                        end
                    end
                end
                return c,r
            end
    end,
    __add = function(self, funcPair)
            return self:add(funcPair)
    end,   
    __sub = function(self, funcPair)
            return self:sub(funcPair)
    end,
})
end

local function Event(del)
    return {
        add = function(funcPair)
            del.funcPair[#del.funcPair+1] = func
        end,
        sub = function(funcPair)
            local limit = #del.funcPair
            for i=1,limit do
                if del.funcPair[i] == func then
                        table.remove(del.funcPair,i)
                end
            end                    
        end,
            }
end


SetGlobal("Delegate",Delegate)