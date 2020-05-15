#include"CatmullRom.h"

CatmullRom::CatmullRom(const vector<Vec3>& pts, int usage)
{
	points = pts;

	int len = pts.size();
	bClose = pts[0] == pts[len - 1];

	float sumDistance = 0;
	Vec3  p0, p1, p2, p3;
	for (int i = 0; i < len - 1; i++){
		if (i == 0) {
			p0 = bClose ? pts[len - 2] : pts[0];
		}
		else {
			p0 = pts[i - 1];
		}

		p1 = pts[i];
		p2 = pts[i + 1];
		if (i + 1 == len - 1) {
			p3 = bClose ? pts[1] : pts[len - 1];
		}
		else {
			p3 = pts[i + 2];
		}

		Funcs fs = CatmullRom::curve(p0, p1, p2, p3);
		funcs.push_back(fs);
		funcs[i].f2 = usage == 0 ? fs.f2 : fs.f3;

		sumDistance += CatmullRom::gaussLegendre(funcs[i].f2, 0, 1);
		distances.push_back(sumDistance);
	}
}

CatmullRom::~CatmullRom()
{
}


Vec3 CatmullRom::lerp(float t){
	int len = points.size();
	//第一个和最后一个点直接返回
	if (t == 0) {
		return points[0];
	}
	else if (t == 1) {
		return points[len - 1];
	}
	//平均距离
	float averDis = t * distances[len - 2];
	float index = 0, beyond = 0, percent = 0;
	for (int i = 0; i < len - 1; i++) {
		if (averDis < distances[i]) {
			float preDis = i == 0 ? 0 : distances[i - 1];
			index = i;
			beyond = averDis - preDis;
			percent = beyond / (distances[i] - preDis);
			break;
		}
	}
	//牛顿切线法求根
	float a = percent, b;
		//最多迭代6次
	for (int i = 0; i < 6; i++) {
		float actualLen = CatmullRom::gaussLegendre(funcs[index].f2, 0, a);
		b = a - (actualLen - beyond) / funcs[index].f2(a);
		if (abs(a - b) < 0.0001) {
			break;
		}
		a = b;
	}
	percent = b;
	return funcs[index].f1(percent);
}
CatmullRom::Funcs CatmullRom::curve(Vec3 p0, Vec3 p1, Vec3 p2, Vec3 p3){
	// 弹性
	float s = 0.5;
	//计算三次样条线函数系数
	Vec3 b1 = p0*(-s) + p1*(2 - s) + p2*(s - 2) + p3*s;
	Vec3 b2 = p0 * 2 * s + p1*(s - 3) + p2*(3 - 2 * s) + p3*(-s);
	Vec3 b3 = p0*(-s) + p2*s;
	Vec3 b4 = p1;

	// 函数曲线
	auto f1 = [=](float x) -> Vec3 {
		return b1*pow(x , 3) + b2*pow(x , 2) + b3*x + b4;
	};
	// 曲线长度变化率, 用于匀速曲线运动
	auto f2 = [=](float x) -> float {
			Vec3 der = b1 * 3 * pow(x, 2) + b2*x * 2 + b3;
			return sqrt(pow(der.x, 2) + pow(der.y, 2) + pow(der.z, 2));
	};
	// 曲线x变化率, 用于自定义缓动曲线
	auto f3 = [=](float x) -> float {
		Vec3 der = b1 * 3 * pow(x, 2) + b2*x * 2 + b3;
		return der.x;
	};
	return Funcs(f1, f2, f3);
}

float CatmullRom::gaussLegendre(const function<float(float)>& func, float a, float  b){
	//3次系数
	static std::map<float, float> GauFactor{ { 0.7745966692, 0.555555556 }, { 0, 0.8888888889 } };
	//5次系数
	//static std::map<float, float> GauFactor{ { 0.9061798459, 0.2369268851 }, { 0.5384693101, 0.4786286705 }, { 0, 0.5688888889 } };
	float GauSum = 0;
	
	for (auto &kv : GauFactor) {
		float key = kv.first;
		float v = kv.second;
		float t = ((b - a) * key + a + b) / 2;
		float der = func(t);
		GauSum = GauSum + der * v;
		if (key > 0) {
			t = ((b - a) * (-key) + a + b) / 2;
			der = func(t);
			GauSum = GauSum + der * v;
		}
	}
	return GauSum * (b - a) / 2;
}