// test.cpp : 定义控制台应用程序的入口点。
//

#include"Vec3.h"
#include"CatmullRom.h"

using namespace std;
int main(int argc, char* argv[])
{
	std::vector<Vec3> points = { Vec3(0.1, 0.4, 0), Vec3(0.5, 0.4, 0), Vec3(0.7, 0.1, 0), Vec3(0.9, 0.9, 0), Vec3(0.1, 0.4, 0) };

	CatmullRom rom(points);

	std::vector<Vec3> ret;
	for (float i = 0; i <= 1; i += 0.2) {
		ret.push_back(rom.lerp(i));
	}

	//=> ret
	return 0;
}

