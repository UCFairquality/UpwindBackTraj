% reads data in 200 by 200 m fenceline of source and compare with 1000 by
% 1000 m fence line
clear; clc; close all; fclose all; format compact; format longG;

datDir = 'D:\AERMOD\Output_10m_1km_Pt\Out_Compile_1stLayer';
% 200m data, 1000m data
allDat = cell(60,2);
i = 1;
for y = 2018:2022
    for m = 1:12
        datName = sprintf('%s\\%d_%d.mat',datDir,y,m);
        D = load(datName,'mthDat');
        fprintf('%s\n',datName);
        D = D.mthDat;        
        dat200m = [reshape( D(91,91:111,:,:),[],1 );  % upper fenceline
            reshape( D(91,91:111,:,:),[],1 );        % lower fenceline
            reshape( D(91:111,91,:,:),[],1 );          % left fenceline
            reshape( D(91:111,111,:,:),[],1 )];        % right fenceline
        % dat200m = dat200m(dat200m~=0);
        dat200m = max(dat200m);
        dat500m = [reshape( D(51,51:151,:,:),[],1 );  % upper fenceline
            reshape( D(151,51:151,:,:),[],1 );        % lower fenceline
            reshape( D(51:151,51,:,:),[],1 );         % left fenceline
            reshape( D(51:151,151,:,:),[],1 )];       % right fenceline
        % dat500m = dat500m(dat500m~=0);
        dat500m = max(dat500m);
        allDat{i,1} = dat200m;
        allDat{i,2} = dat500m;
        i = i + 1;
    end
end


allDat200m  = cell2mat(allDat(:,1));
allDat1000m = cell2mat(allDat(:,2));

% 1250 ug/m3 --> 1900 ppbv
d200m = allDat200m .* 1250 ./ 1900 ./ 1000;
d1000m = allDat1000m .* 1250 ./ 1900 ./ 1000;
% h1 = histogram(d200m,50,'DisplayStyle','stairs','LineWidth',1.5);
histogram(d200m,'DisplayStyle','stairs','LineWidth',1.5);
hold on;
% h2 = histogram(d1000m,20,'DisplayStyle','stairs','LineWidth',1.5);
histogram(d1000m,'DisplayStyle','stairs','LineWidth',1.5);
yscale log;
% xlim([0 180]);
% ylim([0 1E7]);
box on;
xlabel('CH4 concentration (ppm)');
ylabel('# measurement along fenceline');
legend({'200m fenceline';'1000m fenceline'})
fontsize(16,"points")
% histogram(log(allDat200m),10)
% hold on;
% histogram(log(allDat500m),10)
% ecdf(allDat200m);
% hold on
% ecdf(allDat500m);


boxplot(d200m);
xlabel('200m fenceline distance')
ylabel('max concentration along fenceline (ppm)')
fontsize(16,"points")