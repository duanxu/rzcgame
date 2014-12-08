local LogicTeam = class("LogicTeam")
local soldier = require("app.Role.Soldier")
local scheduler = require("framework.scheduler")
local leaderY = {2,3,1,4,0}
local leaderX = {3,4,2,5,1}
function LogicTeam:ctor(data)
    self.A = 0
    self.B = 0
    self.Aleaders = {}
    self.Bleaders = {}
    self.solders = {}
    self.num = 0 --总人数
    self.colmaxnum = nil --所有行最大人数
    self.teamnum = 0 --队伍数量
    self.type = data.type
    self.data = nil -- 队伍数据
    self.group = nil
    self.x = 0  --真是坐标
    self.y = 0
    self.dx = 0 --偏差坐标
    self.groupx = 0 --初始化时gourp的坐标
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

function LogicTeam:playEnTer(data)
    local lay = self.group
    local maxcol = self:getCurrentMaxCol()
    local row = self.data.row
    local soldiers = self.solders
    local starttime = data.starttime
    local time = data.spacetime
    local sched = scheduler.performWithDelayGlobal
    local sCol,eCol,sRow,eRow,inc
    local spacetime = 1
    if lay.type == 1 then
        sCol,eCol,sRow,eRow,inc = 1,maxcol,1,row,1
    else
        sCol,eCol,sRow,eRow,inc = maxcol,1,row,1,-1
    end
    
    for i=sCol, eCol,inc do --列
        for j=sRow, eRow,inc do --行
            --            sched(play(soldiers["c"..i.."r"..j]),starttime+spacetime*time)
            local so = soldiers["c"..i.."r"..j]
            if so then
                sched(function ()
                    so:play(data)    
                end,starttime+spacetime*time)
                spacetime=spacetime+1
            
            end
        end
    end
    return starttime+spacetime*time
end
function LogicTeam:prepareBattle(data)
    local xpos,ypos,scx,srx,ts,scy = data.fpx,data.fpy,data.scx,data.srx,data.ts,data.scy
    local num = self.teamnum
    if num<=0 then
       return nil
    end
    local group = self.group
    self.groupx = group:getPositionX()
    local data = self.data
    local aleader = self.Aleaders
    local bleader = self.Bleaders
    local maxcol = 0
    local solders = self.solders
    
    --后排hero
    for key, var in ipairs(aleader) do
        local leader = var.leader
        local row = leaderX[key]
        local col = maxcol+1
        leader.x = xpos+(row-1)*scx
        leader.y = ypos+(row-1)*scy
        leader.row = row
        leader.col = col
        leader.group = group
        leader.logicT= self
        solders["c"..col.."r"..row]=leader
        group:createArmature(leader)
--        print(maxcol,row,"leader",leader.x,leader.y)
    end
    if #aleader>0 then
        maxcol =maxcol+1
        xpos = xpos+srx
    end
    
    --士兵
    local col_num = data.col
    local row_num = data.row
    for var=1, num do
        for i=1, col_num do
            maxcol =maxcol+1
            local yypos = ypos
            local xxpos = xpos
            for j=1, row_num do
                local so=soldier:new()
                so:init(data.soldier)
                so.x = xxpos
                so.y = yypos
                so.group = group
                so.logicT= self
                so.row = j
                so.col = maxcol
                solders["c"..maxcol.."r"..j]=so
                group:createArmature(so)
                xxpos = xxpos+scx
                yypos = yypos+scy
--                print(maxcol,j,"so",so.x,so.y)
    		end
            xpos = xpos+srx
    	end
    end  
    
    --前排hero
    for key, var in ipairs(bleader) do
        local leader = var.leader
        local row = leaderX[key]
        local col = maxcol+1
        leader.x = xpos+(row-1)*scx
        leader.y = ypos+(row-1)*scy
        leader.row = row
        leader.col = col
        leader.group = group
        leader.logicT= self
        solders["c"..col.."r"..row]=leader
        group:createArmature(leader)
--        print(maxcol,row,"leader",leader.x,leader.y)
    end
    self.x = xpos+(row_num-1)*scx
    if #bleader>0 then
        maxcol =maxcol+1
        xpos = xpos+srx
    end
    self.colmaxnum = maxcol
    return xpos
end

function LogicTeam:getAtkLen(data)
    --    local sCol,eCol,sRow,eRow,inc,x
    local group = self.group
    local type = group.type
    local cgroupx = group:getPositionX()
    local groupx = self.groupx
    local center = display.cx
    local bgSize = self.group.bgSize/2
    local rownum = self.rownum
    local dx = self.dx
    local maxnum =self.colmaxnum --本队剩余最大列数
--    for key, var in ipairs(rownum) do
--    	if var>maxnum then
--    		maxnum = var
--    	end
--    end
    
    
    local canScroll = bgSize-center
    local posx = self.x+dx
    local sdx = cgroupx-groupx
    local atc = data
    local screenScorolLen = canScroll
    local sumx 
    if type == 1 then
        sumx = posx+data
        if sumx<center then
            atc = center-posx
        else
            screenScorolLen = canScroll+cgroupx
        end
        return bgSize-posx,screenScorolLen,atc,maxnum
    else
        sumx = posx-data
        if bgSize-sumx<center then
            atc = posx-center
        else
            screenScorolLen = canScroll-sdx
        end
        return posx,center-cgroupx,atc,maxnum
    end
    --    end
end
function LogicTeam:getDefLen(data)
    --    local sCol,eCol,sRow,eRow,inc,x
    local x
    local group = self.group
    local cgroupx = group:getPositionX()
    local groupx = self.groupx
    local type = self.group.type
    local center = display.cx
    local bgSize = self.group.bgSize/2
    x= self.x
    local canScroll = bgSize-center
    local screenScorolLen,dtc
    dtc = data
    local sumx 
    screenScorolLen = canScroll
    if type == 1 then
        sumx = x+data
        if sumx<center then
            dtc = center-x
        else
            screenScorolLen = canScroll-sumx+center
        end
        return bgSize-x,screenScorolLen,dtc
    else
        sumx =bgSize-x+data
        if sumx<center then
            dtc = x-center
        else
            screenScorolLen=x-data
        end
        return x,screenScorolLen,dtc
    end
    --    end
end
--获得当前最大列数
function LogicTeam:getCurrentMaxCol()
    return self.colmaxnum
end
--查找被攻击的所有兵和英雄

function LogicTeam:getAllDef(currentcol,maxcol)
    local len = maxcol-currentcol
    local colmaxnum = self.colmaxnum
    local cmaxcol = self:getCurrentMaxCol()
    local num= self.data.row
    local result = cmaxcol-len
    local s,e = cmaxcol,1
    local data = {}
    local solders = self.solders
    if result>0 then
        e=result
    end
    for i=s, e,-1 do
        currentcol=currentcol+1
        for j=1, num do
            data["c"..currentcol.."r"..j]=solders["c"..i.."r"..j]
    	end
    end
    return data,currentcol
end
function LogicTeam:arrange()
    local data = self.data
    local row_num = data.row
    local colmaxnum = self.colmaxnum
    local solders = self.solders
    local a = self.Aleaders
    local b = self.Bleaders
    local s,e
    if #a>0 then
    	s=2
    end
    if #b>0 then
        e=colmaxnum-1
    end
    local maxcol =0 
    for j=1, row_num do
        local num = 0
        for j=s, e do
            local so = solders["c"..i.."r"..j]
            if so.hp <= 0 then
                num =num+1
                local deso = table.remove(deathSo,1)
                local newP = deso.armture:getPosition()
                so.armture:setPosition(newP)
            end
    	end
    end    
end

return LogicTeam