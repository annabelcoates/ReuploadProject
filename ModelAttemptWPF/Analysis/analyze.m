clear;
resetAndLoad;

nSharesPopulationStruct = nSharesPopulationFunc(desiredSim);
nSharesAllStruct = importCSV('nSharesAll', desiredSim);
nViewsAllStruct = importCSV('nViewsAll', desiredSim);
newsInfoStruct = importCSV('newsInfo', desiredSim);
% viewersAllStruct = importCSV('viewersAll', desiredSim);
% sharersAllStruct = importCSV('sharersAll', desiredSim);

spreadByPsych(nSharesAllStruct, nViewsAllStruct, 100, 200);