
require("config")
require("framework.init")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    self:enterScene("MainScene")
end

function MyApp:enterBattleScene()
    self:enterScene("BattleScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

return MyApp
