local CatmullRom;

CatmullRom = {
        -- 构造式
        __call = function(self, pts, usage)
            self.usage = usage or 0
            self.points = pts
            self.bClose = pts[1] == pts[#pts]
            
            self.funcs = {}
            self.distances = {}
            local sumDistance = 0
            local p0, p1, p2, p3
            for i = 1, #pts - 1 do
                if i == 1 then
                    p0 = self.bClose and pts[#pts - 1] or pts[1]
                else
                    p0 = pts[i - 1]
                end
                
                p1 = pts[i]
                p2 = pts[i + 1]
                if i + 1 == #pts then
                    p3 = self.bClose and pts[2] or pts[#pts]
                else
                    p3 = pts[i + 2]
                end
                
                self.funcs[i] = {}
                local ds, dx;
                self.funcs[i][1], ds, dx = CatmullRom.curve(p0, p1, p2, p3)
                self.funcs[i][2] = self.usage == 0 and ds or dx
                
                sumDistance = sumDistance + CatmullRom.gaussLegendre(self.funcs[i][2], 0, 1)
                self.distances[i] = sumDistance
            end
            return self
        end,
        lerp = function(self, t)
            --第一个和最后一个点直接返回
            if t == 0 then
                return self.points[1]
            elseif t == 1 then
                return self.points[#self.points]
            end
            
            --平均距离
            local averDis = t * self.distances[#self.points - 1]
            local index, beyond, percent = 0, 0, 0
            for i = 1, #self.points - 1 do
                if averDis < self.distances[i] then
                    local preDis = i == 1 and 0 or self.distances[i - 1]
                    index = i
                    beyond = averDis - preDis
                    percent = beyond / (self.distances[i] - preDis)
                    break
                end
            end
            --牛顿切线法求根
            local a, b = percent
            --最多迭代6次
            for i = 1, 6 do
                local actualLen = CatmullRom.gaussLegendre(self.funcs[index][2], 0, a)
                b = a - (actualLen - beyond) / self.funcs[index][2](a)
                if math.abs(a - b) < 0.0001 then
                    break
                end
                a = b
            end
            percent = b
            return self.funcs[index][1](percent)
        end,
        curve = function(p0, p1, p2, p3)
            --CatmullRom
            --   基本样条线插值算法
            -- 弹性
            local s = 0.5
            --计算三次样条线函数系数
            local b1 = -s * p0 + (2 - s) * p1 + (s - 2) * p2 + s * p3
            local b2 = 2 * s * p0 + (s - 3) * p1 + (3 - 2 * s) * p2 + (-s) * p3
            local b3 = -s * p0 + s * p2
            local b4 = p1
            -- 函数曲线
            local function fx(x)
                return b1 * x ^ 3 + b2 * x ^ 2 + b3 * x + b4
            end
            -- 曲线长度变化率,用于匀速曲线运动
            local function ds(x)
                local der = 3 * b1 * x ^ 2 + 2 * b2 * x + b3
                return math.sqrt(der.x ^ 2 + der.y ^ 2 + der.z ^ 2)
            end
            -- 曲线x变化率,用于自定义缓动曲线
            local function dx(x)
                local der = 3 * b1 * x ^ 2 + 2 * b2 * x + b3
                return der.x
            end
            return fx, ds, dx
        end,
        gaussLegendre = function(func, a, b)
            --gaussLegendre 高斯—勒让德积分公式可以用较少节点数得到高精度的计算结果
            -- a     左区间
            -- b     右区间
            -- 3次系数
            local GauFactor = {
                [0.7745966692] = 0.555555556,
                [0] = 0.8888888889
            }
            --5次系数
            --local GauFactor = {0.9061798459=0.2369268851,0.5384693101=0.4786286705,0=0.5688888889}
            --积分
            local GauSum = 0
            for key, v in pairs(GauFactor) do
                local t = ((b - a) * key + a + b) / 2
                local der = func(t)
                GauSum = GauSum + der * v
                if key > 0 then
                    t = ((b - a) * (-key) + a + b) / 2
                    der = func(t)
                    GauSum = GauSum + der * v
                end
            end
            return GauSum * (b - a) / 2
        end
}
-- 索引元表
CatmullRom.__index = CatmullRom
return function(pts, usage)
    local ret = {}
    setmetatable(ret, CatmullRom)
    return ret(pts, usage)
end