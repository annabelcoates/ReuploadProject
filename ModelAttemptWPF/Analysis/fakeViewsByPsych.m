% s : nSharesPopulation
function fakeViewsByPsych(s)
    inputs = s.extra.varParamVals;
    varNums = s.extra.varParamValsNum
    %should be the same for both
    figDiff = figure();
    % figVar = figure();
    figMean = figure();
    figMin = figure();
    figMax = figure();
    meanDiffFakeViewsList = 1:s.extra.varParamVals_len;
    % varDiffFakeViewsList = 1:s.extra.varParamVals_len;
    meanMeanFakeViewsList = 1:s.extra.varParamVals_len;
    meanMinFakeViewsList = 1:s.extra.varParamVals_len;
    meanMaxFakeViewsList = 1:s.extra.varParamVals_len;
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
        meanFakeViews = mean(fakeViews, 2);
        meanMeanFakeViews = mean(meanFakeViews);
        meanMeanFakeViewsList(i) = meanMeanFakeViews;
        %%
        minFakeViews = min(fakeViews, [], 2);
        meanMinFakeViews = mean(minFakeViews);
        meanMinFakeViewsList(i) = meanMinFakeViews;
        %%
        maxFakeViews = max(fakeViews, [], 2);
        meanMaxFakeViews = mean(maxFakeViews);
        meanMaxFakeViewsList(i) = meanMaxFakeViews;
    end
    figure(figDiff);
    plot(varNums, meanDiffFakeViewsList)
    title('Mean of diff fake views')
    % figure(figVar);
    % plot(varNums, varDiffFakeViewsList)
    % title('Variance in diff fake views')
    figure(figMean);
    plot(varNums, meanMeanFakeViewsList)
    title('Mean of mean fake views')
    %%
    figure(figMin);
    plot(varNums, meanMinFakeViewsList)
    title('Mean of min fake views')
    %%
    figure(figMax);
    plot(varNums, meanMaxFakeViewsList)
    title('Mean of max fake views')
end