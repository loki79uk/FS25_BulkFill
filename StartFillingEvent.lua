StartFillingEvent = {}
StartFillingEvent_mt = Class(StartFillingEvent, Event)
InitEventClass(StartFillingEvent, "StartFillingEvent")

function StartFillingEvent.emptyNew()
	local self = Event.new(StartFillingEvent_mt)
	return self
end

function StartFillingEvent.new(object, pallet)
	local self = StartFillingEvent.emptyNew()
	self.object = object
	self.pallet = pallet
	return self
end

function StartFillingEvent:readStream(streamId, connection)
	if not connection:getIsServer() then
		self.object = NetworkUtil.readNodeObject(streamId)
		self.pallet = NetworkUtil.readNodeObject(streamId)
		local dataAvailable = streamReadBool(streamId)
		if dataAvailable then
			self.object.spec_bulkFill.isFilling = streamReadBool(streamId)
			self.object.spec_bulkFill.selectedIndex = streamReadInt32(streamId)
		end
	end
	self:run(connection)
end

function StartFillingEvent:writeStream(streamId, connection)
	if connection:getIsServer() then
		NetworkUtil.writeNodeObject(streamId, self.object)
		NetworkUtil.writeNodeObject(streamId, self.pallet)
		if self.object.spec_bulkFill~=nil then
			streamWriteBool(streamId, true)
			streamWriteBool(streamId, self.object.spec_bulkFill.isFilling)
			streamWriteInt32(streamId, self.object.spec_bulkFill.selectedIndex)
		else
			streamWriteBool(streamId, false)
		end
	end
end

function StartFillingEvent:run(connection)
	if not connection:getIsServer() then
		--print("StartFillingEvent: server")
		if self.object~=nil and self.pallet ~=nil then
			self.object:startFilling(self.pallet, true)
		end
	else
		--print("StartFillingEvent: client")
		--self.object:startFilling(pallet, true)
	end
end