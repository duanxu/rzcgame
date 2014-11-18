--队数
TEAM_NUM = 1

--一队的行数
ROW_NUM = 5

--一队的列数
COL_NUM = 4

--队与队之间 间距

TEAM_SPACING = 50

--左边下角第一个兵的位置
FIRST_POS_X = 100
FIRST_POS_Y = 100

--兵之间位置的变化
SPACING_ROW_X = 20
SPACING_ROW_Y = 0

SPACING_COL_X = 10
SPACING_COL_Y = 55

--左面集团
Group1 = {
    type = 1, --集团 1左 2右
    team1 = { --（从左面数）
        row = 5,
        col =4,
        type = 1 ,       --1:近 2：远1 3：远2 4骑
        leader= {
            code = 2,
            pos = 1,    --位置 1:前 2：后
            name = "tauren", -- 动画名称
--            res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            playIndex = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkIndex = 1, -- 攻击动作索引
            skillIndex = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = -0.24, --缩放 负值代表翻转
            scaley = 0.24
        },
        soldier = {
            name = "tauren", -- 动画名称
--                res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            playIndex = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkIndex = 1, -- 攻击动作索引
            skillIndex = 1, --技能动画索引
            scalex = -0.24,
            scaley = 0.24
        }
        
    }
}

--右面集团
Group2 = {
    type = 1, 
    team1= { --（从右面面数）
        row = 5,
        col = 4,
        type = 1 ,        --1:近 2：远1 3：远2 4骑
        leader = {
            code = 1,
            pos = 1,    --位置 1:前 2：后
            name = "tauren", -- 动画名称
--            res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            playIndex = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkIndex = 1, -- 攻击动作索引
            skillIndex = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            pos = 0,        --英雄位置 0：前 1：后
            scalex = 0.24,
            scaley = 0.24
        },
        soldier = {
            name = "tauren", -- 动画名称
--            res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            playIndex = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkIndex = 1, -- 攻击动作索引
            skillIndex = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = 0.24,
            scaley = 0.24
        }
    }
    
}

