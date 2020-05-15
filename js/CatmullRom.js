class CatmullRom {
    //CatmullRom 样条曲线
    //   给定一组控制点而得到一条曲线,曲线的大致形状由这些点控制
    constructor(pts, usage) {
        this.usage = usage || 0
        this.points = pts

        this.bClose = pts[0].eq(pts[pts.length - 1])
        this.funcs = []
        this.distances = []
        let sumDistance = 0
        let p0, p1, p2, p3
        for (let i = 0; i < pts.length - 1; i++) {
            if (i == 0) {
                p0 = this.bClose ? pts[pts.length - 2] : pts[0]
            } else {
                p0 = pts[i - 1]
            }

            p1 = pts[i]
            p2 = pts[i + 1]
            if (i + 1 == pts.length - 1) {
                p3 = this.bClose ? pts[1] : pts[pts.length - 1]
            } else {
                p3 = pts[i + 2]
            }

            this.funcs[i] = []
            let ds, dx;
            [this.funcs[i][0], ds, dx] = CatmullRom.curve(p0, p1, p2, p3);
            this.funcs[i][1] = this.usage == 0 ? ds : dx

            sumDistance += CatmullRom.gaussLegendre(this.funcs[i][1], 0, 1);
            this.distances[i] = sumDistance
        }
    }
    lerp(t) {
        //第一个和最后一个点直接返回
        if (t == 0) {
            return this.points[0]
        } else if (t == 1) {
            return this.points[this.points.length - 1]
        }
        //平均距离
        let averDis = t * this.distances[this.points.length - 2]
        let index = 0,
            beyond = 0,
            percent = 0;
        for (let i = 0; i < this.points.length - 1; i++) {
            if (averDis < this.distances[i]) {
                let preDis = i == 0 ? 0 : this.distances[i - 1]
                index = i
                beyond = averDis - preDis;
                percent = beyond / (this.distances[i] - preDis);
                break
            }
        }
        //牛顿切线法求根
        let a = percent,
            b
        //最多迭代6次
        for (let i = 0; i < 6; i++) {
            let actualLen = CatmullRom.gaussLegendre(this.funcs[index][1], 0, a);
            b = a - (actualLen - beyond) / this.funcs[index][1](a)
            if (Math.abs(a - b) < 0.0001) {
                break
            }
            a = b
        }
        percent = b
        return this.funcs[index][0](percent)
    }
    static curve(p0, p1, p2, p3) {
        //CatmullRom
        //   基本样条线插值算法
        // 弹性
        let s = 0.5
        //计算三次样条线函数系数
        let b1 = p0.mtimes(-s).plus(p1.mtimes(2 - s)).plus(p2.mtimes(s - 2)).plus(p3.mtimes(s))
        let b2 = p0.mtimes(2 * s).plus(p1.mtimes(s - 3)).plus(p2.mtimes(3 - 2 * s)).plus(p3.mtimes(-s))
        let b3 = p0.mtimes(-s).plus(p2.mtimes(s))
        let b4 = p1

        // 函数曲线
        function fx(x) {
            return b1.mtimes(Math.pow(x, 3)).plus(b2.mtimes(Math.pow(x, 2))).plus(b3.mtimes(x)).plus(b4)
        }
        // 曲线长度变化率,用于匀速曲线运动
        function ds(x) {
            let der = b1.mtimes(3 * Math.pow(x, 2)).plus(b2.mtimes(2 * x)).plus(b3)
            return Math.sqrt(Math.pow(der.x, 2) + Math.pow(der.y, 2) + Math.pow(der.z, 2))
        }
        // 曲线x变化率,用于自定义缓动曲线
        function dx(x) {
            let der = b1.mtimes(3 * Math.pow(x, 2)).plus(b2.mtimes(2 * x)).plus(b3)
            return der.x
        }
        return [fx, ds, dx]
    }
    static gaussLegendre(func, a, b) {
        //gaussLegendre 高斯—勒让德积分公式可以用较少节点数得到高精度的计算结果
        // a     左区间
        // b     右区间
        //3次系数
        let GauFactor = {
            0.7745966692: 0.555555556,
            0: 0.8888888889
        }
        //5次系数
        //let GauFactor = {0.9061798459:0.2369268851,0.5384693101:0.4786286705,0:0.5688888889}
        //积分
        let GauSum = 0
        for (let key in GauFactor) {
            let v = GauFactor[key]
            let t = ((b - a) * key + a + b) / 2
            let der = func(t)
            GauSum = GauSum + der * v
            if (key > 0) {
                t = ((b - a) * (-key) + a + b) / 2
                der = func(t)
                GauSum = GauSum + der * v
            }
        }
        return GauSum * (b - a) / 2
    }
}
module.exports = CatmullRom