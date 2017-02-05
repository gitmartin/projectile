classdef Path < handle
    properties
        t;
        x;
        y;
        xfit;
        yfit;
    end
    
    methods
        % methods, including the constructor are defined in this block
        function obj = Path(t,x,y)
            % class constructor
            obj.t = t;
            obj.x = x;
            obj.y = y;
            my_polyfit(obj);
        end
        function none = my_polyfit(obj)
            obj.xfit = polyfit(obj.t,obj.x,4); % fit 4th order polynomial
            obj.yfit = polyfit(obj.t,obj.y,4);
        end
    end
    
end

