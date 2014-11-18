
require("res/config/BattleConfig")
local BattleScene = class("BattleScene", function()
    return display.newScene("BattleScene")
end)

function BattleScene:ctor()
--    cc.ui.UILabel.new({
--            UILabelType = 2, text = "Hello, World", size = 64})
--        :align(display.CENTER, display.cx, display.cy)
--        :addTo(self)
    local armname = "data/tauren/tauren.csb"
    local armature = "tauren"
    local layer1 = display.newLayer()
--    self:addChild(layer1)
    local param = {name=armature,scalex=-0.24,scaley=0.24,x=0,y=0,playIndex=1,parent = layer1}
    
    local scrollleft = cc.ui.UIScrollView:new()
--    scrollleft:setContentSize(cc.size(display.cx,display.cy))
    scrollleft:setViewRect(cc.rect(0,0,CONFIG_SCREEN_WIDTH/2,CONFIG_SCREEN_HEIGHT ))
    scrollleft:setAnchorPoint(0,1)
    scrollleft:setPosition(cc.p(0,0))
    scrollleft:addScrollNode(layer1)
    scrollleft:setDirection(scrollleft.DIRECTION_HORIZONTAL)
    scrollleft:setBounceable(false)  -- 設置彈性效果
    
    self:addChild(scrollleft)
    
    local scrollRight = cc.ui.UIScrollView:new()
    --    scrollleft:setContentSize(cc.size(display.cx,display.cy))
    scrollRight:setViewRect(cc.rect(CONFIG_SCREEN_WIDTH/2,0,CONFIG_SCREEN_WIDTH/2,CONFIG_SCREEN_HEIGHT ))
    scrollRight:setAnchorPoint(0,1)
    scrollRight:setPosition(cc.p(0,0))
    scrollRight:addScrollNode(layer1)
    scrollRight:setDirection(scrollleft.DIRECTION_HORIZONTAL)
    scrollRight:setBounceable(false)  -- 設置彈性效果

    self:addChild(scrollleft)
    
    local manager = ccs.ArmatureDataManager:getInstance();
--    local armname = "data/Hero/Hero.csb"
    manager:removeArmatureFileInfo(armname)
    manager:addArmatureFileInfo(armname)
    local xpos,ypos = FIRST_POS_X,FIRST_POS_Y
    local pa = clone(param)
    pa.x = xpos
    pa.y = ypos
    local armture = self:createArmature(pa)
    for t=1, TEAM_NUM do  --队伍
    
        for i=1, COL_NUM do --列
            pa.x = xpos
            pa.y = ypos
            armture = self:createArmature(pa)
            local xxpos = xpos
            local yypos = ypos
            for j=2, ROW_NUM do --行
                pa.x = xxpos
                pa.y = yypos
                armture = self:createArmature(pa)
                yypos = yypos-SPACING_COL_Y
                xxpos = xxpos-SPACING_COL_X
            end
            xpos = xpos+SPACING_ROW_X
            ypos = ypos+SPACING_ROW_Y
        end
        xpos = xpos+TEAM_SPACING
        
    end
    
--    local armture = ccs.Armature:create("tauren")
--    armture:setScaleX(-0.24)
--    armture:setScaleY(0.24)
--    armture:getAnimation():playWithIndex(0)
--    armture:setPosition(cc.p(display.cx,display.cy))
    
end

function BattleScene:createArmature(param)
    local armture = ccs.Armature:create(param.name)
    armture:setScaleX(param.scalex)
    armture:setScaleY(param.scaley)
    armture:getAnimation():playWithIndex(param.playIndex)
    armture:setPosition(cc.p(param.x,param.y))
    local parent = param.parent
    if parent~=nil then
    	parent:addChild(armture)
    else
        self:addChild(armture)
    end
end

function BattleScene:onEnter()
end

function BattleScene:onExit()
end

return BattleScene
