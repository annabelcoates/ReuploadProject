% s : nViewsPopulation
function shareRatioByPsych(s)
    inputs = s.extra.varParamVals;
    varNums = s.extra.varParamValsNum;
    %should be the same for both
    figTotal = figure();
    meanTotalViewsList = 1:s.extra.varParamVals_len;
    % Iterate over parameter 
    for i = 1:s.extra.varParamVals_len
        % Get the number of runs
        % [runs, ~] = size(s.(inputs{i}));

        % Find max and min mislead person of each run and take the difference
        %%
        totalViews = s.(inputs{i}).ratioShares_mat;
        meanTotalViews = mean(totalViews, 2,'omitnan');
        meanTotalViews = mean(meanTotalViews,'omitnan');
        meanTotalViewsList(i) = meanTotalViews;
        %%

    end
    figure(figTotal);
    hold on;
    xlabel("Influence of personality traits");
    ylabel("Ratio of true to fake shares per person");
    ylim([0.25 0.35]);
    plot(varNums./100, meanTotalViewsList)
    set(figTotal, 'Position', [100,100,250,250]);
    saveas(figTotal, 'RbV.png');
end