local Team = class("Team")
local leader = require("app.Role.Leader")
local soldier = require("app.Role.Soldier")
function Team:ctor(data)
    self.data = data
    self.type = nil
    self.leader = nil
    self.soldiers = {}
end

function Team:init()
    self.leader = leader:new()
    self.leader:init(self.data.leader)
    local soldiers = self.soldiers
    self.type = self.data.type
    for row=1, self.data.row do
    	
    	for col=1,self.data.col do
            local so=soldier:new()
            so:init(self.data.soldier)
            soldiers[#soldiers+1] = so
    	end
    end
end

return Team