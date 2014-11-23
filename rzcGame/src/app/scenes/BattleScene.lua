
require("config.PlayConfig")
local group = require("app.Role.TestGroup")
local scheduler = require("framework.scheduler")
local BattleScene = class("BattleScene", function()
    return display.newScene("BattleScene")
end)

function BattleScene:ctor()
    self.round = 1
    self.bgsize=0
    local armname = "data/tauren/tauren.csb"
    local armature = "tauren"
    local bgname = "data/bg.png"
    local plists = FILE_PLIST
    local pngs = FILE_PNG
    local armnames = FILE_CSB
    
    for i=1, #plists do
        display.addSpriteFrames(plists[i],pngs[i])
    end
    
    local manager = ccs.ArmatureDataManager:getInstance();
    for i=1, #armnames do
        manager:removeArmatureFileInfo(armnames[i])
        manager:addArmatureFileInfo(armnames[i])
    end
    
--    local armname = "data/Hero/Hero.csb"
--    manager:removeArmatureFileInfo(armname)
--    manager:addArmatureFileInfo(armname)
    local aa =  ccs.Armature:create(armature)
    local groupleft  = group:new()
    groupleft:init(Group1)
    groupleft:setBg(bgname)
    groupleft:create()
    self:addChild(groupleft)
    self.groupLeft = groupleft
    
    local groupRight  = group:new()
    groupRight:init(Group2)
    groupRight:setBg(bgname)
    self.bgsize = groupRight.bgSize
    groupRight:create()
--    transition.moveBy(right,{x=500,time=1})
    local len = groupRight.bg:getTexture():getContentSize().width
    
    groupRight:setPosition(cc.p(len/2,0))
    local time = PASS_ALL_TIME
    transition.moveBy(groupleft,{x=-len+CONFIG_SCREEN_WIDTH,time=time})
    transition.moveBy(groupRight,{x=-len+CONFIG_SCREEN_WIDTH,time=time})
    self:addChild(groupRight)
    self.groupRight = groupRight
--    local time = 0
--    local function update(dt)
--        time = time + 1
--        
--    end
--
--    scheduler.scheduleUpdateGlobal(update)
end

function BattleScene:onEnter()
--    transition.moveBy(left,{x=-len+CONFIG_SCREEN_WIDTH,time=time})
--    transition.moveBy(right,{x=-len+CONFIG_SCREEN_WIDTH,time=time})
    self.groupLeft:playEnTer({name="run",layer = self.groupLeft})
    self.groupRight:playEnTer({name="run",layer = self.groupRight})
--    self.groupRight:playEnTer("run")
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
            self.groupLeft:battle()
            self.groupRight:battle()
        end,ATK_TIME)
    end,SPLITE_SCREEN_TIME)
end

return BattleScene
