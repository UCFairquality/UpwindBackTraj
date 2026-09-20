% for testing fenceline monitor approaches
% define

clear; clc; close all; fclose all; format compact; format longG;

% L stores hourly back traj coords
% start X, end X, start Y, end Y
L = load('hrlyBackTrajCoords.mat');
L = L.hrlyBackTrajCoords;

if 0
    % how many consequevtive hours to test
    h = 4;

    Wind = load('SFCwind.mat');
    Wind = Wind.SFCwind;

    % find hours with the max wind direction differences

    %
    %     % store coords of intersection, and differences in angles
    %     twoHourLocation = nan(size(L,1)-1,3);
    %
    %     for i = 1:size(L,1)-h+1
    %
    %         fprintf('%d\n',i);
    %         line1 = L(i,:);
    %         line2 = L(i+1,:);
    %
    %         if isequal(line1,line2)
    %             % no wind diff for 2 hours, can't do
    %             continue;
    %         end
    %         if any(isnan(line1)) || any(isnan(line2))
    %             % no data
    %             continue;
    %         end
    %
    %         if any(abs(line1)>500)
    %             % line1 outside range, cut it to range
    %             % start X, end X, start Y, end Y
    %             [xi,yi] = polyxpoly(line1(1:2),line1(3:4),...
    %                 [-500,500,500,-500,-500],[-500,-500,500,500,-500]);
    %             line1 = unique([xi,yi],'rows');
    %             if size(line1,1) ~= 2
    %                 fprintf('line1 is not right, skip.\n')
    %                 continue;
    %             end
    %             clear xi yi
    %             % pause
    %             % hold on
    %             % plot(line1(1:2),line1(3:4),'-k')
    %             % plot(xi,yi,'-r','LineWidth',3)
    %             % plot([-500,500,500,-500,-500],[-500,-500,500,500,-500]);
    %             % pause
    %             % hold off
    %         end
    %
    %         if any(abs(line2)>500)
    %             [xi,yi] = polyxpoly(line2(1:2),line2(3:4),...
    %                 [-500,500,500,-500,-500],[-500,-500,500,500,-500]);
    %             line2 = unique([xi,yi],'rows');
    %             if size(line2,1) ~= 2
    %                 fprintf('line2 is not right, skip.\n')
    %                 continue;
    %             end
    %             clear xi yi
    %         end
    %
    %         [xi,yi] = polyxpoly( line1(1:2),line1(3:4), line2(1:2),line2(3:4));
    %
    %         if isempty(xi) || isempty(yi)
    %             continue;
    %         end
    %
    %         if 0
    %             hold on
    %             plot(line1(1:2),line1(3:4),'-k')
    %             plot(line2(1:2),line2(3:4),'-r')
    %             scatter(xi,yi,100,'r','filled')
    %             scatter(0,0,100,'k','filled')
    %             % xlim([-500 500])
    %             % ylim([-500 500])
    %             grid on
    %             box on
    %             hold off
    %             pause
    %             close all;
    %         end
    %
    %         twoHourLocation(i,1:2) = [xi,yi];
    %         U10dir1 = Wind.U10dir(i);
    %         U10dir2 = Wind.U10dir(i+1);
    %         if abs(U10dir1-U10dir2)>180
    %             U10dirDiff = 360-abs(U10dir1-U10dir2);
    %         else
    %             U10dirDiff = abs(U10dir1-U10dir2);
    %         end
    %         twoHourLocation(i,3) = U10dirDiff;
    %     end
end

% if 0
%   [N,C] = hist3([twoHourLocation(:,1), twoHourLocation(:,2)],[50 50],'CDataMode','auto');
%   % contourf(C{1},C{2},N)
% end


function [r,c,diffMax] = calMaxWindDir(W)
% W = load('SFCwind.mat');
% W = W.SFCwind;
% W = W.U10dir(1:5);

% W is wind direction data. single column
nHr = size(W,1);
% for n hours of wind dir, there are 1+2+3+....+n-1 pairs of diff
diffMat = nan(nHr,nHr);

% compare 1&2, 1&3 ... 1&n, 2&3,.... 2&n, ... n-1&n
for i = 1:nHr-1
    for k = i+1:nHr
        D1 = W(i);
        D2 = W(k);
        % sometimes wind directions too big
        if D1 > 360 
            D1 = D1 - 360;
        end
        if D2 > 360 
            D2 = D2 - 360;
        end
        dirDiff = abs(D2-D1);
        if dirDiff > 180
            dirDiff = 360 - dirDiff;
        end
        if dirDiff < 0
            error('something is not right.\n');
        end
        % fprintf('%d, %d.   %d  %d  %d\n',i,k,D1,D2,dirDiff);
        diffMat(i,k) = dirDiff;
    end
end
diffMax = max(max(diffMat));
if isnan(diffMax)
    error('are you kidding me.\n');
end
[r,c] = find(diffMat == diffMax);

end