/**
curve(p0: cc.Vec2, p1, p2, p3) {
        let s = 0.5;
        let b1 = p0.mul(-s).add(p1.mul(2 - s)).add(p2.mul(s - 2)).add(p3.mul(s));
        let b2 = p0.mul(2 * s).add(p1.mul(s - 3)).add(p2.mul(3 - 2 * s)).add(p3.mul(-s));
        let b3 = p0.mul(-s).add(p2.mul(s));
        let b4 = p1;
        function fx(x) {
            return b1.mul(Math.pow(x, 3)).add(b2.mul(Math.pow(x, 2))).add(b3.mul(x)).add(b4)
        }
        return fx;
    }
*/
let Vec3 = require('./Vec3')
let CatmullRom = require('./CatmullRom') 

let points = [new Vec3(0.1, 0.4, 0), new Vec3(0.5, 0.4, 0), new Vec3(0.7, 0.1, 0), new Vec3(0.9, 0.9, 0), new Vec3(0.1, 0.4, 0)]

let rom = new CatmullRom(points)

let ret = []
for (let i = 0; i <= 1; i += 0.2) {
    ret.push(rom.lerp(i))
}
console.log(ret)
