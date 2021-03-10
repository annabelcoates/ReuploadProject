csvFiles = {
    'nSharesPopulation'
    'nSharesAll'
    'nViewsAll'
    'newsInfo'
    'sharersAll'
    'viewersAll'
    'nSharedFakeNews'
    'FacebookUK'
    'nSharedFakeNews'
    'small_world_graph'
    'fakeShareProbs'
    'trueShareProbs'
    'follows'
}

scriptPath = fileparts(mfilename('fullpath'));
cd (scriptPath);
timesList = loadTimes(scriptPath);
lastTime = size(timesList);
lastTime = lastTime(1);
desiredRun = timesList{lastTime};
topResultsPath = fullfile(scriptPath, '..', 'Results', desiredRun);
saveFolderPath = fullfile(topResultsPath, 'AnalysisResults');
if ~exist(saveFolderPath, 'dir')
    mkdir(saveFolderPath)
end

%%

runParamsInputFilePath = fullfile(topResultsPath, 'runParams.txt');
runParamsInputFile = fopen(runParamsInputFilePath, 'r');
runParamsInput = textscan(runParamsInputFile, '%s', 'CommentStyle', '#');
runParamsInput = runParamsInput{1};
fclose(runParamsInputFile);

nRuns = str2num(runParamsInput{1});
population = str2num(runParamsInput{2});
nFake = str2num(runParamsInput{3});
nTrue = str2num(runParamsInput{4});
timeOfRun = runParamsInput{5};
fakeShares=zeros(nRuns,population);
nFollowers=zeros(nRuns,population);

%%
% copyfile(runParamsInputFilePath, saveFolderPath);

%%

runParamsInput_len = size(runParamsInput);
runParamsInput_len = runParamsInput_len(1);
varParamVals = runParamsInput{runParamsInput_len};
varParamVals = strsplit(varParamVals, ',');
varParamVals_len = size(varParamVals);
varParamVals_len = varParamVals_len(2);
for idx = 1:varParamVals_len
    varParamVals{idx} = ['OL' varParamVals{idx} '_'];
end

for csvFile in csvFiles
% csvFiles = 'nSharesPopulation'
    resultsPaths.(csvFile) = cell(nRuns, varParamVals_len);
    for i = 1:nRuns
        for j = 1:varParamVals_len
            tempVarParamVals = strcat(varParamVals, int2str(i));
            tempPath = fullfile(...
            topResultsPath, tempVarParamVals);
            resultsPaths.(csvFile){i, j} = fullfile(tempPath{j}, [csvFile 'csv']);
        end
    end
end

for csvFile in csvFiles
    for varIdx = 1:varParamVals_len

        if csvFile == 

        for i=1:nRuns
            fileName = resultsPaths{i, varIdx};
            nSharesPop=csvread(fileName,1,1);
            nFollowers(i,:)=nSharesPop(:,1);
            opn(i,:)=nSharesPop(:,2);
            con(i,:)=nSharesPop(:,3);
            ext(i,:)=nSharesPop(:,4);
            agr(i,:)=nSharesPop(:,5);
            nrt(i,:)=nSharesPop(:,6);
            OL(i,:)=nSharesPop(:,7);
            pol(i,:)=nSharesPop(:,8); % Political
            fakeShares(i,:)=nSharesPop(:,9);
            trueShares(i,:)=nSharesPop(:,10); % True
            frqUse(i,:)=nSharesPop(:,11);
            sesLen(i,:)=20.*(nSharesPop(:,12));
            shareFreq(i,:)=nSharesPop(:,13);
            emoState(i,:)=nSharesPop(:,14);
        end
        varParam = erase(varParamVals{varIdx}, '_');

    %%
    % Plot Parameters Names
        runParamsStruct.(varParam).nFollowers_flat=reshape(nFollowers,[1,nRuns*population]);
        runParamsStruct.(varParam).opn_flat=reshape(opn,[1,nRuns*population]);
        runParamsStruct.(varParam).con_flat=reshape(con,[1,nRuns*population]);
        runParamsStruct.(varParam).ext_flat=reshape(ext,[1,nRuns*population]);
        runParamsStruct.(varParam).agr_flat=reshape(agr,[1,nRuns*population]);
        runParamsStruct.(varParam).nrt_flat=reshape(nrt,[1,nRuns*population]);
        runParamsStruct.(varParam).OL_flat=reshape(OL,[1,nRuns.*population]);
        runParamsStruct.(varParam).pol_flat=reshape(pol,[1,nRuns*population]);
        runParamsStruct.(varParam).fakeShares_flat=reshape(fakeShares,[1,nRuns*population]);
        runParamsStruct.(varParam).trueShares_flat=reshape(trueShares,[1,nRuns*population]);
        tempRatio_flat = runParamsStruct.(varParam).trueShares_flat + runParamsStruct.(varParam).fakeShares_flat;
        runParamsStruct.(varParam).ratioShares_flat = runParamsStruct.(varParam).fakeShares_flat ./ tempRatio_flat;
        runParamsStruct.(varParam).frqUse_flat=reshape(frqUse,[1,nRuns*population]);
        runParamsStruct.(varParam).sesLen_flat=reshape(sesLen,[1,nRuns*population]);
        % // TODO 
        % ? Should this be a ceiling function
        runParamsStruct.(varParam).roundSL_flat=ceil(runParamsStruct.(varParam).sesLen_flat);
        runParamsStruct.(varParam).shareFreq_flat=reshape(shareFreq,[1,nRuns*population]);
        runParamsStruct.(varParam).emoState_flat=reshape(emoState,[1,nRuns*population]);

        runParamsStruct.(varParam).nFollowers_mat=nFollowers;
        runParamsStruct.(varParam).opn_mat=opn;
        runParamsStruct.(varParam).con_mat=con;
        runParamsStruct.(varParam).ext_mat=ext;
        runParamsStruct.(varParam).agr_mat=agr;
        runParamsStruct.(varParam).nrt_mat=nrt;
        runParamsStruct.(varParam).OL_mat=OL;
        runParamsStruct.(varParam).pol_mat=pol;
        runParamsStruct.(varParam).fakeShares_mat=fakeShares;
        runParamsStruct.(varParam).trueShares_mat=trueShares;
        tempRatio_mat = runParamsStruct.(varParam).trueShares_mat + runParamsStruct.(varParam).fakeShares_mat;
        runParamsStruct.(varParam).ratioShares_mat = runParamsStruct.(varParam).fakeShares_mat ./ tempRatio_mat;
        runParamsStruct.(varParam).frqUse_mat=frqUse;
        runParamsStruct.(varParam).sesLen_mat=sesLen;
        % // TODO 
        % ? Should this be a ceiling function
        runParamsStruct.(varParam).roundSL_mat=ceil(runParamsStruct.(varParam).sesLen_mat);
        runParamsStruct.(varParam).shareFreq_mat=shareFreq;
        runParamsStruct.(varParam).emoState_mat=emoState;
    end
end
%%

plotParamsFilePath = fullfile('..', 'plotParams.txt');
plotParamsFile = fopen(plotParamsFilePath, 'r');
plotParamsString = textscan(plotParamsFile, '%s', 'CommentStyle', '#');
plotParamsString = plotParamsString{1};
fclose(plotParamsFile);

plotParamsString_len = size(plotParamsString);
plotParamsString_len = plotParamsString_len(1);
plotParams = cell(plotParamsString_len, 2);
for idx = 1:plotParamsString_len
    splitPlotParamString = plotParamsString{idx};
    splitPlotParamString = strsplit(splitPlotParamString, ',');
    plotParams{idx, 1} = splitPlotParamString{1};
    plotParams{idx, 2} = splitPlotParamString{2};
end

%%

for idx = 1:plotParamsString_len
    myPlot(plotParams{idx, 1}, plotParams{idx, 2}, runParamsStruct, varParamVals, saveFolderPath)
end

%%

function []=myPlot(x, y, runParamsStruct, varParamVals, saveFolderPath)
    varParamVals_len = size(varParamVals);
    varParamVals_len = varParamVals_len(2);
    for varIdx = 1:varParamVals_len
        varParam = erase(varParamVals{varIdx}, '_');
        figure('visible', 'off');
        if isempty(y)
            histogram(...
                runParamsStruct.(varParam).([x '_flat']),...
                100,'Normalization','pdf');
            xlabel([x '\_flat']);
            ylabel('PDF');
            figName = [varParam ' Histogram plot of ' [x '\_flat']];
            saveName = [varParam ' Histogram plot of ' [x '_flat']];
            savePath = fullfile(saveFolderPath, [saveName '.png']);
            title(figName);
            saveas(gcf, [savePath '.png']);
        else
            hold on;
            xax = runParamsStruct.(varParam).([x '_flat']);
            yax = runParamsStruct.(varParam).([y '_flat']);
            scatter(...
                xax,...
                yax,...
                3);
            lsline;
            xlabel([x '\_flat']);
            ylabel([y '\_flat']);
            figName = [varParam ' Scatter plot of ' [x '\_flat'] ' against ' [y '\_flat']];
            saveName = [varParam ' Scatter plot of ' [x '_flat'] ' against ' [y '_flat']];
            savePath = fullfile(saveFolderPath, [saveName '.png']);
            title(figName);
            saveas(gcf, [savePath '.png']);
            hold off;
        end
    end
end

function [timesList]=loadTimes(scriptPath)
    timesPath = fullfile(scriptPath, '..', 'timesOfRuns.txt');

    timesFile = fopen(timesPath, 'r');
    timesList = textscan(timesFile, '%s', 'CommentStyle', '#');
    fclose(timesFile);
    timesList = timesList{1};
end