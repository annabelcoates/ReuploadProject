% s : nSharesPopulation
function fakeSharesByTrait(s, groupByVal)
    hold on;
    inputs = s.extra.varParamVals;
    %should be the same for both
    figOpn = figure();
    figCon = figure();
    figExt = figure();
    figAgr = figure();
    figNrt = figure();
    % Iterate over parameter 
    for i = 1:s.extra.varParamVals_len
        % Get the number of runs
        % [runs, ~] = size(s.(inputs{i}));

        opnPlot = [transpose(s.(inputs{i}).opn_flat), transpose(s.(inputs{i}).fakeShares_flat)];
        [~,idx] = sort(opnPlot(:,1));
        opnPlot = opnPlot(idx,:);

        conPlot = [transpose(s.(inputs{i}).con_flat), transpose(s.(inputs{i}).fakeShares_flat)];
        [~,idx] = sort(conPlot(:,1));
        conPlot = conPlot(idx,:);

        extPlot = [transpose(s.(inputs{i}).ext_flat), transpose(s.(inputs{i}).fakeShares_flat)];
        [~,idx] = sort(extPlot(:,1));
        extPlot = extPlot(idx,:);

        agrPlot = [transpose(s.(inputs{i}).agr_flat), transpose(s.(inputs{i}).fakeShares_flat)];
        [~,idx] = sort(agrPlot(:,1));
        agrPlot = agrPlot(idx,:);

        nrtPlot = [transpose(s.(inputs{i}).nrt_flat), transpose(s.(inputs{i}).fakeShares_flat)];
        [~,idx] = sort(nrtPlot(:,1));
        nrtPlot = nrtPlot(idx,:);

        %%
        if groupByVal
            figure(figOpn);
        else
            figure();
        end
        scatter(opnPlot(:,1), opnPlot(:,2));
        if groupByVal
            title("Openness")
        else
            title(["Openness" inputs{i}])
        end
        hold on;
        %%
        if groupByVal
            figure(figCon);
        else
            figure();
        end
        scatter(conPlot(:,1), conPlot(:,2));
        if groupByVal
            title("Conscientiousness")
        else
            title(["Conscientiousness" inputs{i}])
        end
        hold on;
        %%
        if groupByVal
            figure(figExt);
        else
            figure();
        end 
        scatter(extPlot(:,1), extPlot(:,2));
        if groupByVal
            title("Extroversion")
        else
            title(["Extroversion" inputs{i}])
        end
        hold on;
        %%
        if groupByVal
            figure(figAgr);
        else
            figure();
        end
        scatter(agrPlot(:,1), agrPlot(:,2));
        if groupByVal
            title("Agreeableness")
        else
            title(["Agreeableness" inputs{i}])
        end
        hold on;
        %%
        if groupByVal
            figure(figNrt);
        else
            figure();
        end
        scatter(nrtPlot(:,1), nrtPlot(:,2));
        if groupByVal
            title("Neuroticism")
        else
            title(["Neuroticism" inputs{i}])
        end
        hold on;
        %%
    end
    hold off;
end