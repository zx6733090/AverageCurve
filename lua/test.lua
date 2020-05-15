local Vec3 = require('Vec3')
local CatmullRom = require('./CatmullRom')

local points = {Vec3(0.1, 0.4, 0), Vec3(0.5, 0.4, 0), Vec3(0.7, 0.1, 0), Vec3(0.9, 0.9, 0), Vec3(1, 0.4, 0)}

local rom = CatmullRom(points)

local ret = {}

for i = 0, 1, 0.2 do
    table.insert(ret, rom:lerp(i))
end

print(ret)
