% s : nSharesPopulation
function diffSVByPsych(s)
    inputs = s.extra.varParamVals;
    varNums = s.extra.varParamValsNum;
    %should be the same for both
    figTotal = figure();
    meanTrueSharesList = 1:s.extra.varParamVals_len;
    meanFakeSharesList = 1:s.extra.varParamVals_len;
    meanTrueViewsList = 1:s.extra.varParamVals_len;
    meanFakeViewsList = 1:s.extra.varParamVals_len;
    % Iterate over parameter 
    for i = 1:s.extra.varParamVals_len
        % Get the number of runs
        % [runs, ~] = size(s.(inputs{i}));
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
    for i = 1:s.extra.varParamVals_len
        % Get the number of runs
        % [runs, ~] = size(s.(inputs{i}));

        % Find max and min mislead person of each run and take the difference
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
    figure(figTotal);
    hold on;
    xlabel("Influence of personality traits");
    ylabel("Proportion of shares/views being true");
    plot(varNums./100, meanTrueSharesList ./ (meanTrueSharesList+meanFakeSharesList),'-+','color','black','LineWidth', 1.5);
    plot(varNums./100, meanTrueViewsList ./ (meanTrueViewsList+meanFakeViewsList), '-x','color','black','LineWidth', 1.5);
    set(figTotal, 'Position', [100,100,250,250]);
    saveas(figTotal, 'FvTbP.png');
end