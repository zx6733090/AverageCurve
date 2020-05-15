classdef Vec3
    %Vec3 三维向量
    
    properties
        x = 0
        y = 0
        z = 0
    end
    
    methods
        function obj = Vec3(x,y,z)
            %Vec3 构造此类的实例
            if  nargin == 3
                obj.x = x;
                obj.y = y;
                obj.z = z;
            elseif nargin == 1
                obj.x = x(1);
                obj.y = x(2);
                obj.z = x(3);
            else
                obj.x = 0;
                obj.y = 0;
                obj.z = 0;
            end
        end
        
        function b = eq(obj,other)
            %eq 重载 == 运算符
            b = obj.x == other.x && obj.y == other.y && obj.z == other.z;
        end
        function b = minus(obj,other)
            %minus 重载 - 运算符
            b = Vec3(obj.x - other.x,obj.y - other.y,obj.z - other.z);
        end
        function b = plus(obj,other)
            %plus 重载 + 运算符
            if isa(other, 'double')
                b = Vec3(obj.x + other,obj.y + other,obj.z + other);
            elseif isa(obj, 'double')
                b = Vec3(obj + other.x,obj + other.y,obj + other.z);
            else
                b = Vec3(obj.x + other.x,obj.y + other.y,obj.z + other.z);
            end
        end
        function b = mtimes(obj,other)
            %mtimes 重载 * 运算符
            if isa(other, 'double')
                b = Vec3(obj.x * other,obj.y * other,obj.z * other);
            elseif isa(obj, 'double')
                b = Vec3(obj * other.x,obj * other.y,obj * other.z);
            elseif isa(other, 'Vec3')
                b = Vec3(obj.x * other.x,obj.y * other.y,obj.z * other.z);
            end
        end
        function b = mpower(obj,n)
            %mpower 重载 ^ 运算符
            b = Vec3(power(obj.x,n),power(obj.y,n),power(obj.z,n));
        end
    end
end

