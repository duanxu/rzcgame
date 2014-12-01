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
    self.ccol = {} --每行列数，战斗时使用
    self.group = nil
end

function Team:init()
    local row = self.data.row
    local col = self.data.col
    self.col = col
    self.row = row
    local ccol = {}
    for var=1, row do
         ccol[var]= col
    end
    self.ccol = ccol
    local leader = leader:new()
    self.leader = leader
    self.leader:init(self.data.leader)
    local soldiers = self.soldiers
    self.type = self.data.type
--    for col=1, self.col do
--    	for row=1,self.row do
--            local so=soldier:new()
--            local code = "c"..col.."r"..row
--            so.code = code
--            so.team = self
--            so:init(self.data.soldier)
--            soldiers[code] = so
--    	end
--    end
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
        self.leader:play(data)    
    end,longtime)
--    play(self.leader)  
      
    
    local soldiers = self.soldiers
    for i=sCol, eCol,inc do --列
        for j=sRow, eRow,inc do --行
--            sched(play(soldiers["c"..i.."r"..j]),starttime+spacetime*time)
            sched(function ()
        soldiers["c"..i.."r"..j]:play(data)    
    end,starttime+spacetime*time)
            spacetime=spacetime+1
        end
     end
    data.starttime = starttime+spacetime*time
end

function Team:act(actname)
    local soldiers = self.soldiers
    self.leader:play({name=actname})
    for key, value in pairs(soldiers) do
    	value:play({name=actname})
    end
end

function Team:nums()
    return self.row*self.col+1
end

return Team