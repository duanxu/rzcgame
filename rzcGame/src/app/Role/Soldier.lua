local Soldier = class("Soldier",function ()
    return require("app.Role.BaseRole").new()
end)

function Soldier:ctor()
    self.armture =nil
    self.x = nil
    self.y = nil
    self.hp = 0
    self.hurt = 0
end

function Soldier:init(data)
--    local aa = ccs.Armature:create(data.name)
--    aa:getArmatureData():retain()
    self.armture = ccs.Armature:create(data.name)
    self.armture:setScaleX(data.scalex)
    self.armture:setScaleY(data.scaley)
    self.hp = data.hp
    self.hurt = data.hurt
end

return Soldier