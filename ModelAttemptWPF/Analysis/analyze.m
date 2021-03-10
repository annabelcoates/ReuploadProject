scriptPath = fileparts(mfilename('fullpath'));
sharedFakeNewsStruct = importCSV(scriptPath, 'nSharedFakeNews')
populationStruct = nSharesPopulation(scriptPath)