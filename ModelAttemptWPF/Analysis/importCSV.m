function csvStruct=import(csvFileName, desiredSim)
    scriptPath = fileparts(mfilename('fullpath'));
    cd (scriptPath);
    topResultsPath = fullfile(scriptPath, '..', 'Results', desiredSim);
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
    variableSetting = runParamsInput{6};
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
        varParamVals{idx} = ['OL' varParamVals{idx}];
    end

    resultsPaths = cell(nRuns, varParamVals_len);
    for i = 1:nRuns
        for j = 1:varParamVals_len
            tempVarParamVals = strcat(varParamVals, '_');
            tempVarParamVals = strcat(tempVarParamVals, int2str(i));
            tempPath = fullfile(...
            topResultsPath, tempVarParamVals);
            resultsPaths{i, j} = fullfile(tempPath{j}, [csvFileName '.csv']);
        end
    end


    for varIdx = 1:varParamVals_len
        varParam = varParamVals{varIdx};
        fileName = resultsPaths{1, varIdx};
        csvInput=csvread(fileName);
        csvInputDims = size(csvInput);
    
        csvStruct.(varParam) = zeros(nRuns, csvInputDims(1), csvInputDims(2));
        csvStruct.(varParam)(1,:,:) = csvInput;
    
        for i=2:nRuns
            fileName = resultsPaths{i, varIdx};
            csvInput=csvread(fileName);
            csvStruct.(varParam)(i,:,:) = csvInput;
        end
    end
    csvStruct.extra.timeOfRun = timeOfRun;
    csvStruct.extra.varParamVals = varParamVals;
    csvStruct.extra.varParamVals_len = varParamVals_len;
    csvStruct.extra.varParamValsNum = str2double(varParamVals) / 10;
end