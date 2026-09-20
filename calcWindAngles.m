clear; clc; close all; fclose all; format compact; format longG;

% wind direction is counterclock wise here
W = load('SFCwind.mat');
W = W.SFCwind.U10dir;

h = 24; % do how many hours average

nHr = size(W,1)-h+1;
maxDiff = nan(nHr,1);
for i = 1:nHr
    S = W(i:i+h-1);
    % for n hours of wind dir, there are 1+2+3+....+n-1 pairs of diff
    distVec = nan( sum(1:size(S,1)-1),1 );
    k = 1;
    for m = 1:size(S,1)-1
        for n = m+1:size(S,1)
            D1 = S(m);
            if D1 > 360
                continue;
            end
            D2 = S(n);
            if D2 > 360
                continue;
            end
            dirDiff = abs(D2-D1);
            if dirDiff>180
                dirDiff = 360 - dirDiff;
                if dirDiff < 0
                    pause
                end
            end
            distVec(k) = dirDiff;
            k = k + 1;
            % fprintf('%d, %d %d, %d %d %d\n',i,m,n,D1,D2,dirDiff);
            % distVec
            % pause
        end
    end 
    maxDiff(i) = max(distVec);
end

nanmean(maxDiff)
nanmedian(maxDiff)
prctile(maxDiff,10)

