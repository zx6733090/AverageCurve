local vec3 ;
vec3= {
        -- 构造式
        __call = function(self, x, y, z)
            if z ~= nil then
                self.x = x
                self.y = y
                self.z = z
            elseif x ~= nil then
                self.x = x.x
                self.y = x.y
                self.z = x.z
            else
                self.x = 0
                self.y = 0
                self.z = 0
            end
            return self
        end,
        --重载 == 运算符
        __eq = function(a, b)
            return a.x == b.x and a.y == b.y and a.z == b.z
        end,
        --重载 - 运算符
        __sub = function(a, b)
            local obj = {}
            setmetatable(obj, vec3)
            if type(b) == "number" then
                return obj(a.x - b , a.y - b , a.z - b)
            else
                return obj(a.x - b.x , a.y - b.y , a.z - b.z)
            end
        end,
        --重载 + 运算符
        __add = function(a, b)
            local obj = {}
            setmetatable(obj, vec3)
            if type(a) == "number" then
                return obj(a + b.x , a + b.y , a + b.z)
            elseif type(b) == "number" then 
                return obj(a.x + b , a.y + b , a.z +b)
            else
                return obj(a.x + b.x , a.y + b.y , a.z +b.z)
            end
        end,
        --重载 * 运算符
        __mul=function(a, b)
            local obj = {}
            setmetatable(obj, vec3)
            if type(a) == "number" then
                return obj(a * b.x , a * b.y , a * b.z)
            elseif type(b) == "number" then 
                return obj(a.x * b , a.y * b , a.z *b)
            else
                return obj(a.x * b.x , a.y * b.y , a.z *b.z)
            end
        end,
        --重载 ^ 运算符
        __pow=function(a, n)
            local obj = {}
            setmetatable(obj, vec3)
            return obj(math.pow(a.x ,n) , math.pow(a.y ,n) , math.pow(a.z ,n))
        end
}
return function(x, y, z)
    local ret = {}
    setmetatable(ret, vec3)
    return ret(x, y, z)
end
