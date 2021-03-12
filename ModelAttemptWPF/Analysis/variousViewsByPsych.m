% s : nViewsPopulation
function variousViewsByPsych(s)
    inputs = s.extra.varParamVals;
    varNums = s.extra.varParamValsNum;
    %should be the same for both
    figTotal = figure();
    meanTotalViewsList = 1:s.extra.varParamVals_len;
    meanTrueViewsList = 1:s.extra.varParamVals_len;
    meanFakeViewsList = 1:s.extra.varParamVals_len;
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
    figure(figTotal);
    hold on;
    xlabel("Influence of personality traits");
    ylabel("Number of views per person");
    plot(varNums./100, meanTotalViewsList,'color','black')
    plot(varNums./100, meanTrueViewsList, '--','color','black')
    plot(varNums./100, meanFakeViewsList, '-.','color','black')
    set(figTotal, 'Position', [100,100,380,250]);
    saveas(figTotal, 'SbV.png');
end