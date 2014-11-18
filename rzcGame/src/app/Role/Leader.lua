

local Leader = class("Leader")
function Leader:ctor()
    self.code = nil
    self.armture = nil
    self.hp = 0
    self.hurt = 0
    self.soldiersData = nil
    self.x = nil
    self.y = nil
end

function Leader:init(data)
    self.code = data.code
    self.armture = ccs.Armature:create(data.name)
    self.armture:setScaleX(data.scalex)
    self.armture:setScaleY(data.scaley)
    self.hp = data.hp
    self.hurt = data.hurt
end



return Leader