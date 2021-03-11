% s : nSharesPopulation
function fakeViewsByPsych(s)
    inputs = s.extra.varParamVals;
    varNums = s.extra.varParamValsNum
    %should be the same for both
    figMean = figure();
    figVar = figure();
    meanDiffFakeViewsList = 1:s.extra.varParamVals_len;
    varDiffFakeViewsList = 1:s.extra.varParamVals_len;
    % Iterate over parameter 
    for i = 1:s.extra.varParamVals_len
        % Get the number of runs
        % [runs, ~] = size(s.(inputs{i}));

        fakeViews = s.(inputs{i}).fakeViews_mat;
        % Find max and min mislead person of each run and take the difference
        diffFakeViews = max(fakeViews, [], 2) - min(fakeViews, [], 2);
        meanDiffFakeViews = mean(diffFakeViews);
        varDiffFakeViews = var(diffFakeViews);
        meanDiffFakeViewsList(i) = meanDiffFakeViews;
        varDiffFakeViewsList(i) = varDiffFakeViews;
        %%
    end
    figure(figMean);
    plot(varNums, meanDiffFakeViewsList)
    title('Mean of diff fake views')
    figure(figVar);
    plot(varNums, varDiffFakeViewsList)
    title('Variance in diff fake views')
end