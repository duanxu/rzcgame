

local Leader = class("Leader",function ()
    return require("app.Role.BaseRole").new()
end)
function Leader:ctor()
    self.code = nil
--    self.armture = nil
--    self.hp = 0
--    self.hurt = 0
--    self.soldiersData = nil
--    self.x = nil
--    self.y = nil
    self.pos = nil --前排或后排
end

function Leader:init(data)
    self.code = data.code
    self.pos = data.pos
    self:initSuper(data)
end



return Leader