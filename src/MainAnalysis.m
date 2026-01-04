%% Swimming Motion Detection & Professional Analysis
% This script serves as the main entry point for analyzing Pebble Smartwatch 
% accelerometer data using the MotionData class.

clear; clc; close all;

% Get absolute path to the project root for robust file discovery
currentFile = mfilename('fullpath');
[srcPath, ~, ~] = fileparts(currentFile);
projectRoot = fileparts(srcPath);
dataDir = fullfile(projectRoot, 'data');

% Define analysis cases
% format: {filename, stateName}
cases = {
    {'Nothing.txt', 'Idle State (Stationary)'},
    {'Swim.txt', 'Active Swimming (Periodic)'},
    {'Drown.txt', 'Distress Signal (Chaotic)'},
    {'SensorLogSwim.txt', 'Raw Sensor Log (Piped Format)'},
    {'EditData.txt', 'Processed Baseline (EditData)'}
};

% Processing Loop
fprintf('Starting Professional Motion Analysis...\n');
fprintf('------------------------------------------\n');

results = {};
for i = 1:length(cases)
    caseInfo = cases{i};
    filePath = fullfile(dataDir, caseInfo{1});
    
    fprintf('Processing: %s\n', caseInfo{2});
    
    try
        % Instantiate the professional data object
        motionObj = MotionData(filePath, caseInfo{2});
        
        % Generate professional plots
        motionObj.plot();
        
        % Store for further analysis if needed
        results{end+1} = motionObj; %#ok<AGROW>
    catch ME
        fprintf('  [ERROR] Failed to process %s: %s\n', caseInfo{1}, ME.message);
    end
end

fprintf('------------------------------------------\n');
fprintf('Analysis Complete. %d states visualized.\n', length(results));
