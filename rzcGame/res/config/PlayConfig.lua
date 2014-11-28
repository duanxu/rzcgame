--游戏中关于动画和摄像头的控制参数（临时配置，以后将被正式数据文件替换）

--进入场景后扫过全场的速度

PASS_ALL_TIME = 5

--小兵开场动作间隔时间
START_SOILDER_SPACE_TIME = 0.01

--入场动画后多久播放回合数

ROUND_TIME = 1

--显示回合后 多久开始分屏

SPLITE_SCREEN_TIME = 1

--分屏后 多久开始攻击

ATK_TIME =1

--被远程攻击时队伍据屏幕中间的距离
DEF_TO_CENTER_LEN = 200

-- 箭的飞行速度
ARROW_SPEED = 300

-- 箭缩放
ARROW_SCALE = 0.24
-- 箭的上升高度（相对于发射点的y值增量，速度已经由飞行速度决定，高度也会影响上升速度。）
ARROW_HIGHT = 200
-- 箭的竖直向上飞行效果()带默认参数的 可以自己指定，in代表开始时 out代表结束时
ARROW_ACTION_UP = "sineOut"
ARROW_ACTION_DOWN = "sineIn"
-- 箭的竖直向上
--[[
            回力
-    backIn 
-    backInOut
-    backOut
            反弹力
-    bounce
-    bounceIn
-    bounceInOut
-    bounceOut
              弹性
-    elastic, 附加参数默认为 0.3
-    elasticIn, 附加参数默认为 0.3
-    elasticInOut, 附加参数默认为 0.3
-    elasticOut, 附加参数默认为 0.3
            缓慢
-    exponentialIn, 附加参数默认为 1.0
-    exponentialInOut, 附加参数默认为 1.0
-    exponentialOut, 附加参数默认为 1.0
            渐隐
-    In, 附加参数默认为 1.0
-    InOut, 附加参数默认为 1.0
-    Out, 附加参数默认为 1.0
    旋转
-    rateaction, 附加参数默认为 1.0
    慢变快
-    sineIn
    慢到快再快到慢
-    sineInOut
    快变慢
-    sineOut
]]


-- 箭的水平飞行距离（如果需要水平飞行一 ）
ARROW_HORIZONTAL = 0
