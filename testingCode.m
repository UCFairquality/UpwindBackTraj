clear; clc;

outDir = 'D:\AERMOD\Output_10m_1km_Pt\Out_Compile_1stLayer';

Coords = load('Coords_10m.mat');
X = Coords.X(:,:,1);
Y = Coords.Y(:,:,1);

% locations and rate to test
% srcX = (-100:50:100)'; % m;
srcX = 0; % m;
srcY = srcX;           % m
srcE = 100';   % kg per hour;

y = 2018;
m = 1;
d = 1;
h = 1;
mthD  = load(sprintf('%s\\%d_%d.mat',outDir,y,m));
mthD  = mthD.mthDat;
plotD = mthD(:,:,d,h);

monSpacing = 51:1:151;

% fence line
Conc = [plotD(monSpacing,51); plotD(151,monSpacing)';
    plotD(monSpacing,151); plotD(51,monSpacing)'];
plotX = [X(monSpacing,51); X(151,monSpacing)';
    X(monSpacing,151); X(51,monSpacing)'];
plotY = [Y(monSpacing,51); Y(151,monSpacing)';
    Y(monSpacing,151); Y(51,monSpacing)'];

% fenceLine = table(plotX,plotY,Conc);
% hold on
% scatter(fenceLine,'plotX','plotY','filled','ColorVariable','Conc',...
%     'MarkerEdgeColor','k');

thisX = 0;
thisY = 0;

theta = 95;
plotX1 = (plotX-thisX) .* cosd(theta) - ...
    (plotY-thisY) .* sind(theta);
plotY1 = (plotX-thisX) .* sind(theta) + ...
    (plotY-thisY) .* cosd(theta);

CMP = [plotX plotX1 plotY plotY1];

% % Create rotation matrix
% theta = 45; % to rotate 90 counterclockwise
% R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
% % Rotate your point(s)
% point = [0 1]'; % arbitrarily selected
% rotpoint = R * point;
%
% hold on
% scatter(point(1),point(2),'k','filled');
% scatter(rotpoint(1),rotpoint(2),'r','filled');
% axis square
% xlim([-3 3])
% ylim([-3 3])
% grid on
% hold off