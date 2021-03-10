function [timesList]=loadTimes(scriptPath)
    timesPath = fullfile(scriptPath, '..', 'timesOfRuns.txt');

    timesFile = fopen(timesPath, 'r');
    timesList = textscan(timesFile, '%s', 'CommentStyle', '#');
    fclose(timesFile);
    timesList = timesList{1};
end