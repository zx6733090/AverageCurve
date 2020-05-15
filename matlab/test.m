%样条曲线经过的点
points=[Vec3(0.1,0.4,0),Vec3(0.5,0.4,0),Vec3(0.7,0.1,0),Vec3(0.9,0.9,0),Vec3(0.1,0.4,0)];

rom = CatmullRom(points);
ret = repmat(Vec3(),[0 0]);

for i = 0:0.02:1
    sz = size(ret);
    ret(sz(2)+1) = rom.lerp(i);
end
hold off
plot([ret.x],[ret.y],'r.')

%坐标轴要固定，以便观察距离
axis([0 1 0 1]);
