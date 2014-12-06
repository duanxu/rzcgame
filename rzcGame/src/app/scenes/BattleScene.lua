
require("config.PlayConfig")
local group = require("app.Role.TestGroup")
local scheduler = require("framework.scheduler")
local BattleScene = class("BattleScene", function()
    return display.newScene("BattleScene")
end)

function BattleScene:ctor()
    self.round = 1
    self.bgsize=0
    self.over = 0
--    local armname = "data/tauren/tauren.csb"
--    local armature = "tauren"
    local bgname = "data/bg.png"
    local plists = FILE_PLIST
    local pngs = FILE_PNG
    local armnames = FILE_CSB
    --资源加载
    for i=1, #plists do
        display.addSpriteFrames(plists[i],pngs[i])
    end
    
    local manager = ccs.ArmatureDataManager:getInstance();
    for i=1, #armnames do
        manager:removeArmatureFileInfo(armnames[i])
        manager:addArmatureFileInfo(armnames[i])
    end
    --初始化阵型
    local groupleft  = group:new()
    groupleft:init(Group1)
    groupleft:setBg(bgname)
    groupleft:create()
    self:addChild(groupleft)
    self.groupLeft = groupleft
    
    local groupRight  = group:new()
    groupRight:init(Group2)
    groupRight:setBg(bgname)
    local len = groupRight.bgSize
    self.bgsize = len
    groupRight:create()
--    transition.moveBy(right,{x=500,time=1})
--    local len = groupRight.bg:getTexture():getContentSize().width
    
    groupRight:setPosition(cc.p(len/2,0))
    self:addChild(groupRight)
    self.groupRight = groupRight
    groupleft:setFaceToGroup(groupRight)
    groupRight:setFaceToGroup(groupleft)
    
    
    

end

function BattleScene:onEnter()
    local groupRight  = self.groupRight
    local groupleft  = self.groupLeft
    groupleft.screen = self
    groupRight.screen = self
    
    --[[    --测试弓箭兵 攻击 ]]-- 
    groupleft:spliteScreen():addTo(self)
    groupRight:spliteScreen():addTo(self)
    self:roundAtk()


--    local len = groupRight.bgSize/2
--    local pts = PASS_TEAM_SPEED
--    local pcs = PASS_CENTER_SPEED
--    local ptsl = groupleft.x
--    local ptsr = groupRight.x
--    
--    local ptsllen = ptsl    --摄像机通过左部队的距离
--    local ptstime = ptsl/PASS_TEAM_SPEED
--    local ptsrlen = len-groupRight.x --摄像机通过右部队的距离
--    local ptsrtime = ptsrlen/PASS_TEAM_SPEED
--    
--    local centerLen = 2*len - ptsllen -ptsrlen-CONFIG_SCREEN_WIDTH
--    local centertime = centerLen/PASS_CENTER_SPEED
--    
--    local action1 = cc.Sequence:create({
--                        cc.MoveBy:create(ptstime,cc.p(-ptsllen,0)),
--                        cc.MoveBy:create(centertime,cc.p(-centerLen,0)),
--                        cc.MoveBy:create(ptsrtime,cc.p(-ptsrlen,0))
--                    })
--    local action2 = cc.Sequence:create({
--                        cc.MoveBy:create(ptstime,cc.p(-ptsllen,0)),
--                        cc.MoveBy:create(centertime,cc.p(-centerLen,0)),
--                        cc.MoveBy:create(ptsrtime,cc.p(-ptsrlen,0))
--                    })
--    --入场场景动画开始
--    groupleft:runAction(action1)
--    groupRight:runAction(action2)
--    --入场角色动画
--    groupleft:playEnTer({name="run",layer = self.groupLeft})
--    groupRight:playEnTer({name="run",layer = self.groupRight})
end

function BattleScene:onExit()
end

function BattleScene:viewRound()
    local len = self.bgsize/2
    self.groupLeft:setPositionX(-len+display.cx)
    self.groupRight:setPositionX(display.cx)
    display.newTTFLabel({
        text = "第一回合",
        font = "Marker Felt",
        size = 64,
        align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
    }):addTo(self):setPosition(cc.p(display.cx,display.cy))
    
    scheduler.performWithDelayGlobal(function()
        self.groupLeft:spliteScreen():addTo(self)
        self.groupRight:spliteScreen():addTo(self)
        scheduler.performWithDelayGlobal(function()
            self:roundAtk()
        end,ATK_TIME)
    end,SPLITE_SCREEN_TIME)
end

function BattleScene:roundAtk()
    local round = self.round
    local atkorder = ATK_ORDER[round]
    local actname = ATK_ACT[round]
    local data = {name=actname}
    self.groupLeft:act(atkorder,data)
    self.groupRight:act(atkorder,data)
    if round+1<=#ATK_ORDER then
        self.round = round+1
    else
    	self.round = 1
    end
end
function BattleScene:delover()
    self.over = self.over-1
    if self.over ==0 then
        self:roundAtk()
    end
end

function BattleScene:addover()
    self.over = self.over+1
end

return BattleScene
