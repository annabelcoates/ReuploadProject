% s : nSharesPopulation
function fakeSharesByPsych(s)
    inputs = s.extra.varParamVals;
    varNums = s.extra.varParamValsNum
    %should be the same for both
    figMean = figure();
    figVar = figure();
    meanDiffFakeSharesList = 1:s.extra.varParamVals_len;
    varDiffFakeSharesList = 1:s.extra.varParamVals_len;
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
    end
    figure(figMean);
    plot(varNums, meanDiffFakeSharesList)
    title('Mean of diff fake shares')
    % figure(figVar);
    % plot(varNums, varDiffFakeSharesList)
    % title('Variance in diff fake shares')
end