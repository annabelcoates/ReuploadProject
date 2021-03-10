function []=myPlot(x, y, xStruct, yStruct, varParamVals, saveFolderPath)
    varParamVals_len = size(varParamVals);
    varParamVals_len = varParamVals_len(2);
    for varIdx = 1:varParamVals_len
        varParam = erase(varParamVals{varIdx}, '_');
        figure();
        if isempty(y)
            histogram(...
                xStruct.(varParam).([x]),...
                100,'Normalization','pdf');
            xlabel([x]);
            ylabel('PDF');
            figName = [varParam ' Histogram plot of ' [x]];
            saveName = [varParam ' Histogram plot of ' [x]];
            savePath = fullfile(saveFolderPath, [saveName '.png']);
            title(figName);
            saveas(gcf, [savePath '.png']);
        else
            hold on;
            xax = xStruct.(varParam).([x]);
            yax = yStruct.(varParam).([y]);
            scatter(...
                xax,...
                yax,...
                3);
            lsline;
            xlabel([x]);
            ylabel([y]);
            figName = [varParam ' Scatter plot of ' [x] ' against ' [y]];
            saveName = [varParam ' Scatter plot of ' [x] ' against ' [y]];
            savePath = fullfile(saveFolderPath, [saveName '.png']);
            title(figName);
            saveas(gcf, [savePath '.png']);
            hold off;
        end
    end
end