% s : nSharesPopulation
function trueSharesByPsych(s)
    inputs = s.extra.varParamVals;
    varNums = s.extra.varParamValsNum
    %should be the same for both
    figMean = figure();
    figVar = figure();
    meanDiffTrueSharesList = 1:s.extra.varParamVals_len;
    varDiffTrueSharesList = 1:s.extra.varParamVals_len;
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
    end
    figure(figMean);
    plot(varNums, meanDiffTrueSharesList)
    title('Mean of diff true shares')
    % figure(figVar);
    % plot(varNums, varDiffTrueSharesList)
    % title('Variance in diff fake shares')
end