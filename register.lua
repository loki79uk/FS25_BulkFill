-- ============================================================= --
-- BULK FILL MOD
-- ============================================================= --
bulkFillREGISTER = {}
g_specializationManager:addSpecialization('bulkFill', 'BulkFill', Utils.getFilename('BulkFill.lua', g_currentModDirectory), nil)

TypeManager.validateTypes = Utils.appendedFunction(TypeManager.validateTypes, function(self)
	if self.typeName == "vehicle" then
		for vehicleName, vehicleType in pairs(g_vehicleTypeManager.types) do
			if  SpecializationUtil.hasSpecialization(FillUnit, vehicleType.specializations) and
				SpecializationUtil.hasSpecialization(FillVolume, vehicleType.specializations) and
				SpecializationUtil.hasSpecialization(Cover, vehicleType.specializations)
			then
				g_vehicleTypeManager:addSpecialization(vehicleName, BulkFill.modName .. '.bulkFill')
			end
		end
	end
end)