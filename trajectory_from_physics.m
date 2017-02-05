function [ time,xr,yr ] = trajectory_from_physics( test )
x = test(1); y = test(2);
% assume g = -9.8 m/s^2
% x,y in meters at .1 seconds
t = .1; % seconds
vx0 = x/t; % initial x velocity
vy0 = y/t + 9.8*t/2;
time = [0];
xr = [0];
yr = [0];

while yr(end) >=0
   time(end+1) = time(end) + .1;
   xr(end+1) = time(end)*vx0;
   yr(end+1) = time(end)*(vy0-9.8*time(end)/2);
end
% remove last point 
time(end) = []; xr(end) = []; yr(end) = [];

end

