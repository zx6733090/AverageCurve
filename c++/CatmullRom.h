#ifndef __CatmullRom__
#define __CatmullRom__

#include"Vec3.h"
#include <vector>
#include <functional>
#include <map>

using namespace std;
class CatmullRom
{
public:
	// usage
	// 0 : 均速曲线运动, s变化恒定
	// 1 : 自定义缓动曲线, t变化恒定
	CatmullRom(const vector<Vec3>& pts, int usage = 0);
	~CatmullRom();

	typedef struct _Funcs{
		function<Vec3(float)>  f1;
		function<float(float)> f2;
		function<float(float)> f3;
		_Funcs(const function<Vec3(float)>& f1, const function<float(float)>& f2, const function<float(float)>& f3) :f1(f1), f2(f2), f3(f3){};
	} Funcs;

	//样条曲线经过的点
	vector<Vec3> points;
	//到每一个点的曲线长度
	vector<float> distances;
	//每一段函数曲线，导函数ds，dx
	vector<Funcs> funcs;

	//是否环路
	bool bClose;
	//匀速插值
	Vec3 lerp(float t);

	//基本样条线插值算法
	static Funcs curve(Vec3 p0, Vec3 p1, Vec3 p2, Vec3 p3);
	//高斯—勒让德积分公式可以用较少节点数得到高精度的计算结果
	static float gaussLegendre(const function<float(float)>& func, float a, float  b);
private:

};

#endif  // __CatmullRom__