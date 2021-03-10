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

sharedFakeNewsStruct = importCSV(scriptPath, 'nSharedFakeNews');
populationStruct = nSharesPopulationFunc(scriptPath);
myPlot('OL_flat', 'fakeShares_flat', populationStruct, populationStruct, populationStruct.varParamVals, saveFolderPath);