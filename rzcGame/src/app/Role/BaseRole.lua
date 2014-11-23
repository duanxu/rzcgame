local BaseRole = class("BaseRole")

function BaseRole:playEnTer(data)
	self.armture:getAnimation():play(data.name,10,0)
end

return BaseRole