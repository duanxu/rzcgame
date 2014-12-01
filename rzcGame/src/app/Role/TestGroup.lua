local scrollview = require("framework.cc.ui.UIScrollView")

local Group = class("Group",function ()
	return display.newLayer()
end)
require("config.BattleConfig")
require("config.PlayConfig")
local scheduler = require("framework.scheduler")
local team = require("app.Role.Team")
local logicTeam = require("app.Role.LogicTeam")
function Group:ctor()
    --显示参数
    self.bg = nil
    self.bgSize = nil
    self.view = nil
    --逻辑参数
    self.type = nil
    self.zx = {}
    --飞行道具容器
    self.flys = {}
    self.faceToGroup = nil
    --正在攻击队伍（用于远程飞行攻击定位，不包括平射）
    self.atkTeam = nil
end
function Group:init(data)
    self.type = data.type
    for var=1, 4 do
        local logicT = logicTeam:new(data)
        logicT.group = self
        self.zx[var]=logicT
    end
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
      team.group =self
      self.zx[team.type]:add(team)
end

function Group:removeTeam(team)
    self.zx[team.type]:remove(team)
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


    --初始化 兵的位置 添加到 layer里
    data.fpy = FIRST_POS_Y
    data.scy = SPACING_COL_Y
    local len = #self.zx
    for k=len, 1,-1 do
        local logicT = self.zx[k]
        local xpos = logicT:prepareBattle(data)
        if xpos then
        	data.fpx = xpos
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
function Group:createArmature(obj)
    local armture = obj.armture
    armture:setPosition(cc.p(obj.x,obj.y)) 
    self:addChild(armture)
  
end

function Group:playEnTer(data)
    local len = #self.zx
    data.spacetime = START_SOILDER_SPACE_TIME
    data.starttime = 0
    for k=len, 1,-1 do
        local zz = self.zx[k]
        for key, value in ipairs(zz) do
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
    local logicT = self.zx[type] 
    if logicT:isAct() then
        self.atkTeam = logicT
        logicT:act(actname)
    else
        self.view:scrollTo(display.cx,0)
    end
end
function Group:addFly(data)
    local flys = self.flys
    flys[#flys+1]=data
    local logicT = data.logicT
    if #flys == logicT.num then
    	self:playFly()
    end
end
function Group:playFly()

    local faceToGroup = self.faceToGroup
    local flys = self.flys
    local defOrder = DEF_ORDER
    local speed = ARROW_SPEED
    local horizontal = ARROW_HORIZONTAL
    local hight = ARROW_HIGHT
    local row_num = ROW_NUM
    local col_num = COL_NUM
    local def_len = DEF_TO_CENTER_LEN
    local row_x = SPACING_ROW_X
    local col_x = SPACING_COL_X
    local defteam = nil
    for key, var in ipairs(defOrder) do
    	local zxgroup = faceToGroup.zx[var]
        if zxgroup:isAct() then
            defteam = zxgroup
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
    local stime = slen/speed             --屏幕滚动时间
    local facelen = facetolen-def_len   --对面屏幕滚动距离
    local canlen = self.bgSize/2-display.cx
    local flag = false
    local inc = 0
    if facelen>canlen then
        inc = facelen-canlen
    	facelen = canlen
    	flag = true
    end
    local faceStime = facelen/speed -- 对面屏幕滚动时间
    
 
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
                cc.MoveBy:create(faceStime,{x=(facelen)*fx})
                })
            faceLay:runAction(act)
            print("faceLay:runAction")
        end
    end
    for key, var in ipairs(flys) do
        local row,col = var.row,var.col
        local olen = 2*(row_num-row)*col_x--每个校正位置
        local result = len+facetolen+ olen  --飞行总距离
        local time = result/speed           --飞行总时间
        local htime = horizontal/speed      --水平飞行时间(策划需求)
        local vtime = (time-htime)/2        --上升(下降)消耗的时间
        local vlen = (result-horizontal)/2  --上升(下降)过程水平距离
        local passlen = dtoClen+atoClen     --通过屏幕子飞行距离
        local passTime = passlen/speed      --通过屏幕中心时间
        olen = facetolen-dtoClen-facelen+olen
        local otime = olen/speed
        
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
                    cc.MoveBy:create(htime,{x=horizontal*fx}), 
                    transition.create(cc.MoveBy:create(vtime,{y=-hight}),{easing=ARROW_ACTION_DOWN})
                }),
                transition.sequence({
                    cc.DelayTime:create(stime),
                    cc.MoveBy:create(passTime,{x=passlen*fx*-1}),
                    cc.CallFunc:create(face),
                    cc.DelayTime:create(faceStime),
                    cc.MoveBy:create(otime,{x=olen*fx*-1})
                })
            )
        )
        
    end
   
    print("playFly")
end
function Group:createAllIndex(obj)
	return obj.gc.."_"..obj.row
end
function Group:battle()
    
end
return Group