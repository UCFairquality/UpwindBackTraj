% for testing fenceline monitor approaches

clear; clc; close all; fclose all; format compact; format longG;

datDir = 'D:\AERMOD\Output_10m_1km_Pt\Out_Compile';

% wind direction is counterclock wise here
Wind = load('SFCwind.mat');
Wind = Wind.SFCwind;

Coords = load('Coords_10m.mat');
X = Coords.X(:,:,1);
Y = Coords.Y(:,:,1);

% stores hourly back traj coords
% start X, end X, start Y, end Y
hrlyBackTrajCoords = nan(43824,4);

monSpacing = 51:5:151;

for dNum = 1:1826

    [y,m,d] = ymd(datetime(2018,1,1)+dNum-1);

    % y = 2018;
    % m = 1;
    % d = 1;
    % h = 1;

    % the concentration data should be 201 by 201 by 151 by 24
    thisDatFile = sprintf('%s\\%d_%d_%d.mat',datDir,y,m,d);
    fprintf('%s\n',thisDatFile);
    D = load(thisDatFile);
    D = D.thisDayDat;

    for h = 1:24       

        Widx = Wind.Year==y-2000 & Wind.Mth==m & Wind.Day==d & Wind.Hour==h;
        Wspd = Wind.U10(Widx);
        Wdir = Wind.U10dir(Widx);

        if isnan(Wdir)
            continue;
        elseif Wspd==0
            % calm hour, no data
            continue;
        elseif Wdir>360
            % missing data for wind direction
            continue;
        end

        if Wdir == 360
            Wdir = 0;
        end

        % plot concentration field
        if 0
            hold on;
            plotD = (D(:,:,1,1));
            plotD(plotD<10) = 0;
            plotD = log10(plotD);
            ax1 = axes;
            mapshow(X(:,:,1),Y(:,:,1),plotD,'DisplayType','surface','FaceAlpha',0.5);
            ax1.Visible = 'off';     ax1.XTick = [];     ax1.YTick = [];
            xlim([-1000 1000]); ylim([-1000 1000]); axis square;
            colormap(ax1,'gray');
            % cmap = colormap(parula(1024));
            % cmap(1,:) = [1 1 1];

            % assemble a table for plot
            % the fenceline is 1000 by 1000 m around the center
            Conc = [plotD(51:151,51);  % left fenceline
                plotD(151,51:151)';    % bottom fenceline
                plotD(51:151,151);     % right fenceline
                plotD(51,51:151)'];    % top fenceline
            plotX = [X(51:151,51);     % left fenceline
                X(151,51:151)';        % bottom fenceline
                X(51:151,151);         % right fenceline
                X(51,51:151)'];        % top fenceline
            plotY = [Y(51:151,51);     % left fenceline
                Y(151,51:151)';        % bottom fenceline
                Y(51:151,151);         % right fenceline
                Y(51,51:151)'];        % top fenceline
            fenceLine = table(plotX,plotY,Conc);
            ax2 = axes;
            scatter(fenceLine,'plotX','plotY','filled','ColorVariable','Conc',...
                'MarkerEdgeColor','k');
            ax2.Visible = 'off';     ax2.XTick = [];    ax2.YTick = [];
            xlim([-1000 1000]); ylim([-1000 1000]); axis square;
            colormap(ax2,'jet');
            hold off
            
            % set([ax1,ax2],'Position',[.17 .11 .685 .815]);
            % cb1 = colorbar(ax1,'Location','west');
            % cb2 = colorbar(ax2,'Location','east');
            %cb1 = colorbar(ax1,'Position',[.05 .11 .0675 .815]);
            %cb2 = colorbar(ax2,'Position',[.88 .11 .0675 .815]);
        end

        % plot reverse line
        if 1
            % assemble a table for plot
            % the fenceline is 1000 by 1000 m around the center
            plotD = D(:,:,1,h);
            plotD(plotD<10) = 0;
            
            Conc = [plotD(monSpacing,51); plotD(151,monSpacing)';
                plotD(monSpacing,151); plotD(51,monSpacing)'];
            plotX = [X(monSpacing,51); X(151,monSpacing)';
                X(monSpacing,151); X(51,monSpacing)'];
            plotY = [Y(monSpacing,51); Y(151,monSpacing)';
                Y(monSpacing,151); Y(51,monSpacing)'];

            % find which fenceline sensor has the max
            maxIdx = Conc==max(Conc);
            maxX   = plotX(maxIdx);
            maxY   = plotY(maxIdx);

            if size(maxX,1) > 1
                maxX = maxX(1);
                maxY = maxY(1);
            end
            % calculate back trajaority line
            if Wdir>=0 && Wdir<90
                % wind from N or NE, back traj line ends at y = 500
                backTrajX = maxX + tand(Wdir) * (500-maxY);
                backTrajY = 500;
            elseif Wdir>=90 && Wdir<180
                % wind from E or SE, back traj line ends at x = 500
                backTrajX = 500;
                backTrajY = maxY - tand(Wdir-90) * (500-maxX);
            elseif Wdir>=180 && Wdir<270
                % wind from S or SW, back traj line ends at y = -500
                backTrajX = maxX - tand(Wdir-180) * (maxY+500);
                backTrajY = -500;
            elseif Wdir>=270 && Wdir<360
                % wind from W or NW, back traj line ends at x = -500
                backTrajX = -500;
                backTrajY = maxY + tand(Wdir-270)* (maxX+500);
            else
                fprintf('%d %d %d %d %d\n',y,m,d,h,Wdir);
                error('this is not supposed to happen, yet here we are.');
            end

            datIdx = dNum*24 - 24 + h;
            hrlyBackTrajCoords(datIdx,:) = [maxX backTrajX maxY backTrajY];

            if 0
                hold on;
                fenceLine = table(plotX,plotY,Conc);
                scatter(fenceLine,'plotX','plotY','filled','ColorVariable','Conc',...
                    'MarkerEdgeColor','k');
                ax2.Visible = 'off';     ax2.XTick = [];    ax2.YTick = [];
                % xlim([-1000 1000]); ylim([-1000 1000]); axis square;
                % colormap('jet');
                plot([maxX backTrajX],[maxY backTrajY],'--r','LineWidth',2);
                scatter(0,0,100,'filled')
                hold off

                pause
                close all;
            end

            % fenceLine = table(plotX,plotY,Conc);
            % scatter(fenceLine,'plotX','plotY','filled','ColorVariable','Conc',...
            %     'MarkerEdgeColor','k');
            % ax2.Visible = 'off';     ax2.XTick = [];    ax2.YTick = [];
            % xlim([-1000 1000]); ylim([-1000 1000]); axis square;
            % colormap(ax2,'jet');

        end

    end

end


% hold on
% for i = 1:24
%     plot(hrlyBackTrajCoords(i,1:2),hrlyBackTrajCoords(i,3:4),'-k')
% end
% xlim([-500 500]);
% ylim([-500 500]);
% axis square;
% hold off