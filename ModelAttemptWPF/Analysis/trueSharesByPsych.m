% s : nSharesPopulation
function trueSharesByPsych(s)
    inputs = s.extra.varParamVals;
    varNums = s.extra.varParamValsNum
    %should be the same for both
    figDiff = figure();
    figMean = figure();
    figMin = figure();
    figMax = figure();
    meanDiffTrueSharesList = 1:s.extra.varParamVals_len;
    meanMeanTrueSharesList = 1:s.extra.varParamVals_len;
    meanMinTrueSharesList = 1:s.extra.varParamVals_len;
    meanMaxTrueSharesList = 1:s.extra.varParamVals_len;
    % Iterate over parameter 
    for i = 1:s.extra.varParamVals_len
        % Get the number of runs
        % [runs, ~] = size(s.(inputs{i}));

        trueShares = s.(inputs{i}).trueShares_mat;
        % Find max and min mislead person of each run and take the difference
        diffTrueShares = max(trueShares, [], 2) - min(trueShares, [], 2);
        meanDiffTrueShares = mean(diffTrueShares);
        varDiffTrueShares = var(diffTrueShares);
        meanDiffTrueSharesList(i) = meanDiffTrueShares;
        varDiffTrueSharesList(i) = varDiffTrueShares;
        %%
        meanTrueShares = mean(trueShares, 2);
        meanMeanTrueShares = mean(meanTrueShares);
        meanMeanTrueSharesList(i) = meanMeanTrueShares;
        %%
        minTrueShares = min(trueShares, [], 2);
        meanMinTrueShares = mean(minTrueShares);
        meanMinTrueSharesList(i) = meanMinTrueShares;
        %%
        maxTrueShares = max(trueShares, [], 2);
        meanMaxTrueShares = mean(maxTrueShares);
        meanMaxTrueSharesList(i) = meanMaxTrueShares;
    end
    figure(figDiff);
    plot(varNums, meanDiffTrueSharesList)
    title('Mean of diff true shares')
    % figure(figVar);
    % plot(varNums, varDiffTrueSharesList)
    % title('Variance in diff fake shares')
    figure(figMean);
    plot(varNums, meanMeanTrueSharesList)
    title('Mean of mean true shares')
    %%
    figure(figMin);
    plot(varNums, meanMinTrueSharesList)
    title('Mean of min true shares')
    %%
    figure(figMax);
    plot(varNums, meanMaxTrueSharesList)
    title('Mean of max true shares')
end