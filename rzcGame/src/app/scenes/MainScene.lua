
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    
end

function MainScene:onEnter()
    app:enterBattleScene()
end

function MainScene:onExit()
end

return MainScene
