--布阵所有需要的配置（临时使用，以后将被正式的数据文件替换）

--资源列表包括路径
FILE_PLIST = {"data/tauren0.plist"}
FILE_PNG = {"data/tauren0.png"}
--动画文件
FILE_CSB = {"data/tauren(test01).csb","data/tauren(test02).csb"}

--攻击顺序(team.type)
ATK_ORDER = {2,3,1,4}
ATK_ACT   = {"attack03","attack03","attack03","attack03"}   
DEF_ORDER = {2,3,4,1}

--队数
TEAM_NUM = 5

--一队的行数
ROW_NUM = 5

--一队的列数
COL_NUM = 4

--队与队之间 间距(是兵之间距离的几倍)

TEAM_SPACING = 2

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
            code = 2,   --唯一标示 集团内 不可重复
            pos = "A",    --位置 B:前 A：后
            name = "tauren(test01)", -- 动画名称
--            res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            actname = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkactname = 1, -- 攻击动作索引
            skillactname = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = -0.24, --缩放 负值代表翻转
            scaley = 0.24
        },
        soldier = {
            name = "tauren(test01)", -- 动画名称
--                res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            actname = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkactname = 1, -- 攻击动作索引
            skillactname = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = -0.24,
            scaley = 0.24
        }
        
    },
    team2 = { --（从左面数）
        row = 5,
        col =4,
        type = 1 ,       --1:近 2：远1 3：远2 4骑
        leader= {
            code = 3,   --唯一标示 集团内 不可重复
            pos = "A",    --位置 B:前 A：后
            name = "tauren(test01)", -- 动画名称
--            res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            actname = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkactname = 1, -- 攻击动作索引
            skillactname = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = -0.24, --缩放 负值代表翻转
            scaley = 0.24
        },
        soldier = {
            name = "tauren(test01)", -- 动画名称
--                res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            actname = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkactname = 1, -- 攻击动作索引
            skillactname = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = -0.24,
            scaley = 0.24
        }
        
    },
    team3 = { --（从左面数）
        row = 5,
        col =4,
        type = 3 ,       --1:近 2：远1 3：远2 4骑
        leader= {
            code = 6,   --唯一标示 集团内 不可重复
            pos = "B",    --位置 B:前 A：后
            name = "tauren(test01)", -- 动画名称
--            res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            actname = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkactname = 1, -- 攻击动作索引
            skillactname = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = -0.24, --缩放 负值代表翻转
            scaley = 0.24
        },
        soldier = {
            name = "tauren(test01)", -- 动画名称
--                res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            actname = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkactname = 1, -- 攻击动作索引
            skillactname = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = -0.24,
            scaley = 0.24
        }
        
    },
    team4 = { --（从左面数）
        row = 5,
        col =4,
        type = 4 ,       --1:近 2：远1 3：远2 4骑
        leader= {
            code = 7,   --唯一标示 集团内 不可重复
            pos = "B",    --位置 B:前 A：后
            name = "tauren(test01)", -- 动画名称
--            res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            actname = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkactname = 1, -- 攻击动作索引
            skillactname = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = -0.24, --缩放 负值代表翻转
            scaley = 0.24
        },
        soldier = {
            name = "tauren(test01)", -- 动画名称
--                res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            actname = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkactname = 1, -- 攻击动作索引
            skillactname = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = -0.24,
            scaley = 0.24
        }
        
    },
    team5 = { --（从左面数）
        row = 5,
        col =4,
        type = 4 ,       --1:近 2：远1 3：远2 4骑
        leader= {
            code = 7,   --唯一标示 集团内 不可重复
            pos = "B",    --位置 B:前 A：后
            name = "tauren(test01)", -- 动画名称
            --            res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            actname = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkactname = 1, -- 攻击动作索引
            skillactname = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = -0.24, --缩放 负值代表翻转
            scaley = 0.24
        },
        soldier = {
            name = "tauren(test01)", -- 动画名称
            --                res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            actname = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkactname = 1, -- 攻击动作索引
            skillactname = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = -0.24,
            scaley = 0.24
        }

    }
}

--右面集团
Group2 = {
    type = 2, 
    team1= { --（从右面面数）
        row = 5,
        col = 4,
        type = 2 ,        --1:近 2：远1 3：远2 4骑
        leader = {
            code = 1,
            pos = "B",    --位置 B:前 A：后
            name = "tauren(test01)", -- 动画名称
--            res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            actname = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkactname = 1, -- 攻击动作索引
            skillactname = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = 0.24,
            scaley = 0.24
        },
        soldier = {
            name = "tauren(test01)", -- 动画名称
--            res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            actname = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkactname = 1, -- 攻击动作索引
            skillactname = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = 0.24,
            scaley = 0.24
        }
    },
    team2= { --（从右面面数）
        row = 5,
        col = 4,
        type = 2 ,        --1:近 2：远1 3：远2 4骑
        leader = {
            code = 4,
            pos = "B",    --位置 B:前 A：后
            name = "tauren(test01)", -- 动画名称
--            res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            actname = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkactname = 1, -- 攻击动作索引
            skillactname = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = 0.24,
            scaley = 0.24
        },
        soldier = {
            name = "tauren(test01)", -- 动画名称
--            res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            actname = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkactname = 1, -- 攻击动作索引
            skillactname = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = 0.24,
            scaley = 0.24
        }
    },
    team3= { --（从右面面数）
        row = 5,
        col = 4,
        type = 2 ,        --1:近 2：远1 3：远2 4骑
        leader = {
            code = 5,
            pos = "B",    --位置 B:前 A：后
            name = "tauren(test01)", -- 动画名称
            --            res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            actname = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkactname = 1, -- 攻击动作索引
            skillactname = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = 0.24,
            scaley = 0.24
        },
        soldier = {
            name = "tauren(test01)", -- 动画名称
            --            res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            actname = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkactname = 1, -- 攻击动作索引
            skillactname = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = 0.24,
            scaley = 0.24
        }
    },
    team4= { --（从右面面数）
        row = 5,
        col = 4,
        type = 2 ,        --1:近 2：远1 3：远2 4骑
        leader = {
            code = 6,
            pos = "B",    --位置 B:前 A：后
            name = "tauren(test01)", -- 动画名称
            --            res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            actname = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkactname = 1, -- 攻击动作索引
            skillactname = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = 0.24,
            scaley = 0.24
        },
        soldier = {
            name = "tauren(test01)", -- 动画名称
            --            res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            actname = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkactname = 1, -- 攻击动作索引
            skillactname = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = 0.24,
            scaley = 0.24
        }
    }
    ,team5= { --（从右面面数）
        row = 5,
        col = 4,
        type = 2 ,        --1:近 2：远1 3：远2 4骑
        leader = {
            code = 4,
            pos = "B",    --位置 B:前 A：后
            name = "tauren(test01)", -- 动画名称
            --            res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            actname = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkactname = 1, -- 攻击动作索引
            skillactname = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = 0.24,
            scaley = 0.24
        },
        soldier = {
            name = "tauren(test01)", -- 动画名称
            --            res = "data/tauren/tauren.csb", --资源文件名称以及资源路径res下开始
            actname = 0, --开始默认播放动画索引 （nil：开始不播放）
            atkactname = 1, -- 攻击动作索引
            skillactname = 1, --技能动画索引
            hp = 100,       --血
            hurt = 1,       --伤害
            scalex = 0.24,
            scaley = 0.24
        }
    }
    
}

