local LogicTeam = class("LogicTeam")
local soldier = require("app.Role.Soldier")
local leaderY = {2,3,1,4,0}
local leaderX = {2,3,1,4,0}
function LogicTeam:ctor(data)
    self.A = 0
    self.B = 0
    self.Aleaders = {}
    self.Bleaders = {}
    self.solders = {}
    self.num = 0 --总人数
    self.teamnum = 0 --队伍数量
    self.type = data.type
    self.data = nil -- 士兵数据
    self.group = nil
    self.x = 0  --真是坐标
    self.y = 0
    self.dx = 0 --显示坐标
end

function LogicTeam:add(team)
    local pos = team.leader.pos
    local leaders = self[pos.."leaders"]
    self[pos] = self[pos]+1
    self.teamnum = self.teamnum+1
    self.num = self.num+team:nums()
    if #leaders>0 then
    	for key, var in ipairs(leaders) do
            if var.leader.code>team.leader.code then
                table.insert(leaders,key,team)
                return
            end
        end
        table.insert(leaders,team)
    else
        leaders[1]=team
        self.data = team.data
    end
end

function LogicTeam:remove(team)
    local pos = team.leader.pos
    local leaders = self[pos.."leaders"]
    self[pos] = self[pos]-1
    self.teamnum = self.teamnum-1
    self.num = self.num-team:nums()
    for key, var in ipairs(leaders) do
        if var.leader.code==team.leader.code then
            table.remove(leaders,key)
            break
        end
    end
    
end
function LogicTeam:isAct()
    return self.teamnum>0
end

function LogicTeam:act(data)
    local aleader = self.Aleaders
    local bleader = self.Bleaders

    local solders = self.solders
    for key, var in pairs(solders) do
        var:play(data)
    end
    for key, var in ipairs(aleader) do
        var.leader:play(data)
    end
    for key, var in ipairs(bleader) do
        var.leader:play(data)
    end
    
end

function LogicTeam:prepareBattle(data)
    local xpos,ypos,scx,srx,ts,scy = data.fpx,data.fpy,data.scx,data.srx,data.ts,data.scy
    local num = self.teamnum
    local group = self.group
    local data = self.data
    local aleader = self.Aleaders
    local bleader = self.Bleaders
    
    local solders = self.solders
    local col = 1
    if num<=0 then
       return nil
    end
    
    --后排hero
    self.x = xpos
    for key, var in ipairs(aleader) do
        local leader = var.leader
        leader.x = xpos+leaderY[key]*scx
        leader.y = ypos+leaderY[key]*scy
        leader.group = group
        leader.logicT= self
        group:createArmature(leader)
    end
    if #aleader>0 then
        col = col+1
        xpos = xpos+srx
    end
    
    --士兵
    local col_num = data.col
    local row_num = data.row
    
    for var=1, num do
        for i=1, col_num do
            local yypos = ypos
            local xxpos = xpos
            for j=1, row_num do
                local so=soldier:new()
                so:init(data.soldier)
                so.x = xxpos
                so.y = yypos
                so.group = group
                so.logicT= self
                solders["c"..col.."r"..j]=so
                group:createArmature(so)
                xxpos = xxpos+scx
                yypos = yypos+scy
    		end
            col = col+1
            xpos = xpos+srx
    	end
    end  
    
    --前排hero
    for key, var in ipairs(bleader) do
        local leader = var.leader
        leader.x = xpos+leaderY[key]*scx
        leader.y = ypos+leaderY[key]*scy
        leader.group = group
        leader.logicT= self
        group:createArmature(leader)
    end
    if #bleader>0 then
        xpos = xpos+srx
    end
    return xpos
end

function LogicTeam:getAtkLen()
    --    local sCol,eCol,sRow,eRow,inc,x
    local type = self.data.type
    local center = display.cx
    local bgSize = self.group.bgSize/2
    --    if type == 1 then
    --        sCol,eCol,sRow,eRow,inc = 1,self.col,1,self.row,1
    --    else
    --        sCol,eCol,sRow,eRow,inc = self.col,1,self.row,1,-1
    --    end
    --    for j=sRow, eRow,inc do --行
    local so = self.soldiers["c"..self.col.."r"..self.row]
    if so then
        local ar = so.flyar
        local posx = ar:getPositionX()
        if type == 1 then
            return bgSize-posx,center-posx
        else
            return bgSize-CONFIG_SCREEN_WIDTH+posx,posx-center
        end
    end     
    --    end
end
function LogicTeam:getDefLen()
    --    local sCol,eCol,sRow,eRow,inc,x
    local x
    local type = self.data.type
    local center = display.cx
    local bgSize = self.group.bgSize/2
    --    if type == 1 then
    --        sCol,eCol,sRow,eRow,inc = 1,self.col,1,self.row,1
    --    else
    --        sCol,eCol,sRow,eRow,inc = self.col,1,self.row,1,-1
    --    end
    --    for j=sRow, eRow,inc do --行
    x= self.x
    if type == 1 then
        return bgSize-x,x
    else
        return x+bgSize-CONFIG_SCREEN_WIDTH
    end
    --    end
end

return LogicTeam