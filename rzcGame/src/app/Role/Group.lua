local scrollview = require("framework.cc.ui.UIScrollView")

local Group = class("Group",function ()
	return display.newLayer()
end)
require("config.BattleConfig")
local team = require("app.Role.Team")
function Group:ctor()
    --显示参数
    self.bg = nil
    self.view = nil
    
    --逻辑参数
    self.type = nil
    self.zx = {{},{},{},{}}
end
function Group:init(data)
    self.type = data.type
    for num=1, TEAM_NUM do
    	local teamdata = data["team"..num]
    	if teamdata then
            local t = team.new(teamdata)
            t:init()
            self:addTeam(t)
        else
            break
    	end
    end
end
function Group:create()
    if self.type == 1 then
       self:createLeft(data)
    else
        self:createRight(data)
    end
    return self.view
end
function Group:addTeam(team)
    local zx = self.zx[team.type]
    zx[team.leader.code]=team
end

function Group:removeTeam(team)
    local zx = self.zx[team.type]
    zx[team.leader.code]=nil
end

function Group:createLeft()
    self.view = nil
    self:removeAllChildrenWithCleanup(false)
    local data = 
    {
        vpos = cc.p(0,0),
        fpx = FIRST_POS_X,
        scx = SPACING_COL_X,
        srx = SPACING_ROW_X
        
    }
    self:createPos(data)
end

function Group:createPos(data)
    
    local view = scrollview:new()
    --    scrollleft:setViewRect(cc.rect(0,0,CONFIG_SCREEN_WIDTH/2,CONFIG_SCREEN_HEIGHT ))
    view:setAnchorPoint(0,0)
    view:setPosition(data.vpos)
    view:addScrollNode(self)
    view:setDirection(scrollview.DIRECTION_HORIZONTAL)
    view:setBounceable(false)  -- 設置彈性效果
    self.view = view

    --初始化 兵的位置 添加到 layer里
    local fpx,scx,srx = data.fpx,data.scx,data.srx
    local armture = nil
    local xpos,ypos = fpx,FIRST_POS_Y
    local len = table.nums(self.zx)
    for k=len, 1,-1 do
        local zz = self.zx[k]
        local num = table.nums(zz)
        if num >0 then
            local leaders = {}
            for key, value in pairs(zz) do
                local soldierPos = 0
                leaders[#leaders+1] = value.leader
                local soldiers = value.soldiers
                for i=1, COL_NUM do --列
                    local xxpos = xpos
                    local yypos = ypos
                    for j=1, ROW_NUM do --行
                        self:createArmature(soldiers[(i-1)*ROW_NUM+j].armture,xxpos,yypos)
                        yypos = yypos+SPACING_COL_Y
                        xxpos = xxpos+scx
                    end
                end
                xpos = xpos+srx
                ypos = ypos+SPACING_ROW_Y

            end

        end
    end
end

function Group:createRight(data)
    self.view = nil
    self:removeAllChildrenWithCleanup(false)
--    local width = self.bg:getTexture():getContentSize().width
    local data = 
        {
            vpos = cc.p(0,0),
            fpx = CONFIG_SCREEN_WIDTH-FIRST_POS_X,
            scx = -SPACING_COL_X,
            srx = -SPACING_ROW_X

        }
    self:createPos(data)
end

function Group:setBg(data)
    self.bg = nil
    self.bg = cc.Sprite:create(data)
end
function Group:setType(data)
    self.type = data
end
function Group:createArmature(armture,x,y)
    armture:setPosition(cc.p(x,y)) 
    self:addChild(armture)
  
end
return Group