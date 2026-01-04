function plot_motion_data(filename, plotTitle, delimiter, commentStyle)
    % plot_motion_data: Utility function to load and plot Pebble Smartwatch accelerometer data.
    %
    % Usage:
    %   plot_motion_data('../data/Nothing.txt', 'Idle State', '\n', '#')
    %   plot_motion_data('../data/edit1.txt', 'Swimming', '\n', ']|')

    if nargin < 3
        delimiter = '\n';
    end
    if nargin < 4
        commentStyle = '#';
    end

    % Open the file
    fileID = fopen(filename);
    if fileID == -1
        error('Cannot open file: %s', filename);
    end

    % Read the data
    % Data format is typically X Y Z
    C = textscan(fileID, '%f %f %f', 'Delimiter', delimiter, 'CommentStyle', commentStyle);
    fclose(fileID);

    % Information about the data
    fprintf('Loaded %d samples from %s\n', length(C{1}), filename);

    % Create visual representation
    figure('Name', plotTitle);
    
    subplot(3, 1, 1);
    plot(C{1});
    title([plotTitle, ' - X-axis']);
    ylabel('Acceleration');
    grid on;

    subplot(3, 1, 2);
    plot(C{2});
    title([plotTitle, ' - Y-axis']);
    ylabel('Acceleration');
    grid on;

    subplot(3, 1, 3);
    plot(C{3});
    title([plotTitle, ' - Z-axis']);
    ylabel('Acceleration');
    grid on;
end
