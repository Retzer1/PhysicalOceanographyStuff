function centers = discModelPlot(x0,y0,xc,yc,r,fs,fb,n,fraction, struc) %Initial point is taken to be along outside of circles
%r must be less than R, n is the number of steps to calculate, x0/y0 is
%initial position, xc/yc is center of big circle, fs is frequency of small
%circle and fb is frequency of big circle

%fb determines how far around circle we go, generally fs > fb
%Fraction is what fraction of big circle's circumference we cover, 

R = sqrt((x0-xc)^2 + (y0 - yc)^2); %Distance from initial point to center of big circle
cosAngle = (x0 - xc)/R;
sinAngle = (y0 - yc)/R;

%FIND INITIAL ANGLE, = angle
if (cosAngle >=0 && sinAngle >= 0) || (cosAngle <=0 && sinAngle >= 0)
    angle = acos(cosAngle);
end

if (cosAngle <=0 && sinAngle <= 0) || (cosAngle >=0 && sinAngle <= 0)
    angle = -1*acos(cosAngle);
end

%Positions in altered/wrong coordinate system
t0 = 0;
tf = fraction*1/fb; 
stepSize = (tf - t0)/n;

X = (R - r)*cos(2*pi*fb*(t0:stepSize:tf)) + r*cos(2*pi*fs*(t0:stepSize:tf));
Y = (R - r)*sin(2*pi*fb*(t0:stepSize:tf)) + r*sin(2*pi*fs*(t0:stepSize:tf));

centerX = (R - r)*cos(2*pi*fb*(t0:stepSize:tf));
centerY = (R - r)*sin(2*pi*fb*(t0:stepSize:tf));

%Rotate by angle to obtain correct position vectors, use rotation matrix
positions = cat(1, X, Y);
actualPositions = [cos(angle) -1*sin(angle); sin(angle) cos(angle)] * positions;

centerPositions = cat(1, centerX, centerY);
actualCenterPositions = [cos(angle) -1*sin(angle); sin(angle) cos(angle)] * centerPositions;
%BEST SO FAR: discModelPlot(2.49086, 40.3165, 2.55, 40.24, 0.027, 55, 3,
%2373-879, 0.355, OGS_50m), using 50m drifter #1, indices 879 to 2373

%Note: OGS_50m #1's datenum 879 to 2373 is the datenum 879 to 2373 for
%entire struc OGS_50m, thanks to ordering of dataset

%Plot on cartesian plane
figure
%xy_static_trajectory(1, struc, 1)
%plot(struc(1).lon(878:2372), struc(1).lat(878:2372))%, corresponds to
%curveFit50m photo

%FOR CARTHE
plot(struc(8).lon, struc(8).lat)

hold on
%plot(actualPositions(1, :)+xc, actualPositions(2, :)+yc, 'color', 'red', 'Marker', '*');
plot(actualPositions(1, :)+xc, actualPositions(2, :)+yc, 'color', 'red');
centers = actualCenterPositions;
centers(1, :) = centers(1, :) + xc;
centers(2, :) = centers(2, :) + yc;


%NOTBAD
%discModelPlot(2.49921, 40.3171, 2.55, 40.24, 0.015, 70, 2.9, 2373-879, 0.415, selectedCARTHE)


%With discModelPlot(2.49921, 40.3171, 2.55, 40.24, 0.015, 70, 3, 2373-879,
%0.41, selectedCARTHE), keep up to #834 for drifter #8, that is 1:834
%(which is really something different)


%USE discModelPlot(2.49921, 40.3171, 2.55, 40.24, 0.015, 70, 3, 834, 0.22, selectedCARTHE)
%Run vorticity on actualSelectedCARTHE, selected50m datasets
%Use discModelPlot(2.49086, 40.3165, 2.55, 40.24, 0.027, 55, 3, 2373-879,
%0.355, OGS_50m) for 50m
end