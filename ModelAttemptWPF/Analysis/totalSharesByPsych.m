% s : nSharesPopulation
function totalSharesByPsych(s)
    inputs = s.extra.varParamVals;
    varNums = s.extra.varParamValsNum
    %should be the same for both
    figDiff = figure();
    figMean = figure();
    figMin = figure();
    figMax = figure();
    meanDiffTotalSharesList = 1:s.extra.varParamVals_len;
    meanMeanTotalSharesList = 1:s.extra.varParamVals_len;
    meanMinTotalSharesList = 1:s.extra.varParamVals_len;
    meanMaxTotalSharesList = 1:s.extra.varParamVals_len;
    % Iterate over parameter 
    for i = 1:s.extra.varParamVals_len
        % Get the number of runs
        % [runs, ~] = size(s.(inputs{i}));

        totalShares = s.(inputs{i}).trueShares_mat + s.(inputs{i}).fakeShares_mat;
        % Find max and min mislead person of each run and take the difference
        diffTotalShares = max(totalShares, [], 2) - min(totalShares, [], 2);
        meanDiffTotalShares = mean(diffTotalShares);
        varDiffTotalShares = var(diffTotalShares);
        meanDiffTotalSharesList(i) = meanDiffTotalShares;
        varDiffTotalSharesList(i) = varDiffTotalShares;
        %%
        meanTotalShares = mean(totalShares, 2);
        meanMeanTotalShares = mean(meanTotalShares);
        meanMeanTotalSharesList(i) = meanMeanTotalShares;
        %%
        minTotalShares = min(totalShares, [], 2);
        meanMinTotalShares = mean(minTotalShares);
        meanMinTotalSharesList(i) = meanMinTotalShares;
        %%
        maxTotalShares = max(totalShares, [], 2);
        meanMaxTotalShares = mean(maxTotalShares);
        meanMaxTotalSharesList(i) = meanMaxTotalShares;
    end
    figure(figDiff);
    plot(varNums, meanDiffTotalSharesList)
    title('Mean of diff total shares')
    % figure(figVar);
    % plot(varNums, varDiffTotalSharesList)
    % title('Variance in diff fake shares')
    figure(figMean);
    plot(varNums, meanMeanTotalSharesList)
    title('Mean of mean total shares')
    %%
    figure(figMin);
    plot(varNums, meanMinTotalSharesList)
    title('Mean of min total shares')
    %%
    figure(figMax);
    plot(varNums, meanMaxTotalSharesList)
    title('Mean of max total shares')
end