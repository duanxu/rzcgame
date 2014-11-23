local Team = class("Team")
local leader = require("app.Role.Leader")
local soldier = require("app.Role.Soldier")
local scheduler = require("framework.scheduler")
function Team:ctor(data)
    self.data = data
    self.row = nil
    self.col = nil
    self.type = nil
    self.leader = nil
    self.soldiers = {}
    self.x=nil
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
            soldiers["c"..col.."r"..row] = so
    	end
    end
end
function Team:playEnTer(data)
      local time = data.spacetime
      local starttime = data.starttime
      local num = table.nums(self.soldiers)
      local lay = data.layer
      local sched = scheduler.performWithDelayGlobal
--      local col_num = self.col
--        local row_num = self.row
    local sCol,eCol,sRow,eRow,inc
    if lay.type == 1 then
        sCol,eCol,sRow,eRow,inc = 1,self.col,1,self.row,1
    else
        sCol,eCol,sRow,eRow,inc = self.col,1,self.row,1,-1
    end
      local longtime = 0
      local spacetime = 1
      if self.leader.pos == "A" then
        if lay.type == 2 then
            longtime=starttime+time*num
            spacetime=0
        end
      else
        if lay.type == 1 then
           longtime=starttime+time*num
            spacetime=0
        end
      end
    sched(function (obj)
        self.leader:playEnTer(data)    
    end,longtime)
--    play(self.leader)  
      
    
    local soldiers = self.soldiers
    for i=sCol, eCol,inc do --列
        for j=sRow, eRow,inc do --行
--            sched(play(soldiers["c"..i.."r"..j]),starttime+spacetime*time)
            sched(function ()
        soldiers["c"..i.."r"..j]:playEnTer(data)    
    end,starttime+spacetime*time)
            spacetime=spacetime+1
        end
     end
    data.starttime = starttime+spacetime*time
--    self.leader:playEnTer(data)
--    for key, value in pairs(self.soldiers) do
--        value:playEnTer(data)
--    end
    
--    local times = 0
--    local handler1 = nil
--    local leaderNum = nil
--    local incNum = 1 
--    local num = #self.soldiers
--    local lay = data.layer
--    if self.leader.pos == "A" then
--        if lay.type == 1 then
--    	   leaderNum = 0
--        else
--           leaderNum = #self.soldiers+1
--           num = leaderNum
--           times = num
--           incNum = -1
--        end
--    else
--        if lay.type == 1 then
--            times = 1
--            leaderNum = num+1
--            num = leaderNum
--        else
--            leaderNum = num+1
--            times = leaderNum
--            incNum = -1
--        end
--    end
----    local scheduler = cc.Director:getInstance():getScheduler()
--    handler1 = scheduler.performWithDelayGlobal(function ()
--            
----            print("lay:getPosition",lay:getPosition())
--            local pos = lay:convertToWorldSpace(cc.p(self.x,0))
--            if pos.x <= 0 or pos.x>display.right then
--            	return
--            end
--            if times == leaderNum then
--                self.leader:playEnTer(data)
--            else
--                self.soldiers[times]:playEnTer(data)    
--            end
--            times = times+incNum
--            if times>num or times<1 then
--                scheduler:unscheduleScriptEntry(handler1)
--            end
--    end,data.spacetime)
end

return Team