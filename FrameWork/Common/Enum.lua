local Enum = {}

--确保枚举内值不可更改
local function MakeEnumMetaTable(name, value, typeName)
	return {
			--__index = { _Value = value, _Name = name, _Type = type },
			_type = typeName,
			_name = name,
			_value = value,

			__index = function ()
				return value
			end,
			__newindex = function ()
				error("Cannot set fields in enum value", 2)
			end,
			__tostring = function ()
				return string.format('<%s: %d>', name,value)
			end,
			__le = function ()
				error("Unsupported operation")
			end,
			__lt = function ()
				error("Unsupported operation")
			end,
			__eq = function (this, other)
				return this.typeName == other.typeName and this._value == other._value
			end,
		}
end


--确保enum内key值为string且不重复
local function CheckEnumValue(values)
	local found = {}

	for _, v in ipairs(values) do
		if type(v) ~= "string" then
			error("Can create enum only from strings")
		end

		if found[v] == nil then
			found[v] = 1
		else
			found[v] = found[v] + 1
		end
	end

	local msg = "Attempted to reuse key: '%s'"
	for k, v in pairs(found) do
		if v > 1 then
			error(msg:format(k))
		end
	end
end


-- 通过一系列字符串创建一个新的枚举
-- @string name 枚举名，用来打印
-- @tparam {string} 字符串队列
-- @treturn  一个自动赋值的枚举表
function Enum.New (name, values)
	-- 自动赋值的表
	local newEnum = {}
	newEnum._enumType = name
	newEnum._count = 0

	local privateTable = {}
	local count = 0

	setmetatable(
		privateTable,
		{
			__index = function (t, k)
				local v = rawget(t, k)
				if v == nil then
					error("Invalid enum member: " .. k, 2)
				end
				return v
			end,
			-- __newindex = function (t, k, v)
			-- 	local o = {}
			-- 	setmetatable(o, MakeEnumMetaTable(k, v, name))
			-- 	t[k] = o
			-- end  
		}
	)

	if values ~= nil then
		CheckEnumValue(values)

		for _, str in ipairs(values) do
			privateTable[str] = newEnum._count
			newEnum._count = newEnum._count + 1
		end	
	end
				
	setmetatable(
		newEnum,
		{
			__index = privateTable,
			__newindex = function (enumTable, key, value)
				rawset(enumTable, key, enumTable._count + 1)
				enumTable._count = enumTable._count + 1
			end,
			__tostring = function ()
				return string.format("<enum '%s'>", name)
			end,
		}
	)
	return newEnum
end

SetGlobal("CheckEnumValue",CheckEnumValue)
return Enum



