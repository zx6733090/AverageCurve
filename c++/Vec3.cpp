#include "Vec3.h"

Vec3::Vec3()
: x(0.0f), y(0.0f), z(0.0f)
{
}

Vec3::Vec3(float xx, float yy, float zz)
: x(xx), y(yy), z(zz)
{
}

Vec3::Vec3(const Vec3& copy)
{
	x = copy.x;
	y = copy.y;
	z = copy.z;
}
