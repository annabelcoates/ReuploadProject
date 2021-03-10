function []=myPlot(x, y, runParamsStruct, varParamVals, saveFolderPath)
    varParamVals_len = size(varParamVals);
    varParamVals_len = varParamVals_len(2);
    for varIdx = 1:varParamVals_len
        varParam = erase(varParamVals{varIdx}, '_');
        figure('visible', 'off');
        if isempty(y)
            histogram(...
                runParamsStruct.(varParam).([x '_flat']),...
                100,'Normalization','pdf');
            xlabel([x '\_flat']);
            ylabel('PDF');
            figName = [varParam ' Histogram plot of ' [x '\_flat']];
            saveName = [varParam ' Histogram plot of ' [x '_flat']];
            savePath = fullfile(saveFolderPath, [saveName '.png']);
            title(figName);
            saveas(gcf, [savePath '.png']);
        else
            hold on;
            xax = runParamsStruct.(varParam).([x '_flat']);
            yax = runParamsStruct.(varParam).([y '_flat']);
            scatter(...
                xax,...
                yax,...
                3);
            lsline;
            xlabel([x '\_flat']);
            ylabel([y '\_flat']);
            figName = [varParam ' Scatter plot of ' [x '\_flat'] ' against ' [y '\_flat']];
            saveName = [varParam ' Scatter plot of ' [x '_flat'] ' against ' [y '_flat']];
            savePath = fullfile(saveFolderPath, [saveName '.png']);
            title(figName);
            saveas(gcf, [savePath '.png']);
            hold off;
        end
    end
end