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
nFake = str2num(runParamsInput{3});
nTrue = str2num(runParamsInput{4});
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
        tempVarParamVals = strcat(varParamVals, int2str(i));
        tempPath = fullfile(...
        '..','Results', tempVarParamVals);
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
folderName = ['AnalysisResults ' folderName ];
mkdir(folderName);

%%

for idx = 1:plotParamsString_len
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
                runParamsStruct.(varParam).([x '_flat']),...
                100,'Normalization','pdf');
            xlabel([x '\_flat']);
            ylabel('PDF');
            figName = [varParam ' Histogram plot of ' [x '\_flat']];
            saveName = [varParam ' Histogram plot of ' [x '_flat']];
            savePath = fullfile(folderName, [saveName '.png']);
            title(figName);
            saveas(gcf, [savePath '.png']);
        else
            figure();
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
            savePath = fullfile(folderName, [saveName '.png']);
            title(figName);
            saveas(gcf, [savePath '.png']);
            hold off;
        end
    end
end