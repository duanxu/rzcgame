local BaseRole = class("BaseRole")

function BaseRole:play(data)
	self.armture:getAnimation():play(data.name,10,0)
end
function BaseRole:addEvent()
    
    
end

function BaseRole:initSuper(data)
    self.armture = ccs.Armature:create(data.name)
    self.armture:getArmatureData():retain()
    self.armture:setScaleX(data.scalex)
    self.armture:setScaleY(data.scaley)
    self.hp = data.hp
    self.hurt = data.hurt
    local aa =  ccs.MovementEventType.loopComplete
    function event(bone,param,originFrameIndex,currentFrameIndex)
        local b = loadstring("return" .. "{'fly',{'fly ax',1,1,100}}");
        local c = b()
        local old = bone:getDisplayRenderNode():convertToWorldSpaceAR(cc.p(0,0))
        local new = ccs.Armature:create("tauren(test02)")
        local sc = cc.Director:getInstance():getRunningScene()
        new:setScaleX(-0.24)
        sc:addChild(new,1)
        new:getAnimation():setSpeedScale(0.1)
        new:getAnimation():play(c[2][1],0,0)
        new:setPosition(old)
        local queue = transition.sequence({
            cc.EaseSineOut:create(cc.MoveBy:create(5, cc.p(350, 200))),
            cc.EaseSineIn:create(cc.MoveBy:create(5, cc.p(350, -200)))
        })
        new:runAction(queue)
    end
    self.armture:getAnimation():setFrameEventCallFunc(event)
end

return BaseRole