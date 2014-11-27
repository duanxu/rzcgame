
require("config.PlayConfig")
local group = require("app.Role.TestGroup")
local scheduler = require("framework.scheduler")
local BattleScene = class("BattleScene", function()
    return display.newScene("BattleScene")
end)

function BattleScene:ctor()
    self.round = 1
    self.bgsize=0
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
    
    
     --测试弓箭兵 攻击
--    groupleft:spliteScreen():addTo(self)
--    groupRight:spliteScreen():addTo(self)
    

end

function BattleScene:onEnter()
--    transition.moveBy(left,{x=-len+CONFIG_SCREEN_WIDTH,time=time})
--    transition.moveBy(right,{x=-len+CONFIG_SCREEN_WIDTH,time=time})
--    self.groupRight:playEnTer("run")
    local groupRight  = self.groupRight
    local groupleft  = self.groupLeft
    local len = groupRight.bgSize
    local time = PASS_ALL_TIME
    --入场场景动画开始
    transition.moveBy(groupleft,{x=-len+CONFIG_SCREEN_WIDTH,time=time})
    transition.moveBy(groupRight,{x=-len+CONFIG_SCREEN_WIDTH,time=time})
    --入场角色动画
    self.groupLeft:playEnTer({name="run",layer = self.groupLeft})
    self.groupRight:playEnTer({name="run",layer = self.groupRight})
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
    self.groupLeft:act(atkorder,actname)
    self.groupRight:act(atkorder,actname)
    if round+1<=#ATK_ORDER then
        self.round = round+1
    else
    	self.round = 0
    end
end

return BattleScene
