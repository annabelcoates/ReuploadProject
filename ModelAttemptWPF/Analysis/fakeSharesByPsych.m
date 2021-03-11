% s : nSharesPopulation
function fakeSharesByPsych(s)
    inputs = s.extra.varParamVals;
    varNums = s.extra.varParamValsNum
    %should be the same for both
    figMean = figure();
    figVar = figure();
    meanDifffakeSharesList = 1:s.extra.varParamVals_len;
    varDifffakeSharesList = 1:s.extra.varParamVals_len;
    % Iterate over parameter 
    for i = 1:s.extra.varParamVals_len
        % Get the number of runs
        % [runs, ~] = size(s.(inputs{i}));

        fakeShares = s.(inputs{i}).fakeShares_mat;
        % Find max and min mislead person of each run and take the difference
        difffakeShares = max(fakeShares, [], 2) - min(fakeShares, [], 2);
        meanDifffakeShares = mean(difffakeShares);
        varDifffakeShares = var(difffakeShares);
        meanDifffakeSharesList(i) = meanDifffakeShares;
        varDifffakeSharesList(i) = varDifffakeShares;
        %%
    end
    figure(figMean);
    plot(varNums, meanDifffakeSharesList)
    title('Mean of diff fake views')
    figure(figVar);
    plot(varNums, varDifffakeSharesList)
    title('Variance in diff fake views')
end