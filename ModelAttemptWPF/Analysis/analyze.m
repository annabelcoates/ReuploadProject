clear;

script_path = fileparts(mfilename('fullpath'));
cd (script_path);

runParamsFileName = fullfile('..', 'runParams.txt');
runParamsFile = fopen(runParamsFileName, 'r');
runParams = textscan(runParamsFile, '%s', 'CommentStyle', '#');
runParams = runParams{1};
fclose(runParamsFile);

nRuns = str2num(runParams{1});
population = str2num(runParams{2});
nTrue = str2num(runParams{3});
nFake = str2num(runParams{4});
fakeShares=zeros(nRuns,population);
nFollowers=zeros(nRuns,population);

runParams_len = size(runParams);
runParams_len = runParams_len(1);
varParamVals = runParams{runParams_len};
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