function newPositions = scrambleTriangle(positions)
    errorVector = zeros(3, 2); %Error vectors will be drawn from polar coordinates, of magnitude less than 5m and any angle
for i = 1:3
    r = 0.005*rand; %These are our r's/magnitudes in kilometers

    theta = 2*pi*rand; %These are our arguments/angles/theta's

    xdisp = r*cos(theta);

    ydisp = r*sin(theta);

    errorVector(i, :) = [xdisp ydisp];
end

newPositions = zeros(3, 2);
%FORMAT OF POSITIONS AND NEW POSITIONS is 3 x 2 matrix:
%[LAT1----LON1]
%[LAT2----LON2]
%[LAT3----LON3]
for i = 1:3
    newPositions(i, :) = findNewPosition(positions(i, :), errorVector(i, :));
end
end
