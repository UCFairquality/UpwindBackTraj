clear; clc; close all; fclose all; format compact; format longG;

% load('twoHourLocation_12sensor.mat')
% load('twoHourLocation_24sensor.mat')
% load('twoHourLocation_44sensor.mat')
% load('twoHourLocation_84sensor.mat')
% load('twoHourLocation_204sensor.mat')
load('twoHourLocation.mat');

D = twoHourLocation;
idx1 = abs(D(:,1))==500;
idx2 = abs(D(:,2))==500;
idx = idx1|idx2;
D(idx,:) = NaN;

[N,C] = hist3([D(:,1), D(:,2)],[50 50],'CDataMode','auto');
% imagesc(N);
% axis square; box on; 
% colorbar;

% xticklabels({});
% yticklabels({});
% clim([0 5000]);
% grid on

% within 50 m
Dist = ( D(:,1).^2 + D(:,2).^2 ).^0.5;
sum(Dist<50)
sum(Dist<50)./43823

sum(~isnan(Dist))
sum(~isnan(Dist))./43823
% sum()
% f = gca;
% exportgraphics(f,'400sensors.png','Resolution',300)