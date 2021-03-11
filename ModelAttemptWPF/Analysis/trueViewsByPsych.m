% s : nSharesPopulation
function trueViewsByPsych(s)
    inputs = s.extra.varParamVals;
    varNums = s.extra.varParamValsNum
    %should be the same for both
    figDiff = figure();
    % figVar = figure();
    figMean = figure();
    figMin = figure();
    figMax = figure();
    meanDiffTrueViewsList = 1:s.extra.varParamVals_len;
    % varDiffTrueViewsList = 1:s.extra.varParamVals_len;
    meanMeanTrueViewsList = 1:s.extra.varParamVals_len;
    meanMinTrueViewsList = 1:s.extra.varParamVals_len;
    meanMaxTrueViewsList = 1:s.extra.varParamVals_len;
    % Iterate over parameter 
    for i = 1:s.extra.varParamVals_len
        % Get the number of runs
        % [runs, ~] = size(s.(inputs{i}));

        trueViews = s.(inputs{i}).trueViews_mat;
        % Find max and min mislead person of each run and take the difference
        diffTrueViews = max(trueViews, [], 2) - min(trueViews, [], 2);
        meanDiffTrueViews = mean(diffTrueViews);
        varDiffTrueViews = var(diffTrueViews);
        meanDiffTrueViewsList(i) = meanDiffTrueViews;
        varDiffTrueViewsList(i) = varDiffTrueViews;
        %%
        meanTrueViews = mean(trueViews, 2);
        meanMeanTrueViews = mean(meanTrueViews);
        meanMeanTrueViewsList(i) = meanMeanTrueViews;
        %%
        minTrueViews = min(trueViews, [], 2);
        meanMinTrueViews = mean(minTrueViews);
        meanMinTrueViewsList(i) = meanMinTrueViews;
        %%
        maxTrueViews = max(trueViews, [], 2);
        meanMaxTrueViews = mean(maxTrueViews);
        meanMaxTrueViewsList(i) = meanMaxTrueViews;
    end
    figure(figDiff);
    plot(varNums, meanDiffTrueViewsList)
    title('Mean of diff true views')
    % figure(figVar);
    % plot(varNums, varDiffTrueViewsList)
    % title('Variance in diff fake views')
    figure(figMean);
    plot(varNums, meanMeanTrueViewsList)
    title('Mean of mean true views')
    %%
    figure(figMin);
    plot(varNums, meanMinTrueViewsList)
    title('Mean of min true views')
    %%
    figure(figMax);
    plot(varNums, meanMaxTrueViewsList)
    title('Mean of max true views')
end