%% Program that predicts projectile trajectories.

%%
% Initial x,y data goes here =======================================
test = [0.707106781187 ,0.658106781187];  % [x,y]
% ==================================================================

%%
% Convert t,x,y arrays from csv to array of Path objects
import_csv; % import projectiles.csv
start = [find(~t); length(t)+1];
paths = [Path([0 1],[0 1], [0 1] )]; % dummy
for e = 1:length(start)-1
    paths(end+1) = Path(t(start(e):start(e+1)-1), x(start(e):start(e+1)-1),y(start(e):start(e+1)-1));
end
paths(1) = []; % delete frist dummy path.

%%
% Remove paths where the number of nonzero data points is <= 4. These won't
% work well with a 4th order polynomial fit.
for e = length(paths):-1:1
    if length(paths(e).t) <=5
        paths(e) = [];
    end
end

%%
%Some plotting of the trajectories.
figure(1)
for e = 1:50
   plot(paths(e).x,paths(e).y,'o')
   hold on
end
title('First 50 trajectories')
xlabel('x')
ylabel('y')

%% 
% Build the model, x and y independently.
initx = []; inity = []; % arrays of initial x/y data from trajectories
curvex = []; curvey = []; % polynomial fit parameters. x and y independent.
for e = 1:length(paths)
    initx(end+1) = paths(e).x(2); % initial x data
    curvex(end+1,:) = paths(e).xfit; % 5 coefficients from x,t fit to e'th trajectory
    inity(end+1) = paths(e).y(2); % initial y data
    curvey(end+1,:) = paths(e).yfit; % 5 coefficients from y,t fit to e'th trajectory
end
initx = initx'; inity = inity'; % transpose

% pf1x is a polynomial model of how the leading coefficient of the
% polynomial that fits the trajectory varies as a function of initial x.
pf1x = polyfit(initx,curvex(:,1),4); % degree 4 coefficient
pf2x = polyfit(initx,curvex(:,2),4); % degree 3
pf3x = polyfit(initx,curvex(:,3),4); % degree 2
pf4x = polyfit(initx,curvex(:,4),4); % degree 1
pf5x = polyfit(initx,curvex(:,5),4); % degree 0 (constant)

pf1y = polyfit(inity,curvey(:,1),4); 
pf2y = polyfit(inity,curvey(:,2),4); 
pf3y = polyfit(inity,curvey(:,3),4);
pf4y = polyfit(inity,curvey(:,4),4);
pf5y = polyfit(inity,curvey(:,5),4); 

% fitpx is a polynomial model the predicted x trajectory (ie x(t)) 
% as a function of initial x.
fitpx = [polyval(pf1x,test(1)) polyval(pf2x,test(1)) polyval(pf3x,test(1)) polyval(pf4x,test(1)) polyval(pf5x,test(1))];
fitpy = [polyval(pf1y,test(2)) polyval(pf2y,test(2)) polyval(pf3y,test(2)) polyval(pf4y,test(2)) polyval(pf5y,test(2))];
time = 0;

% Check when projectile hits the ground
while polyval(fitpy,time)>=-0.01
    time = time + .1;
end
time = 0:1:time;
predictedx = polyval(fitpx,time);
predictedy = polyval(fitpy,time);
%%
% Plot predictions based on the statistical model and based on physics
figure(2); hold on
plot(predictedx,predictedy)
[time,xx,yy] = trajectory_from_physics(test);
plot(xx,yy,'o')
xlabel('x')
ylabel('y')
title('Prediction: Statistics (curve) vs physics (circles)')


