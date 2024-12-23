StopFillingEvent = {}
StopFillingEvent_mt = Class(StopFillingEvent, Event)
InitEventClass(StopFillingEvent, "StopFillingEvent")

function StopFillingEvent.emptyNew()
	local self = Event.new(StopFillingEvent_mt)
	return self
end

function StopFillingEvent.new(object)
	local self = StopFillingEvent.emptyNew()
	self.object = object
	return self
end

function StopFillingEvent:readStream(streamId, connection)
	if not connection:getIsServer() then
		self.object = NetworkUtil.readNodeObject(streamId)
		self.object.spec_bulkFill.isFilling = false
		self.object.spec_fillUnit.fillTrigger.currentTrigger = nil
	end
	self:run(connection)
end

function StopFillingEvent:writeStream(streamId, connection)
	if connection:getIsServer() then
		NetworkUtil.writeNodeObject(streamId, self.object)
	end
end

function StopFillingEvent:run(connection)
	if not connection:getIsServer() then
		--print("StopFillingEvent: server")
		self.object:stopFilling(true)
	else
		--print("StopFillingEvent: client")
		--self.object:stopFilling(true)
	end
end