 class Vec3 {
     //三维向量
     constructor(x, y, z) {
         if (z != undefined) {
             this.x = x
             this.y = y
             this.z = z
         } else if (x != undefined) {
             this.x = x.x
             this.y = x.y
             this.z = x.z
         } else {
             this.x = 0
             this.y = 0
             this.z = 0
         }
     }
     //重载 == 运算符
     eq(other) {
         return this.x == other.x && this.y == other.y && this.z == other.z
     }
     //重载 - 运算符
     minus(other) {
         return new Vec3(this.x - other.x, this.y - other.y, this.z - other.z)
     }
     //重载 + 运算符
     plus(other) {
         if (typeof (other) == "number") {
             return new Vec3(this.x + other, this.y + other, this.z + other)
         } else {
             return new Vec3(this.x + other.x, this.y + other.y, this.z + other.z)
         }
     }
     //重载 * 运算符
     mtimes(other) {
         if (typeof (other) == "number") {
             return new Vec3(this.x * other, this.y * other, this.z * other)
         } else {
             return new Vec3(this.x * other.x, this.y * other.y, this.z * other.z)
         }
     }
     //重载 ^ 运算符
     mpower(n) {
         return new Vec3(Math.pow(this.x, n), Math.pow(this.y, n), Math.pow(this.z, n))
     }
 }
 module.exports = Vec3