
local Stack = Class("Stack")

Stack._count = nil

function Stack:Ctor()
	self._stack = {}
	self._count = 0
end

function Stack:Push(data)
	table.insert(self._stack,data)
	self._count = self._count + 1
end

function Stack:Peek()
	if #self._stack == 0 then
		return nil
	end
	return self._stack[#self._stack]
end

function Stack:Pop()
	if #self._stack == 0 then
		return nil
	end
	self._count = self._count - 1
	return table.remove(self._stack,#self._stack)
end

function Stack:IsEmpty()
	return (#self._stack == 0)
end

function Stack:Clear()
	self._stack = {}
	self._count = 0
end

return Stack
