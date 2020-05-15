classdef CatmullRom
    %CatmullRom 样条曲线
    %   给定一组控制点而得到一条曲线,曲线的大致形状由这些点控制
    
    properties
        %样条曲线经过的点
        points = []
        
        %到每一个点的曲线长度
        distances = []
        %每一段函数曲线，导函数ds，dx
        funcs = []
        %是否环路
        bClose = 0
        %点的个数
        length = 0
        %用法,默认均速曲线运动
        usage = 0
    end
    
    methods
        % usage
        %    0: 均速曲线运动,s变化恒定
        %    1: 自定义缓动曲线,t变化恒定
        function obj = CatmullRom(pts,usage)
            if nargin > 1
                obj.usage = usage;
            end
            %CatmullRom 构造此类的实例
            obj.points = pts;
            
            sz = size(pts);
            obj.length = sz(2);
            obj.funcs = cell(1,obj.length);
            obj.bClose = pts(1) == pts(obj.length);
            
            sumDistance = 0;
            for i = 1:obj.length-1
                if i == 1
                    if obj.bClose
                        %是环路，第一个点 为 倒数第二个点
                        p0 = pts(obj.length - 1);
                    else
                        %第一个点和第二个点在同一位置
                        p0 = pts(1);
                    end
                else
                    p0 = pts(i - 1);
                end
                p1 = pts(i);
                p2 = pts(i+1);
                if i+1 == obj.length
                    if obj.bClose
                        %是环路，最后一个点指向第二个点
                        p3 = pts(2);
                    else
                        p3 = pts(obj.length);
                    end
                else
                    p3 = pts(i+2);
                end
                [obj.funcs{i}{1}, ds,dx] = CatmullRom.curve(p0,p1,p2,p3);
                if obj.usage == 0
                    obj.funcs{i}{2} = ds;
                else
                    obj.funcs{i}{2} = dx;
                end
                sumDistance = sumDistance + CatmullRom.gaussLegendre(obj.funcs{i}{2},0,1);
                obj.distances(i) = sumDistance;
            end
        end
        %插值
        function ret = lerp(obj,t)
            %第一个和最后一个点直接返回
            if t == 0
                ret = obj.points(1);
                return
            elseif t == 1
                ret = obj.points(obj.length);
                return
            end
            %平均距离
            averDis = t*obj.distances(obj.length-1);
            for i = 1:obj.length-1
                if averDis < obj.distances(i)
                    index = i;
                    if i == 1
                        preDis = 0;
                    else
                        preDis = obj.distances(i - 1);
                    end
                    beyond = averDis - preDis;
                    percent = beyond / (obj.distances(i) - preDis);
                    break;
                end
            end
            
            %牛顿切线法求根
            a = percent;
            %最多迭代6次
            for i = 0:0.2:1
                actualLen = CatmullRom.gaussLegendre(obj.funcs{index}{2},0,a);
                b = a - (actualLen - beyond)/obj.funcs{index}{2}(a);
                if abs(a - b)<0.0001
                    break
                end
                a = b;
            end
            percent = b ;
            ret = obj.funcs{index}{1}(percent);
        end
    end
    methods(Static)
        function [rfx,rdx,rdxx] = curve(p0, p1, p2, p3)
            %CatmullRom
            %   基本样条线插值算法
            % 弹性
            s =0.5;
            %计算三次样条线函数系数
            b1 = -s* p0 + (2-s)*p1+(s-2)*p2+s*p3;
            b2 = 2*s*p0 +(s-3)*p1+(3-2*s)*p2+(-s)*p3;
            b3 = -s* p0+s*p2;
            b4 = p1;
            
            % 函数曲线
            function ret =fx(x)
                ret = b1*x^3 + b2*x^2 + b3*x+b4;
            end
            rfx = @fx;
            % 曲线长度变化率,用于匀速曲线运动
            function ret =dx(x)
                der = 3*b1 *x^2 + 2*b2*x +b3;
                ret = sqrt(der.x^2+der.y^2+der.z^2);
            end
            rdx= @dx;
            % 曲线x变化率,用于自定义缓动曲线
            function ret =dxx(x)
                der = 3*b1 *x^2 + 2*b2*x +b3;
                ret = der.x;
            end
            rdxx = @dxx;
        end
        
        function len = gaussLegendre(func,a,b)
            %gaussLegendre 高斯—勒让德积分公式可以用较少节点数得到高精度的计算结果
            % a     左区间
            % b     右区间
            % 3次系数
            GauFactor = containers.Map({0.7745966692,0},{0.555555556,0.8888888889});
            % 5次系数
            %GauFactor = containers.Map({0.9061798459,0.5384693101,0},{0.2369268851,0.4786286705,0.5688888889});
            %积分
            GauSum = 0 ;
            for key = keys(GauFactor)
                k = key{1};
                v = GauFactor(k);
                t = ((b-a)*k+a+b)/2;
                der = func(t);
                GauSum = GauSum+der*v;
                if k>0
                    t = ((b-a)*(-k)+a+b)/2;
                    der = func(t);
                    GauSum = GauSum+der*v;
                end
            end
            len = GauSum*(b-a)/2;
        end
    end
end

