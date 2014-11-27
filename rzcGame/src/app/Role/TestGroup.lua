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
    --飞行道具容器
    self.flys = {}
    self.faceToGroup = nil
    --正在攻击队伍（用于远程飞行攻击定位，不包括平射）
    self.atkTeam = nil
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
function Group:setFaceToGroup(group)
	self.faceToGroup = group
end
function Group:create()
    if self.type == 1 then
       self:createLeft()
    else
        self:createRight()
    end
--    return self
end
function Group:addTeam(team)
    local zx = self.zx[team.type]
    team.group = self
    zx[team.leader.pos] = zx[team.leader.pos]+1    
    zx[team.leader.code]=team
end

function Group:removeTeam(team)
    local zx = self.zx[team.type]
    zx[team.leader.pos] = zx[team.leader.pos]-1 
    zx[team.leader.code]=nil
    team.group = nil
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
                            local so = soldiers["c"..i.."r"..j]
                            so.x = xxpos
                            self:createArmature(so.armture,xxpos,yypos)
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
    if table.nums(teams)>2 then
        self.atkTeam = teams[#teams]
        for key, value in pairs(teams) do
            if key~="A" and key~="B" then
                value:act(actname)
        	end
        end
    else
        self.view:scrollTo(display.cx,0)
    end
end
function Group:addFly(data)
    local flys = self.flys
    flys[#flys+1]=data
end
function Group:playFly()

    local faceToGroup = self.faceToGroup
    local flys = self.flys
    local defOrder = DEF_ORDER
    local speed = ARROW_SPEED
    local horizontal = ARROW_HORIZONTAL
    local hight = ARROW_HIGHT
    local defteam = nil
    for key, var in ipairs(defOrder) do
    	local zxgroup = faceToGroup.zx[var]
        if table.nums(zxgroup)>2 then
            local flag = false;
            for key1, var1 in pairs(zxgroup) do
        		if type(key1)=="number" then
        			defteam = var1
        			flag = true
        			break
        		end
        	end
        	if flag then
        		break
        	end
    	end
    end
    local scalx = ARROW_SCALE
    local fx = 1 --单位方向
    if self.type ==1 then
        fx = -1
    end
    local facetolen,dtoClen = defteam:getDefLen() --被攻击者到中心实际距离，被攻击者到屏幕中间显示距离
    local len,atoClen = self.atkTeam:getAtkLen()  --攻击者到中心实际距离，攻击者到屏幕中间显示距离
    local slen = self.bgSize/2-display.cx --屏幕滚动距离
    local result = len+facetolen        --飞行总距离
    local time = result/speed           --飞行总时间
    local htime = horizontal/speed      --水平飞行时间(策划需求)
    local vtime = (time-htime)/2        --上升(下降)消耗的时间
    local vlen = (result-horizontal)/2  --上升(下降)过程水平距离
    local stime = slen/speed             --屏幕滚动时间
    local passlen = dtoClen+atoClen     --通过屏幕子飞行距离
    local passTime = passlen/speed      --通过屏幕中心时间
    local faceStime = time-stime-passTime -- 对面屏幕滚动时间
    local lay = self.view:getScrollNode()
    local faceLay = faceToGroup.view:getScrollNode()
    local sc = cc.Director:getInstance():getRunningScene()
    lay:runAction(
        transition.sequence({
            cc.MoveBy:create(stime,{x=slen*fx})
        })
    )
    local function face()
        local size = faceLay:getNumberOfRunningActions()
        if size<=0 then
            local act = transition.sequence({
--                    cc.DelayTime:create(stime),
                    cc.MoveBy:create(faceStime,{x=(facetolen-dtoClen)*fx})
                })
            faceLay:runAction(act)
            print("faceLay:runAction")
        end
    end
    for key, var in ipairs(flys) do
        local ar = var.ar
        local c = var.param
        ar:setScaleX(scalx*fx)
        ar:getAnimation():setSpeedScale(1/time)
        ar:getAnimation():play(c[1],0,0)
        sc:addChild(ar,1)
        ar:runAction(
            cc.Spawn:create(
                transition.sequence({
                    transition.create(cc.MoveBy:create(vtime,{y=hight}),{easing=ARROW_ACTION_UP}),
                    transition.create(cc.MoveBy:create(time-vtime,{y=-hight}),{easing=ARROW_ACTION_DOWN})
                }),
                transition.sequence({
                    cc.DelayTime:create(stime),
                    cc.MoveBy:create(passTime,{x=passlen*fx*-1}),
                    cc.CallFunc:create(face)
                })
            )
        )
        
    end
   
    print("playFly")
end
function Group:battle()
    
end
return Group