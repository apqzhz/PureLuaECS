local Queue = Class("Queue")


function Queue:Ctor()
    self._queue = {}
    self._count = 0
end


function Queue:Push(data)
    table.insert(self._queue,1,data)
    self._count = self._count + 1
end


function Queue:Peek()
	if #self._queue == 0 then
		return nil
	end
	return self._queue[#self._queue]
end


function Queue:Pop()
	if #self._queue == 0 then
		return nil
    end
    self._count = self._count - 1
	return table.remove(self._queue,#self._queue)
end


function Queue:IsEmpty()
	return (#self._queue == 0)
end


function Queue:Contains(data)
    for index,v in ipairs(self._queue) do
        if v == data then
            return true, index
        end
    end
    return false
end


function Queue:Remove(data)
    local has, index = self:Contains(data)
    if has then
        table.remove(self._queue, index)
        self._count = self._count - 1
    end
end


function Queue:Clear()
    self._queue = {}
    self._count = 0
end


return Queue
