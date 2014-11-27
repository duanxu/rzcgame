local BaseRole = class("BaseRole")

function BaseRole:play(data)
	self.armture:getAnimation():play(data.name,10,0)
end
function BaseRole:addEvent()
    
    
end

function BaseRole:initSuper(data)
--    local ar = ccs.Armature:create(data.name)
    self.armture = ccs.Armature:create(data.name)
--    self.armture:getArmatureData():retain()
    self.armture:setScaleX(data.scalex)
    self.armture:setScaleY(data.scaley)
    self.hp = data.hp
    self.hurt = data.hurt
    local aa =  ccs.MovementEventType.loopComplete
    function event(bone,param,originFrameIndex,currentFrameIndex)
        local b = loadstring("return" .. "{'fly',{'fly ax',1,1,100}}");
        local c = b()
        if c[1]=="fly" then
            local team = self.team
            local group = team.group
            local old = bone:getDisplayRenderNode():convertToWorldSpace(cc.p(0,0))
            local new = ccs.Armature:create("tauren(test02)")
            new:setPosition(old)
--            local queue = transition.sequence({
--                cc.EaseSineOut:create(cc.MoveBy:create(5, cc.p(350, 200))),
--                cc.EaseSineIn:create(cc.MoveBy:create(5, cc.p(350, -200)))
--            })
--            new:runAction(queue)
            local selfcode = self.code
            local data = {code=selfcode,param=c[2],ar=new}
            group:addFly(data)
            local code = "c"..team.col.."r"..team.row
            if code==selfcode then
                group:playFly()
            end
        end
    end
    self.armture:getAnimation():setFrameEventCallFunc(event)
end

return BaseRole