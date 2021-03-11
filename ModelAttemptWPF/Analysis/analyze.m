clear;
resetAndLoad;

nSharesPopulationStruct = nSharesPopulationFunc(desiredSim);
nSharesAllStruct = importCSV('nSharesAll', desiredSim);
nViewsAllStruct = importCSV('nViewsAll', desiredSim);
newsInfoStruct = importCSV('newsInfo', desiredSim);
beliefPerNewsStruct = importCSV('beliefPerNews', desiredSim);
% viewersAllStruct = importCSV('viewersAll', desiredSim);
% sharersAllStruct = importCSV('sharersAll', desiredSim);

% beliefEmoteSpreadOld(nSharesAllStruct, nViewsAllStruct, newsInfoStruct, 100, 200, 5,0);
% fakeViewsByPsych(nSharesPopulationStruct);
spreadByPsych(nSharesAllStruct, nViewsAllStruct, 100, 200, 300);