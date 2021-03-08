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
        disp(fileName)
        varParam = [varParamVals{varIdx} int2str(i)];
        nSharesPop=csvread(fileName,1,1);
        nFollowers(i,:)=nSharesPop(:,1);
        o(i,:)=nSharesPop(:,2);
        c(i,:)=nSharesPop(:,3);
        e(i,:)=nSharesPop(:,4);
        a(i,:)=nSharesPop(:,5);
        n(i,:)=nSharesPop(:,6);
        OL(i,:)=nSharesPop(:,7);
        trueShares(i,:)=nSharesPop(:,8);
        fakeShares(i,:)=nSharesPop(:,9);
        ratio(i,:)=nSharesPop(:,10);
        freqUse(i,:)=nSharesPop(:,11);
        sessionLength(i,:)=20.*(nSharesPop(:,12));
        shareFreq(i,:)=nSharesPop(:,13);
    end
    runParamsStruct.varParam.nFollowers=reshape(nFollowers,[1,nRuns*population]);
    runParamsStruct.varParam.o=reshape(o,[1,nRuns*population]);
    runParamsStruct.varParam.c=reshape(c,[1,nRuns*population]);
    runParamsStruct.varParam.e=reshape(e,[1,nRuns*population]);
    runParamsStruct.varParam.a=reshape(a,[1,nRuns*population]);
    runParamsStruct.varParam.n=reshape(n,[1,nRuns*population]);
    runParamsStruct.varParam.OL=reshape(OL,[1,nRuns.*population]);
    runParamsStruct.varParam.trueShares=reshape(trueShares,[1,nRuns*population]);
    runParamsStruct.varParam.fakeShares=reshape(fakeShares,[1,nRuns*population]);
    runParamsStruct.varParam.ratio=reshape(ratio,[1,nRuns*population]);
    runParamsStruct.varParam.freqUse=reshape(freqUse,[1,nRuns*population]);
    runParamsStruct.varParam.sessionLength=reshape(sessionLength,[1,nRuns*population]);
    % // TODO 
    % ? Should this be a ceiling function
    runParamsStruct.varParam.roundSL=ceil(runParamsStruct.sessionLength);
    runParamsStruct.varParam.shareFreq=reshape(shareFreq,[1,nRuns*population]);
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



%%

function []=myPlot(x,y,xtitle,ytitle)
    
    figure()
    scatter(x,y,3)
    xlabel(xtitle)
    ylabel(ytitle)
end