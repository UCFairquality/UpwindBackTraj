% extract only first layer data

datDir = 'D:\AERMOD\Output_10m_1km_Pt\Out_Compile';
outDir = 'D:\AERMOD\Output_10m_1km_Pt\Out_Compile_1stLayer';

% stores hourly back traj coords
% start X, end X, start Y, end Y
L = load('hrlyBackTrajCoords_12sensor.mat');
L = L.hrlyBackTrajCoords;

for y = 2018:2022
    for m = 1:12
        nDays = eomday(y,m);
        mthDat = nan(201,201,nDays,24);
        for d = 1:nDays
            % the concentration data should be 201 by 201 by 151 by 24
            thisDatFile = sprintf('%s\\%d_%d_%d.mat',datDir,y,m,d);
            fprintf('%s\n',thisDatFile);
            D = load(thisDatFile);
            D = D.thisDayDat;
            % only keep first layer
            mthDat(:,:,d,:) = D(:,:,1,:);      
        end
        outName = sprintf('%s\\%d_%d.mat',outDir,y,m);
        save(outName,'mthDat');
    end
end