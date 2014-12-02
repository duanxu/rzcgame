require("config/BattleConfig")
local BaseRole = class("BaseRole")

function BaseRole:play(data)
	self.armture:getAnimation():play(data.name,10,0)
end
function BaseRole:addEvent()
    
    
end

function BaseRole:initSuper(data)
--    local ar = ccs.Armature:create(data.name)
    self.armture = ccs.Armature:create(data.name)
    self.armture:setScaleX(data.scalex)
    self.armture:setScaleY(data.scaley)
    self.hp = data.hp
    self.hurt = data.hurt
--    local team = self.team
    
--    local code = "c"..team.col.."r"..team.row
    function event(bone,param,originFrameIndex,currentFrameIndex)
        local b = loadstring("return" .. param);
        local c = b()
        if c[1]=="fly" then
            local old = bone:getDisplayRenderNode():convertToWorldSpaceAR(cc.p(0,0))
            local oldA = bone:getArmature():convertToWorldSpaceAR(cc.p(0,0))
--            local old = bone:getDisplayRenderNode():getNodeToWorldTransformAR()
            local new = ccs.Armature:create(c[2][1])
            new:setPosition(old)
--            local queue = transition.sequence({
--                cc.EaseSineOut:create(cc.MoveBy:create(5, cc.p(350, 200))),
--                cc.EaseSineIn:create(cc.MoveBy:create(5, cc.p(350, -200)))
--            })
--            new:runAction(queue)
            local row = self.row
            local col = self.col
            local logicT = self.logicT
            logicT.dx = old.x - oldA.x
            local data = {param=c[2],ar=new,row=row,col=col,src=self,logicT = logicT}
            self.group:addFly(data)
        end
    end
    self.armture:getAnimation():setFrameEventCallFunc(event)
end

function BaseRole:subHp(value)
    local hp = self.hp
    if hp>0 then
    	hp = hp -value
        return hp
    end
    return 0
end
return BaseRole