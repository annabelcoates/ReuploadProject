% s : nSharesPopulation
function fakeSharesByPsych(s)
    inputs = s.extra.varParamVals;
    varNums = s.extra.varParamValsNum
    %should be the same for both
    figDiff = figure();
    figMean = figure();
    figMin = figure();
    figMax = figure();
    meanDiffFakeSharesList = 1:s.extra.varParamVals_len;
    meanMeanFakeSharesList = 1:s.extra.varParamVals_len;
    meanMinFakeSharesList = 1:s.extra.varParamVals_len;
    meanMaxFakeSharesList = 1:s.extra.varParamVals_len;
    % Iterate over parameter 
    for i = 1:s.extra.varParamVals_len
        % Get the number of runs
        % [runs, ~] = size(s.(inputs{i}));

        fakeShares = s.(inputs{i}).fakeShares_mat;
        % Find max and min mislead person of each run and take the difference
        diffFakeShares = max(fakeShares, [], 2) - min(fakeShares, [], 2);
        meanDiffFakeShares = mean(diffFakeShares);
        varDiffFakeShares = var(diffFakeShares);
        meanDiffFakeSharesList(i) = meanDiffFakeShares;
        varDiffFakeSharesList(i) = varDiffFakeShares;
        %%
        meanFakeShares = mean(fakeShares, 2);
        meanMeanFakeShares = mean(meanFakeShares);
        meanMeanFakeSharesList(i) = meanMeanFakeShares;
        %%
        minFakeShares = min(fakeShares, [], 2);
        meanMinFakeShares = mean(minFakeShares);
        meanMinFakeSharesList(i) = meanMinFakeShares;
        %%
        maxFakeShares = max(fakeShares, [], 2);
        meanMaxFakeShares = mean(maxFakeShares);
        meanMaxFakeSharesList(i) = meanMaxFakeShares;
    end
    figure(figDiff);
    plot(varNums, meanDiffFakeSharesList)
    title('Mean of diff fake shares')
    % figure(figVar);
    % plot(varNums, varDiffFakeSharesList)
    % title('Variance in diff fake shares')
    figure(figMean);
    plot(varNums, meanMeanFakeSharesList)
    title('Mean of mean fake shares')
    %%
    figure(figMin);
    plot(varNums, meanMinFakeSharesList)
    title('Mean of min fake shares')
    %%
    figure(figMax);
    plot(varNums, meanMaxFakeSharesList)
    title('Mean of max fake shares')
end