clear;

script_path = fileparts(mfilename('fullpath'));
cd (script_path);

runParamsInputFileName = fullfile('..', 'runParams.txt');
runParamsInputFile = fopen(runParamsInputFileName, 'r');
runParamsInput = textscan(runParamsInputFile, '%s', 'CommentStyle', '#');
runParamsInput = runParamsInput{1};
fclose(runParamsInputFile);

nRuns = str2num(runParamsInput{1});
population = str2num(runParamsInput{2});
nTrue = str2num(runParamsInput{3});
nFake = str2num(runParamsInput{4});
fakeShares=zeros(nRuns,population);
nFollowers=zeros(nRuns,population);

runParamsInput_len = size(runParamsInput);
runParamsInput_len = runParamsInput_len(1);
varParamVals = runParamsInput{runParamsInput_len};
varParamVals = strsplit(varParamVals, ',');
varParamVals_len = size(varParamVals);
varParamVals_len = varParamVals_len(2);
for idx = 1:varParamVals_len
    varParamVals{idx} = ['OL' varParamVals{idx} '_'];
end

resultsPaths = cell(nRuns, varParamVals_len);
for i = 1:nRuns
    for j = 1:varParamVals_len
        tempPath = fullfile(...
        '..','Results', {['OL40_' int2str(i)], ...
        ['OL60_' int2str(i)]});
        resultsPaths{i, j} = fullfile(tempPath{j}, 'nSharesPopulation.csv');
    end
end

%%

for varIdx = 1:varParamVals_len
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
    end
    varParam = erase(varParamVals{varIdx}, '_');

%%
% Plot Parameters Names
    runParamsStruct.(varParam).nFollowers=reshape(nFollowers,[1,nRuns*population]);
    runParamsStruct.(varParam).opn=reshape(opn,[1,nRuns*population]);
    runParamsStruct.(varParam).con=reshape(con,[1,nRuns*population]);
    runParamsStruct.(varParam).ext=reshape(ext,[1,nRuns*population]);
    runParamsStruct.(varParam).agr=reshape(agr,[1,nRuns*population]);
    runParamsStruct.(varParam).nrt=reshape(nrt,[1,nRuns*population]);
    runParamsStruct.(varParam).OL=reshape(OL,[1,nRuns.*population]);
    runParamsStruct.(varParam).pol=reshape(pol,[1,nRuns*population]);
    runParamsStruct.(varParam).fakeShares=reshape(fakeShares,[1,nRuns*population]);
    runParamsStruct.(varParam).trueShares=reshape(trueShares,[1,nRuns*population]);
    tempRatio = runParamsStruct.(varParam).trueShares + runParamsStruct.(varParam).fakeShares;
    runParamsStruct.(varParam).ratioShares = runParamsStruct.(varParam).fakeShares ./ tempRatio;
    runParamsStruct.(varParam).frqUse=reshape(frqUse,[1,nRuns*population]);
    runParamsStruct.(varParam).sesLen=reshape(sesLen,[1,nRuns*population]);
    % // TODO 
    % ? Should this be a ceiling function
    runParamsStruct.(varParam).roundSL=ceil(runParamsStruct.(varParam).sesLen);
    runParamsStruct.(varParam).shareFreq=reshape(shareFreq,[1,nRuns*population]);
end
%%

plotParamsFileName = fullfile('..', 'plotParams.txt');
plotParamsFile = fopen(plotParamsFileName, 'r');
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

folderName = datestr(datetime('now'));
folderName = strrep(folderName,':','-');
folderName = [folderName ' Analysis'];
mkdir(folderName);

%%

for idx = 1:plotParamsString_len
    disp(idx)
    myPlot(plotParams{idx, 1}, plotParams{idx, 2}, runParamsStruct, varParamVals, folderName)
end
%%

function []=myPlot(x, y, runParamsStruct, varParamVals, folderName)
    varParamVals_len = size(varParamVals);
    varParamVals_len = varParamVals_len(2);
    for varIdx = 1:varParamVals_len
        varParam = erase(varParamVals{varIdx}, '_');
        if isempty(y)
            figure();
            histogram(...
                runParamsStruct.(varParam).(x),...
                100,'Normalization','pdf');
            xlabel(x);
            ylabel('PDF');
            figName = [varParam ' Histogram plot of ' x];
            savePath = fullfile(folderName, [figName '.png']);
            title(figName);
            saveas(gcf, [savePath '.png']);
        else
            figure();
            scatter(...
                runParamsStruct.(varParam).(x),...
                runParamsStruct.(varParam).(y),...
                3);
            xlabel(x);
            ylabel(y);
            figName = [varParam ' Scatter plot of ' x ' against ' y];
            savePath = fullfile(folderName, [figName '.png']);
            title(figName);
            saveas(gcf, [savePath '.png']);
        end
    end
end