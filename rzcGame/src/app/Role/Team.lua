local Team = class("Team")
local leader = require("app.Role.Leader")
local soldier = require("app.Role.Soldier")
function Team:ctor(data)
    self.data = data
    self.row = nil
    self.col = nil
    self.type = nil
    self.leader = nil
    self.soldiers = {}
end

function Team:init()
    self.leader = leader:new()
    self.leader:init(self.data.leader)
    local soldiers = self.soldiers
    self.type = self.data.type
    self.row = self.data.row
    self.col = self.data.col
    for col=1, self.col do
    	
    	for row=1,self.row do
            local so=soldier:new()
            so:init(self.data.soldier)
            soldiers[(col-1)*self.row+row] = so
    	end
    end
end

return Team