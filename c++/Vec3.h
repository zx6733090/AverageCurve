#ifndef __Vec3__
#define __Vec3__

class Vec3{
public:
	float x;
	float y;
	float z;

	Vec3();
	Vec3(const Vec3& copy);
	Vec3(float xx, float yy, float zz);

	//重载运算符
	inline Vec3 Vec3::operator+(const Vec3& v) const
	{
		return Vec3(x + v.x, y + v.y, z + v.z);
	}

	inline Vec3 Vec3::operator-(const Vec3& v) const
	{
		return Vec3(x - v.x, y - v.y, z - v.z);
	}

	inline Vec3 Vec3::operator*(float s) const
	{
		return Vec3(x * s, y * s, z * s);
	}

	inline bool Vec3::operator==(const Vec3& v) const
	{
		return x == v.x && y == v.y && z == v.z;
	}
};
#endif  // __Vec3__