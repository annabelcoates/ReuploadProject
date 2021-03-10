function nSharedPopulationStruct=nSharedPopulation(scriptPath)
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
        varParamVals{idx} = ['OL' varParamVals{idx}];
    end

    resultsPaths = cell(nRuns, varParamVals_len);
    for i = 1:nRuns
        for j = 1:varParamVals_len
            tempVarParamVals = strcat(varParamVals, '_');
            tempVarParamVals = strcat(tempVarParamVals, int2str(i));
            tempPath = fullfile(...
            topResultsPath, tempVarParamVals);
            resultsPaths{i, j} = fullfile(tempPath{j}, 'nSharesPopulation.csv');
        end
    end


    for varIdx = 1:varParamVals_len
        varParam = varParamVals{varIdx};
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
            fakeViews(i,:)=nSharesPop(:,15);
            trueViews(i,:)=nSharesPop(:,16);
            totalViews(i,:)=nSharesPop(:,17);
        end

    %%
    % Plot Parameters Names
        nSharedPopulationStruct.(varParam).nFollowers_flat=reshape(nFollowers,[1,nRuns*population]);
        nSharedPopulationStruct.(varParam).opn_flat=reshape(opn,[1,nRuns*population]);
        nSharedPopulationStruct.(varParam).con_flat=reshape(con,[1,nRuns*population]);
        nSharedPopulationStruct.(varParam).ext_flat=reshape(ext,[1,nRuns*population]);
        nSharedPopulationStruct.(varParam).agr_flat=reshape(agr,[1,nRuns*population]);
        nSharedPopulationStruct.(varParam).nrt_flat=reshape(nrt,[1,nRuns*population]);
        nSharedPopulationStruct.(varParam).OL_flat=reshape(OL,[1,nRuns.*population]);
        nSharedPopulationStruct.(varParam).pol_flat=reshape(pol,[1,nRuns*population]);
        nSharedPopulationStruct.(varParam).fakeShares_flat=reshape(fakeShares,[1,nRuns*population]);
        nSharedPopulationStruct.(varParam).trueShares_flat=reshape(trueShares,[1,nRuns*population]);
        tempRatio_flat = nSharedPopulationStruct.(varParam).trueShares_flat + nSharedPopulationStruct.(varParam).fakeShares_flat;
        nSharedPopulationStruct.(varParam).ratioShares_flat = nSharedPopulationStruct.(varParam).fakeShares_flat ./ tempRatio_flat;
        nSharedPopulationStruct.(varParam).frqUse_flat=reshape(frqUse,[1,nRuns*population]);
        nSharedPopulationStruct.(varParam).sesLen_flat=reshape(sesLen,[1,nRuns*population]);
        % // TODO 
        % ? Should this be a ceiling function
        nSharedPopulationStruct.(varParam).roundSL_flat=ceil(nSharedPopulationStruct.(varParam).sesLen_flat);
        nSharedPopulationStruct.(varParam).shareFreq_flat=reshape(shareFreq,[1,nRuns*population]);
        nSharedPopulationStruct.(varParam).emoState_flat=reshape(emoState,[1,nRuns*population]);
        nSharedPopulationStruct.(varParam).fakeViews_flat=reshape(fakeViews,[1,nRuns*population]);
        nSharedPopulationStruct.(varParam).trueViews_flat=reshape(trueViews,[1,nRuns*population]);
        nSharedPopulationStruct.(varParam).totalViews_flat=reshape(totalViews,[1,nRuns*population]);

%%

        nSharedPopulationStruct.(varParam).nFollowers_mat=nFollowers;
        nSharedPopulationStruct.(varParam).opn_mat=opn;
        nSharedPopulationStruct.(varParam).con_mat=con;
        nSharedPopulationStruct.(varParam).ext_mat=ext;
        nSharedPopulationStruct.(varParam).agr_mat=agr;
        nSharedPopulationStruct.(varParam).nrt_mat=nrt;
        nSharedPopulationStruct.(varParam).OL_mat=OL;
        nSharedPopulationStruct.(varParam).pol_mat=pol;
        nSharedPopulationStruct.(varParam).fakeShares_mat=fakeShares;
        nSharedPopulationStruct.(varParam).trueShares_mat=trueShares;
        tempRatio_mat = nSharedPopulationStruct.(varParam).trueShares_mat + nSharedPopulationStruct.(varParam).fakeShares_mat;
        nSharedPopulationStruct.(varParam).ratioShares_mat = nSharedPopulationStruct.(varParam).fakeShares_mat ./ tempRatio_mat;
        nSharedPopulationStruct.(varParam).frqUse_mat=frqUse;
        nSharedPopulationStruct.(varParam).sesLen_mat=sesLen;
        % // TODO 
        % ? Should this be a ceiling function
        nSharedPopulationStruct.(varParam).roundSL_mat=ceil(nSharedPopulationStruct.(varParam).sesLen_mat);
        nSharedPopulationStruct.(varParam).shareFreq_mat=shareFreq;
        nSharedPopulationStruct.(varParam).emoState_mat=emoState;
        nSharedPopulationStruct.(varParam).fakeViews_mat=fakeViews;
        nSharedPopulationStruct.(varParam).trueViews_mat=trueViews;
        nSharedPopulationStruct.(varParam).totalViews_mat=totalViews;
    end
    nSharedPopulationStruct.extra.timeOfRun = timeOfRun;
    nSharedPopulationStruct.extra.varParamVals = varParamVals;
    nSharedPopulationStruct.extra.varParamVals_len = varParamVals_len;
end