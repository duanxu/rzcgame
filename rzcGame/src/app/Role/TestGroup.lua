local scrollview = require("framework.cc.ui.UIScrollView")

local Group = class("Group",function ()
	return display.newLayer()
end)
require("config.BattleConfig")
require("config.PlayConfig")
local scheduler = require("framework.scheduler")
local team = require("app.Role.Team")
local leaderY = {2,3,1,4,0}
local leaderX = {2,3,1,4,0}
function Group:ctor()
    --显示参数
    self.bg = nil
    self.bgSize = nil
    self.view = nil
    --逻辑参数
    self.type = nil
    self.zx = {{B=0,A=0},{B=0,A=0},{B=0,A=0},{B=0,A=0}}
end
function Group:init(data)
    self.type = data.type
    for num=1, TEAM_NUM do
    	local teamdata = data["team"..num]
    	if teamdata then
        	teamdata.row = ROW_NUM
        	teamdata.col = COL_NUM
            local t = team.new(teamdata)
            t:init()
            self:addTeam(t)
        else
            break
    	end
    end
end
function Group:create()
    if self.type == 1 then
       self:createLeft(data)
    else
        self:createRight(data)
    end
--    return self
end
function Group:addTeam(team)
    local zx = self.zx[team.type]
    zx[team.leader.pos] = zx[team.leader.pos]+1    
    zx[team.leader.code]=team
end

function Group:removeTeam(team)
    local zx = self.zx[team.type]
    zx[team.leader.pos] = zx[team.leader.pos]-1 
    zx[team.leader.code]=nil
end

function Group:createLeft()
    self.view = nil
    self:removeAllChildrenWithCleanup(false)
    local data = 
    {
        --阵位参数
        vx = 0,
        fpx = FIRST_POS_X,
        scx = SPACING_COL_X,
        srx = SPACING_ROW_X,
        ts = TEAM_SPACING,
        --背景参数
        
        bgx = 0,
        anchorx = 0,
        x = 0,
        y = 0
    }
    
    
    
    self:createPos(data)
end

function Group:createPos(data)
--    self:addChild(self.bg)
    local tex = self.bg:getTexture()
    local rect = cc.rect(data.bgx,0,tex:getContentSize().width/2,display.top)
    self:setContentSize(cc.size(tex:getContentSize().width/2 , display.top))
    local bg =cc.Sprite:createWithTexture(tex,rect,false)
    bg:setAnchorPoint(0,0)
    self:setAnchorPoint(0,0)
    self:setPosition(data.x,data.y)
    self:addChild(bg)
    

--    local view = scrollview:new()
--    view:setViewRect(cc.rect(data.vx,0,display.cx,display.top ))
----    view:setAnchorPoint(0,0)
----    view:setPosition(data.vpos)
--    view:addScrollNode(self)
--    view:setDirection(scrollview.DIRECTION_HORIZONTAL)
--    view:setBounceable(false)  -- 設置彈性效果
----    view:moveXY(-200,0)
--    self.view = view

    --初始化 兵的位置 添加到 layer里
    local fpx,scx,srx,ts = data.fpx,data.scx,data.srx,data.ts
    local armture = nil
    local xpos,ypos = fpx,FIRST_POS_Y
    local len = #self.zx
    for k=len, 1,-1 do
        local zz = self.zx[k]
        local num = table.nums(zz)-2
        local bnum = zz.B  --前排英雄数量
        local anum = zz.A -- 后排英雄数量
        if num >0 then
            local aposx = 0 --后排英雄x坐标
            local bposx = 0 --前排英雄x坐标
            local acurrentNum = 1 --后排英雄数量
            local bcurrentNum = 1 --前排英雄数量
            local isHaveA = 0 --是否有后排英雄 0 无
--            if anum>0 then
--                aposx = xpos+(leaderY[acurrentNum]-1)*srx
--                xpos = xpos+srx
--                isHaveA =1
--            end
            if bnum>0 then
                
                xpos=xpos+srx
            end
            local jtstartPosx = xpos --团队（整合算一个团队）开始坐标
            for key, value in pairs(zz) do
                if key ~= "A" and key~="B"  then
                    value.x = jtstartPosx
                    local soldierPos = 0
                    local leader = value.leader
                    local col_num = value.data.col
                    local row_num = value.data.row
                    if leader.pos == "A" then
                        leader.x = jtstartPosx-srx+leaderX[acurrentNum]*scx
                        leader.y = FIRST_POS_Y+SPACING_COL_Y*leaderY[acurrentNum]
                        acurrentNum = acurrentNum+1
--                    else
--                        leader.x = aposx
--                        leader.y = FIRST_POS_Y+SPACING_COL_Y*leaderY[acurrentNum]
--                        acurrentNum = acurrentNum+1
                        self:createArmature(leader.armture,leader.x,leader.y)
                    end
                    local soldiers = value.soldiers
                    for i=1, col_num do --列
                        local xxpos = xpos
                        local yypos = ypos
                        for j=1, row_num do --行
                            self:createArmature(soldiers["c"..i.."r"..j].armture,xxpos,yypos)
                            yypos = yypos+SPACING_COL_Y
                            xxpos = xxpos+scx
                            
                        end
                        xpos = xpos+srx
                        ypos = ypos+SPACING_ROW_Y
                    end
                    bposx = xpos
                    if leader.pos == "B" then
                        leader.x = jtstartPosx+(col_num*num)*srx+leaderX[bcurrentNum]*scx
                        leader.y = FIRST_POS_Y+SPACING_COL_Y*leaderY[bcurrentNum]
                        --                    else
                        --                        leader.x = aposx
                        --                        leader.y = FIRST_POS_Y+SPACING_COL_Y*leaderY[acurrentNum]
                        --                        acurrentNum = acurrentNum+1
                        self:createArmature(leader.armture,leader.x,leader.y)
                        print("leader",jtstartPosx,bcurrentNum,leaderY[bcurrentNum],leader.x,leader.y)
                        bcurrentNum = bcurrentNum+1
                    end
                end
            end
            
            if num>0 then
                if anum>0 then
                    xpos = xpos+srx
                end
                xpos = xpos+ts
            end
        end
    end
end

function Group:createRight(data)
    self.view = nil
    self:removeAllChildrenWithCleanup(false)
--    local width = self.bg:getTexture():getContentSize().width
    local tex = self.bg:getTexture()
    local data = 
        {
            vx = display.cx,
            fpx = tex:getContentSize().width/2-FIRST_POS_X,
            scx = -SPACING_COL_X,
            srx = -SPACING_ROW_X,
            ts= -TEAM_SPACING,
            
             --背景参数
        
            bgx = tex:getContentSize().width/2,
            anchorx = 0,
            x = CONFIG_SCREEN_WIDTH - tex:getContentSize().width/2,
            y = 0
        }

    self:createPos(data)
end

function Group:setBg(data)
    self.bg = nil
    self.bg = cc.Sprite:create(data)
    self.bgSize = self.bg:getTexture():getContentSize().width
end
function Group:setType(data)
    self.type = data
end
function Group:createArmature(armture,x,y)
    armture:setPosition(cc.p(x,y)) 
    self:addChild(armture)
  
end

function Group:playEnTer(data)
    local len = #self.zx
    data.spacetime = START_SOILDER_SPACE_TIME
    data.starttime = 0
    for k=len, 1,-1 do
        local zz = self.zx[k]
        for key, value in pairs(zz) do
            if key ~= "A" and key~="B"  then
                local localPosx =self:convertToWorldSpace(cc.p(value.x,0)).x
                if localPosx>0 and localPosx<display.right then
                    value:playEnTer(data)
                else
                    local handle = nil
                    handle = scheduler.scheduleUpdateGlobal(function (obj)
                        local localPosx =self:convertToWorldSpace(cc.p(value.x,0)).x
                        if localPosx>0 and localPosx<display.right then
                            scheduler.unscheduleGlobal(handle)
                            value:playEnTer(data)
                            scheduler.performWithDelayGlobal(function()
                               local scene = cc.Director:getInstance():getRunningScene()
                               scene:viewRound()
                            end,data.starttime+ROUND_TIME)
                         end    
                    end)
                end
            end
        end
    end
end
function Group:playByName(index)
    local teams = self.zx[index]
end
function Group:spliteScreen()
    local view = scrollview:new()
--    view:setAnchorPoint(0,0)
--    view:setPosition(data.vpos)
    self:removeFromParentAndCleanup(false)
    view:addScrollNode(self)
    view:setDirection(scrollview.DIRECTION_HORIZONTAL)
    view:setBounceable(false)  -- 設置彈性效果
--    view:moveXY(-200,0)
    self.view = view
    if self.type==1 then
        self:setPositionX(0)
        view:setViewRect(cc.rect(0,0,display.cx,display.top ))
    else
--        print("self.bg",self.bg:getTexture())
        self:setPositionX(-self.bgSize/2+display.right)
        view:setViewRect(cc.rect(display.cx,0,display.cx,display.top ))
    end
    return self.view
    
end

function Group:act(type,actname)
    local teams = self.zx[type]
    if teams then
        for key, value in pairs(teams) do
            if key~="A" and key~="B" then
                value:act(actname)
        	end
        end
    end
end
function Group:battle()
    
end
return Group