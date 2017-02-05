%% Program that predicts projectile trajectories. Uses MATLAB's fitlm function

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
% Build the model, x and y independently.
initx = []; inity = []; % arrays of initial x/y data from trajectories
curvex = []; curvey = []; % polynomial fit parameters
for e = 1:length(paths)
    initx(end+1) = paths(e).x(2); % initial x data
    curvex(end+1,:) = paths(e).xfit; % 5 coefficients from x,t fit to e'th trajectory
    inity(end+1) = paths(e).y(2); % initial y data
    curvey(end+1,:) = paths(e).yfit; % 5 coefficients from y,t fit to e'th trajectory
end
initx = initx'; inity = inity'; % transpose
p1x = table(initx,inity,curvex(:,1));
p2x = table(initx,inity,curvex(:,2));
p3x = table(initx,inity,curvex(:,3));
p4x = table(initx,inity,curvex(:,4));
p5x = table(initx,inity,curvex(:,5));

p1y = table(initx,inity,curvey(:,1));
p2y = table(initx,inity,curvey(:,2));
p3y = table(initx,inity,curvey(:,3));
p4y = table(initx,inity,curvey(:,4));
p5y = table(initx,inity,curvey(:,5));

pf1x = fitlm(p1x,'poly44');
pf2x = fitlm(p2x,'poly44');
pf3x = fitlm(p3x,'poly44');
pf4x = fitlm(p4x,'poly44');
pf5x = fitlm(p5x,'poly44');

pf1y = fitlm(p1y,'poly44');
pf2y = fitlm(p2y,'poly44');
pf3y = fitlm(p3y,'poly44');
pf4y = fitlm(p4y,'poly44');
pf5y = fitlm(p5y,'poly44');

fitpx = [pf1x.predict(test) pf2x.predict(test) pf3x.predict(test) pf4x.predict(test) pf5x.predict(test)];
fitpy = [pf1y.predict(test) pf2y.predict(test) pf3y.predict(test) pf4y.predict(test) pf5y.predict(test)];

time = 0;
while polyval(fitpy,time)>=-.01
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


