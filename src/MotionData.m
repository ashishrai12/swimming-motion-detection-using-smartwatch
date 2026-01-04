classdef MotionData < handle
    % MotionData: A professional class for handling smartwatch accelerometer data.
    % Handles various file formats (space, comma, pipe separated) and provides
    % robust visualization methods.

    properties
        Filename (1,:) char      % Source filename
        StateName (1,:) char     % Descriptive state name (e.g., 'Swimming')
        X (:,1) double           % X-axis data
        Y (:,1) double           % Y-axis data
        Z (:,1) double           % Z-axis data
        Timestamp (:,1) double   % Timestamps (if available)
        SampleCount (1,1) double % Total samples loaded
    end

    methods
        function obj = MotionData(filename, stateName)
            % Constructor: Loads and processes the sensor data
            obj.Filename = filename;
            obj.StateName = stateName;
            obj.loadData();
        end

        function loadData(obj)
            % Detect format and load data using robust heuristics
            fileID = fopen(obj.Filename, 'r');
            if fileID == -1
                error('MotionData:FileNotFound', 'Could not open file: %s', obj.Filename);
            end
            
            % Read first few non-comment lines to detect format
            line = '';
            while isempty(line) || startsWith(strtrim(line), '#')
                line = fgetl(fileID);
                if ~ischar(line), break; end
            end
            fclose(fileID);

            if ~ischar(line)
                error('MotionData:EmptyFile', 'File %s seems to be empty or only contains comments.', obj.Filename);
            end

            % Format Detection Logic
            if contains(line, '|') % Pipe separated (SensorLog format)
                obj.loadPipeFormat();
            elseif contains(line, ',') % Comma separated
                obj.loadDelimitedFormat(',', ']|');
            else % Space/Tab separated
                obj.loadDelimitedFormat(' ', '#');
            end
            
            obj.SampleCount = length(obj.X);
        end

        function loadDelimitedFormat(obj, delim, commentStyle)
            % Generic delimited loader for X Y Z (Time) formats
            fileID = fopen(obj.Filename, 'r');
            % Try to read 4 columns first (X, Y, Z, Time)
            C = textscan(fileID, '%f %f %f %f', 'Delimiter', delim, 'CommentStyle', commentStyle, 'MultipleDelimsAsOne', true);
            fclose(fileID);
            
            if isempty(C{1}) || length(C{1}) < 2
                 error('MotionData:LoadError', 'Failed to parse data from %s', obj.Filename);
            end
            
            obj.X = C{1};
            obj.Y = C{2};
            obj.Z = C{3};
            if ~isempty(C{4})
                obj.Timestamp = C{4};
            end
        end

        function loadPipeFormat(obj)
            % Specific loader for SensorLog pipe-separated format
            % Example: 8|3-axis Accelerometer|[-1.197,2.145,11.702]|1485609775802
            opts = delimitedTextImportOptions("NumVariables", 4);
            opts.Delimiter = "|";
            opts.VariableTypes = ["double", "string", "string", "double"];
            opts.VariableNamingRule = "preserve";
            
            tbl = readtable(obj.Filename, opts);
            
            % Extract vector data from strings like "[-1.19, 2.14, 11.70]"
            vectorStr = tbl.Var3;
            n = height(tbl);
            obj.X = zeros(n, 1);
            obj.Y = zeros(n, 1);
            obj.Z = zeros(n, 1);
            
            for i = 1:n
                str = char(vectorStr(i));
                % Clean brackets and split by comma
                nums = str2num(str); %#ok<ST2NM>
                if length(nums) >= 3
                    obj.X(i) = nums(1);
                    obj.Y(i) = nums(2);
                    obj.Z(i) = nums(3);
                end
            end
            obj.Timestamp = tbl.Var4;
        end

        function plot(obj)
            % Professional multi-axis plot
            if isempty(obj.X)
                warning('MotionData:NoData', 'No data to plot for %s', obj.StateName);
                return;
            end

            figName = sprintf('Analysis: %s', obj.StateName);
            figure('Name', figName, 'NumberTitle', 'off', 'Color', 'w');
            
            t = 1:obj.SampleCount;
            if ~isempty(obj.Timestamp) && length(obj.Timestamp) == obj.SampleCount
                % Basic relative time if timestamps are large unix seconds
                t = (obj.Timestamp - obj.Timestamp(1)) / 1000; % Convert ms to s
                xLabelStr = 'Time (s)';
            else
                xLabelStr = 'Sample Index';
            end

            axes_labels = {'X-axis', 'Y-axis', 'Z-axis'};
            data_cols = {obj.X, obj.Y, obj.Z};
            colors = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250]; % Professional MATLAB colors

            for i = 1:3
                subplot(3, 1, i);
                plot(t, data_cols{i}, 'Color', colors(i,:), 'LineWidth', 1.2);
                title(axes_labels{i}, 'FontSize', 10);
                ylabel('m/s^2');
                if i == 3, xlabel(xLabelStr); end
                grid on;
                box on;
            end
            
            % Add a super title
            sgtitle(['Motion Signature: ', obj.StateName], 'FontWeight', 'bold');
        end
    end
end
