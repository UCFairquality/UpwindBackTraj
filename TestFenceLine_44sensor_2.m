% for testing fenceline monitor approaches

clear; clc; close all; fclose all; format compact; format longG;

% stores hourly back traj coords
% start X, end X, start Y, end Y
L = load('hrlyBackTrajCoords_44sensor.mat');
L = L.hrlyBackTrajCoords;

if 1
    % how many consequevtive hours to test
    h = 2;

    Wind = load('SFCwind.mat');
    Wind = Wind.SFCwind;

    % store coords of intersection, and differences in angles
    twoHourLocation = nan(size(L,1)-1,3);

    for i = 1:size(L,1)-h+1

        fprintf('%d\n',i);
        line1 = L(i,:);
        line2 = L(i+1,:);

        if isequal(line1,line2)
            % no wind diff for 2 hours, can't do
            continue;
        end
        if any(isnan(line1)) || any(isnan(line2))
            % no data
            continue;
        end

        if any(abs(line1)>500)
            % line1 outside range, cut it to range
            % start X, end X, start Y, end Y
            [xi,yi] = polyxpoly(line1(1:2),line1(3:4),...
                [-500,500,500,-500,-500],[-500,-500,500,500,-500]);
            line1 = unique([xi,yi],'rows');            
            if size(line1,1) ~= 2
                fprintf('line1 is not right, skip.\n')
                continue;
            end
            clear xi yi
            % pause
            % hold on
            % plot(line1(1:2),line1(3:4),'-k')
            % plot(xi,yi,'-r','LineWidth',3)
            % plot([-500,500,500,-500,-500],[-500,-500,500,500,-500]);
            % pause
            % hold off 
        end

        if any(abs(line2)>500)
            [xi,yi] = polyxpoly(line2(1:2),line2(3:4),...
                [-500,500,500,-500,-500],[-500,-500,500,500,-500]);
            line2 = unique([xi,yi],'rows');            
            if size(line2,1) ~= 2
                fprintf('line2 is not right, skip.\n')
                continue;
            end            
            clear xi yi
        end

        [xi,yi] = polyxpoly( line1(1:2),line1(3:4), line2(1:2),line2(3:4));

        if isempty(xi) || isempty(yi)
            continue;
        end

        if 0
            hold on
            plot(line1(1:2),line1(3:4),'-k')
            plot(line2(1:2),line2(3:4),'-r')
            scatter(xi,yi,100,'r','filled')
            scatter(0,0,100,'k','filled')
            % xlim([-500 500])
            % ylim([-500 500])
            grid on
            box on
            hold off
            pause
            close all;
        end

        twoHourLocation(i,1:2) = [xi,yi];
        U10dir1 = Wind.U10dir(i);
        U10dir2 = Wind.U10dir(i+1);
        if abs(U10dir1-U10dir2)>180
            U10dirDiff = 360-abs(U10dir1-U10dir2);
        else
            U10dirDiff = abs(U10dir1-U10dir2);
        end
        twoHourLocation(i,3) = U10dirDiff;
    end
end

if 0  
  [N,C] = hist3([twoHourLocation(:,1), twoHourLocation(:,2)],[50 50],'CDataMode','auto');
  % contourf(C{1},C{2},N)
end