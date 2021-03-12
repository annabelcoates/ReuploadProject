% s : nSharesPopulation
function totalViewsByPsych(s)
    inputs = s.extra.varParamVals;
    varNums = s.extra.varParamValsNum
    %should be the same for both
    figDiff = figure();
    figMean = figure();
    figMin = figure();
    figMax = figure();
    meanDiffTotalViewsList = 1:s.extra.varParamVals_len;
    meanMeanTotalViewsList = 1:s.extra.varParamVals_len;
    meanMinTotalViewsList = 1:s.extra.varParamVals_len;
    meanMaxTotalViewsList = 1:s.extra.varParamVals_len;
    % Iterate over parameter 
    for i = 1:s.extra.varParamVals_len
        % Get the number of runs
        % [runs, ~] = size(s.(inputs{i}));

        totalViews = s.(inputs{i}).fakeViews_mat + s.(inputs{i}).trueViews_mat;
        % Find max and min mislead person of each run and take the difference
        diffTotalViews = max(totalViews, [], 2) - min(totalViews, [], 2);
        meanDiffTotalViews = mean(diffTotalViews);
        varDiffTotalViews = var(diffTotalViews);
        meanDiffTotalViewsList(i) = meanDiffTotalViews;
        varDiffTotalViewsList(i) = varDiffTotalViews;
        %%
        meanTotalViews = mean(totalViews, 2);
        meanMeanTotalViews = mean(meanTotalViews);
        meanMeanTotalViewsList(i) = meanMeanTotalViews;
        %%
        minTotalViews = min(totalViews, [], 2);
        meanMinTotalViews = mean(minTotalViews);
        meanMinTotalViewsList(i) = meanMinTotalViews;
        %%
        maxTotalViews = max(totalViews, [], 2);
        meanMaxTotalViews = mean(maxTotalViews);
        meanMaxTotalViewsList(i) = meanMaxTotalViews;
    end
    figure(figDiff);
    plot(varNums, meanDiffTotalViewsList)
    title('Mean of diff total views')
    % figure(figVar);
    % plot(varNums, varDiffTotalViewsList)
    % title('Variance in diff fake shares')
    figure(figMean);
    plot(varNums, meanMeanTotalViewsList)
    title('Mean of mean total views')
    %%
    figure(figMin);
    plot(varNums, meanMinTotalViewsList)
    title('Mean of min total views')
    %%
    figure(figMax);
    plot(varNums, meanMaxTotalViewsList)
    title('Mean of max total views')
end