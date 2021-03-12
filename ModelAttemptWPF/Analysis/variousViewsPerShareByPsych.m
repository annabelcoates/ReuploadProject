% s : nViewsPopulation
function variousViewsPerShareByPsych(s)
    inputs = s.extra.varParamVals;
    varNums = s.extra.varParamValsNum;
    %should be the same for both
    figTotal = figure();
    meanTotalViewsList = 1:s.extra.varParamVals_len;
    meanTrueViewsList = 1:s.extra.varParamVals_len;
    meanFakeViewsList = 1:s.extra.varParamVals_len;
    meanTotalSharesList = 1:s.extra.varParamVals_len;
    meanTrueSharesList = 1:s.extra.varParamVals_len;
    meanFakeSharesList = 1:s.extra.varParamVals_len;
    % Iterate over parameter 
    for i = 1:s.extra.varParamVals_len
        % Get the number of runs
        % [runs, ~] = size(s.(inputs{i}));

        % Find max and min mislead person of each run and take the difference
        %%
        totalViews = s.(inputs{i}).trueViews_mat + s.(inputs{i}).fakeViews_mat;
        meanTotalViews = mean(totalViews, 2);
        meanTotalViews = mean(meanTotalViews);
        meanTotalViewsList(i) = meanTotalViews;
        %%
        trueViews = s.(inputs{i}).trueViews_mat;
        meanTrueViews = mean(trueViews, 2);
        meanTrueViews = mean(meanTrueViews);
        meanTrueViewsList(i) = meanTrueViews;
        %%
        fakeViews = s.(inputs{i}).fakeViews_mat;
        meanFakeViews = mean(fakeViews, 2);
        meanFakeViews = mean(meanFakeViews);
        meanFakeViewsList(i) = meanFakeViews;
    end
    for i = 1:s.extra.varParamVals_len
        % Get the number of runs
        % [runs, ~] = size(s.(inputs{i}));

        % Find max and min mislead person of each run and take the difference
        %%
        totalShares = s.(inputs{i}).trueShares_mat + s.(inputs{i}).fakeShares_mat;
        meanTotalShares = mean(totalShares, 2);
        meanTotalShares = mean(meanTotalShares);
        meanTotalSharesList(i) = meanTotalShares;
        %%
        trueShares = s.(inputs{i}).trueShares_mat;
        meanTrueShares = mean(trueShares, 2);
        meanTrueShares = mean(meanTrueShares);
        meanTrueSharesList(i) = meanTrueShares;
        %%
        fakeShares = s.(inputs{i}).fakeShares_mat;
        meanFakeShares = mean(fakeShares, 2);
        meanFakeShares = mean(meanFakeShares);
        meanFakeSharesList(i) = meanFakeShares;
    end
    figure(figTotal);
    hold on;
    xlabel("Influence of personality traits");
    ylabel("Ratio views : share per person");
    plot(varNums./100, meanTotalViewsList./meanTotalSharesList,'color','black','LineWidth', 1.5)
    plot(varNums./100, meanTrueViewsList./meanTrueSharesList, '--','color','black','LineWidth', 1.5)
    plot(varNums./100, meanFakeViewsList./meanFakeSharesList, '-.','color','black','LineWidth', 1.5)
    set(figTotal, 'Position', [100,100,250,250]);
    saveas(figTotal, 'VpSbP.png');
end