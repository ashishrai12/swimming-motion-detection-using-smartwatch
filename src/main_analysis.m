%% Swimming Motion Detection & Analysis
% This script serves as the main entry point for analyzing Pebble Smartwatch 
% accelerometer data to distinguish between different aquatic states.

clear; clc; close all;

% Add src to path if needed (though we are running from it or root)
% addpath('src');

% Define data files and their configurations
% format: {filename, title, delimiter, commentStyle}
configs = {
    {'../data/Nothing.txt', 'State: Idle (Nothing)', '\n', '#'},
    {'../data/Swim.txt', 'State: Swimming', '\n', '#'},
    {'../data/Drown.txt', 'State: Distress (Drowning)', '\n', '#'}
};

% Loop through each configuration and plot
for i = 1:length(configs)
    cfg = configs{i};
    try
        plot_motion_data(cfg{1}, cfg{2}, cfg{3}, cfg{4});
    catch ME
        fprintf('Error plotting %s: %s\n', cfg{1}, ME.message);
    end
end

fprintf('Analysis Complete. All states processed.\n');
