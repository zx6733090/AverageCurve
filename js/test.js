
let Vec3 = require('./Vec3')
let CatmullRom = require('./CatmullRom') 

let points = [new Vec3(0.1, 0.4, 0), new Vec3(0.5, 0.4, 0), new Vec3(0.7, 0.1, 0), new Vec3(0.9, 0.9, 0), new Vec3(0.1, 0.4, 0)]

let rom = new CatmullRom(points)

let ret = []
for (let i = 0; i <= 1; i += 0.2) {
    ret.push(rom.lerp(i))
}
console.log(ret)