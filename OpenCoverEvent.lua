OpenCoverEvent = {}
OpenCoverEvent_mt = Class(OpenCoverEvent, Event)
InitEventClass(OpenCoverEvent, "OpenCoverEvent")

function OpenCoverEvent.emptyNew()
	local self = Event.new(OpenCoverEvent_mt)
	return self
end

function OpenCoverEvent.new(myObject, myState)
	local self = OpenCoverEvent.emptyNew()
	self.object = myObject
	self.state = myState
	return self
end

function OpenCoverEvent:readStream(streamId, connection)
	if not connection:getIsServer() then
		self.object = NetworkUtil.readNodeObject(streamId)
		self.state = streamReadInt32(streamId)
	end
	self:run(connection)
end

function OpenCoverEvent:writeStream(streamId, connection)
	if connection:getIsServer() then
		NetworkUtil.writeNodeObject(streamId, self.object)
		streamWriteInt32(streamId, self.state)
	end
end

function OpenCoverEvent:run(connection)
	if not connection:getIsServer() then
		--print("OpenCoverEvent: server")
		self.object:openCover(self.state, true)
	else
		--print("OpenCoverEvent: client")
		--self.object:openCover(self.state, true)
	end
end