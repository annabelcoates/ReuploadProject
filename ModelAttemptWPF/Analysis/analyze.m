clear;

scriptPath = fileparts(mfilename('fullpath'));
cd (scriptPath);
timesList = loadTimes(scriptPath);
lastTime = size(timesList);
lastTime = lastTime(1);
desiredRun = timesList{lastTime};
topResultsPath = fullfile(scriptPath, '..', 'Results', desiredRun);
saveFolderPath = fullfile(topResultsPath, 'AnalysisResults');

%%

sharedFakeNewsStruct = importCSV('nSharedFakeNews');
populationStruct = nSharesPopulationFunc();
sharesAllstruct = importCSV('nSharesAll')
% 
% figure();
% hold on;
% 
% myPlot('OL_flat', 'fakeShares_flat', populationStruct, populationStruct, populationStruct.varParamVals, saveFolderPath);
% myPlot('OL_flat', 'trueShares_flat', populationStruct, populationStruct, populationStruct.varParamVals, saveFolderPath);
% myPlot('OL_flat', 'fakeViews_flat', populationStruct, populationStruct, populationStruct.varParamVals, saveFolderPath);
% myPlot('OL_flat', 'trueViews_flat', populationStruct, populationStruct, populationStruct.varParamVals, saveFolderPath);
% 
% hold off;