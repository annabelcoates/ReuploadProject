clear;

scriptPath = fileparts(mfilename('fullpath'));
cd (scriptPath);
timesList = loadTimes(scriptPath);
lastTime = size(timesList);
lastTime = lastTime(1);
desiredSim = timesList{lastTime};
topResultsPath = fullfile(scriptPath, '..', 'Results', desiredSim);
saveFolderPath = fullfile(topResultsPath, 'AnalysisResults');

%%

nSharesPopulationStruct = nSharesPopulationFunc(desiredSim);
nSharesAllStruct = importCSV('nSharesAll', desiredSim);
nViewsAllStruct = importCSV('nViewsAll', desiredSim);
newsInfoStruct = importCSV('newsInfo', desiredSim);
% viewersAllStruct = importCSV('viewersAll', desiredSim);
% sharersAllStruct = importCSV('sharersAll', desiredSim);

beliefEmoteSpreadOld(nSharesAllStruct, nViewsAllStruct, newsInfoStruct, 100, 200, 0);