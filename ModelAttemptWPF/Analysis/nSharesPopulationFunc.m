function returnStruct=nSharedPopulation(scriptPath)
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
        varParamVals{idx} = ['OL' varParamVals{idx} '_'];
    end

    resultsPaths = cell(nRuns, varParamVals_len);
    for i = 1:nRuns
        for j = 1:varParamVals_len
            tempVarParamVals = strcat(varParamVals, int2str(i));
            tempPath = fullfile(...
            topResultsPath, tempVarParamVals);
            resultsPaths{i, j} = fullfile(tempPath{j}, 'nSharesPopulation.csv');
        end
    end


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
            emoState(i,:)=nSharesPop(:,14);
        end
        varParam = erase(varParamVals{varIdx}, '_');

    %%
    % Plot Parameters Names
        returnStruct.(varParam).nFollowers_flat=reshape(nFollowers,[1,nRuns*population]);
        returnStruct.(varParam).opn_flat=reshape(opn,[1,nRuns*population]);
        returnStruct.(varParam).con_flat=reshape(con,[1,nRuns*population]);
        returnStruct.(varParam).ext_flat=reshape(ext,[1,nRuns*population]);
        returnStruct.(varParam).agr_flat=reshape(agr,[1,nRuns*population]);
        returnStruct.(varParam).nrt_flat=reshape(nrt,[1,nRuns*population]);
        returnStruct.(varParam).OL_flat=reshape(OL,[1,nRuns.*population]);
        returnStruct.(varParam).pol_flat=reshape(pol,[1,nRuns*population]);
        returnStruct.(varParam).fakeShares_flat=reshape(fakeShares,[1,nRuns*population]);
        returnStruct.(varParam).trueShares_flat=reshape(trueShares,[1,nRuns*population]);
        tempRatio_flat = returnStruct.(varParam).trueShares_flat + returnStruct.(varParam).fakeShares_flat;
        returnStruct.(varParam).ratioShares_flat = returnStruct.(varParam).fakeShares_flat ./ tempRatio_flat;
        returnStruct.(varParam).frqUse_flat=reshape(frqUse,[1,nRuns*population]);
        returnStruct.(varParam).sesLen_flat=reshape(sesLen,[1,nRuns*population]);
        % // TODO 
        % ? Should this be a ceiling function
        returnStruct.(varParam).roundSL_flat=ceil(returnStruct.(varParam).sesLen_flat);
        returnStruct.(varParam).shareFreq_flat=reshape(shareFreq,[1,nRuns*population]);
        returnStruct.(varParam).emoState_flat=reshape(emoState,[1,nRuns*population]);

        returnStruct.(varParam).nFollowers_mat=nFollowers;
        returnStruct.(varParam).opn_mat=opn;
        returnStruct.(varParam).con_mat=con;
        returnStruct.(varParam).ext_mat=ext;
        returnStruct.(varParam).agr_mat=agr;
        returnStruct.(varParam).nrt_mat=nrt;
        returnStruct.(varParam).OL_mat=OL;
        returnStruct.(varParam).pol_mat=pol;
        returnStruct.(varParam).fakeShares_mat=fakeShares;
        returnStruct.(varParam).trueShares_mat=trueShares;
        tempRatio_mat = returnStruct.(varParam).trueShares_mat + returnStruct.(varParam).fakeShares_mat;
        returnStruct.(varParam).ratioShares_mat = returnStruct.(varParam).fakeShares_mat ./ tempRatio_mat;
        returnStruct.(varParam).frqUse_mat=frqUse;
        returnStruct.(varParam).sesLen_mat=sesLen;
        % // TODO 
        % ? Should this be a ceiling function
        returnStruct.(varParam).roundSL_mat=ceil(returnStruct.(varParam).sesLen_mat);
        returnStruct.(varParam).shareFreq_mat=shareFreq;
        returnStruct.(varParam).emoState_mat=emoState;
        returnStruct.timeOfRun = timeOfRun;
        returnStruct.varParamVals = varParamVals;
    end
end