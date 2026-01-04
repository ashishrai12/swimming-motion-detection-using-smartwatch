classdef TestMotionData < matlab.unittest.TestCase
    % TestMotionData: Comprehensive unit tests for the MotionData class
    % Tests cover data loading, format detection, plotting, and error handling
    
    properties (TestParameter)
        % Test data formats
        DataFormat = {'space', 'comma', 'piped'}
    end
    
    properties
        TestDataDir
        TestPlotsDir
    end
    
    methods (TestClassSetup)
        function setupTestEnvironment(testCase)
            % Create test directories
            testCase.TestDataDir = fullfile(pwd, 'test_data');
            testCase.TestPlotsDir = fullfile(pwd, 'test_plots');
            
            if ~exist(testCase.TestDataDir, 'dir')
                mkdir(testCase.TestDataDir);
            end
            if ~exist(testCase.TestPlotsDir, 'dir')
                mkdir(testCase.TestPlotsDir);
            end
        end
    end
    
    methods (TestClassTeardown)
        function cleanupTestEnvironment(testCase)
            % Remove test directories
            if exist(testCase.TestDataDir, 'dir')
                rmdir(testCase.TestDataDir, 's');
            end
            if exist(testCase.TestPlotsDir, 'dir')
                rmdir(testCase.TestPlotsDir, 's');
            end
        end
    end
    
    methods (Test)
        %% Constructor Tests
        
        function testConstructorWithValidFile(testCase)
            % Test constructor with valid space-separated file
            testFile = testCase.createSpaceSeparatedFile('test_valid.txt', 100);
            
            obj = MotionData(testFile, 'Test State');
            
            testCase.verifyEqual(obj.StateName, 'Test State');
            testCase.verifyEqual(obj.SampleCount, 100);
            testCase.verifyEqual(length(obj.X), 100);
            testCase.verifyEqual(length(obj.Y), 100);
            testCase.verifyEqual(length(obj.Z), 100);
        end
        
        function testConstructorWithInvalidFile(testCase)
            % Test constructor with non-existent file
            testFile = fullfile(testCase.TestDataDir, 'nonexistent.txt');
            
            testCase.verifyError(@() MotionData(testFile, 'Test'), ...
                'MotionData:FileNotFound');
        end
        
        function testConstructorWithEmptyFile(testCase)
            % Test constructor with empty file
            testFile = fullfile(testCase.TestDataDir, 'empty.txt');
            fid = fopen(testFile, 'w');
            fprintf(fid, '# Only comments\n');
            fprintf(fid, '#\n');
            fclose(fid);
            
            testCase.verifyError(@() MotionData(testFile, 'Empty'), ...
                'MotionData:EmptyFile');
        end
        
        %% Format Detection Tests
        
        function testSpaceSeparatedFormat(testCase)
            % Test loading space-separated format
            testFile = testCase.createSpaceSeparatedFile('test_space.txt', 50);
            
            obj = MotionData(testFile, 'Space Test');
            
            testCase.verifyEqual(obj.SampleCount, 50);
            testCase.verifyClass(obj.X, 'double');
            testCase.verifyClass(obj.Y, 'double');
            testCase.verifyClass(obj.Z, 'double');
        end
        
        function testCommaSeparatedFormat(testCase)
            % Test loading comma-separated format
            testFile = testCase.createCommaSeparatedFile('test_comma.txt', 50);
            
            obj = MotionData(testFile, 'Comma Test');
            
            testCase.verifyEqual(obj.SampleCount, 50);
            testCase.verifyGreaterThan(length(obj.X), 0);
        end
        
        function testPipedFormat(testCase)
            % Test loading pipe-separated format
            testFile = testCase.createPipedFile('test_piped.txt', 50);
            
            obj = MotionData(testFile, 'Piped Test');
            
            testCase.verifyEqual(obj.SampleCount, 50);
            testCase.verifyGreaterThan(length(obj.X), 0);
        end
        
        %% Data Integrity Tests
        
        function testDataValuesSpaceFormat(testCase)
            % Test that data values are correctly parsed
            testFile = fullfile(testCase.TestDataDir, 'test_values.txt');
            fid = fopen(testFile, 'w');
            fprintf(fid, '# Test data\n');
            fprintf(fid, '0.622 0.823 2.367 10\n');
            fprintf(fid, '0.568 0.732 2.070 10\n');
            fprintf(fid, '0.572 0.590 1.794 10\n');
            fclose(fid);
            
            obj = MotionData(testFile, 'Value Test');
            
            testCase.verifyEqual(obj.SampleCount, 3);
            testCase.verifyEqual(obj.X(1), 0.622, 'AbsTol', 0.001);
            testCase.verifyEqual(obj.Y(2), 0.732, 'AbsTol', 0.001);
            testCase.verifyEqual(obj.Z(3), 1.794, 'AbsTol', 0.001);
        end
        
        function testDataWithComments(testCase)
            % Test that comments are properly ignored
            testFile = fullfile(testCase.TestDataDir, 'test_comments.txt');
            fid = fopen(testFile, 'w');
            fprintf(fid, '# Accelerometer Data File\n');
            fprintf(fid, '# Started @Mon Jan 16 23:01:50 GMT+05:30 2017\n');
            fprintf(fid, '#\n');
            fprintf(fid, '# sensor Vendor: Kionix\n');
            fprintf(fid, '0.622 0.823 2.367\n');
            fprintf(fid, '0.568 0.732 2.070\n');
            fclose(fid);
            
            obj = MotionData(testFile, 'Comment Test');
            
            testCase.verifyEqual(obj.SampleCount, 2);
        end
        
        function testTimestampParsing(testCase)
            % Test that timestamps are correctly parsed when available
            testFile = fullfile(testCase.TestDataDir, 'test_timestamp.txt');
            fid = fopen(testFile, 'w');
            fprintf(fid, '0.622 0.823 2.367 10\n');
            fprintf(fid, '0.568 0.732 2.070 20\n');
            fprintf(fid, '0.572 0.590 1.794 30\n');
            fclose(fid);
            
            obj = MotionData(testFile, 'Timestamp Test');
            
            if ~isempty(obj.Timestamp)
                testCase.verifyEqual(length(obj.Timestamp), 3);
                testCase.verifyEqual(obj.Timestamp(1), 10);
            end
        end
        
        %% Plotting Tests
        
        function testPlotCreation(testCase)
            % Test that plot method creates a figure
            testFile = testCase.createSpaceSeparatedFile('test_plot.txt', 100);
            obj = MotionData(testFile, 'Plot Test');
            
            % Close any existing figures
            close all;
            
            % Create plot
            obj.plot();
            
            % Verify figure was created
            figs = findall(0, 'Type', 'figure');
            testCase.verifyGreaterThanOrEqual(length(figs), 1);
            
            % Clean up
            close all;
        end
        
        function testPlotWithEmptyData(testCase)
            % Test plotting with empty data (should warn, not error)
            testFile = testCase.createSpaceSeparatedFile('test_empty_plot.txt', 0);
            
            % Manually create object and clear data
            obj = MotionData.__empty__();
            obj.X = [];
            obj.Y = [];
            obj.Z = [];
            obj.StateName = 'Empty Test';
            
            % Should issue warning but not error
            testCase.verifyWarning(@() obj.plot(), 'MotionData:NoData');
        end
        
        %% Edge Case Tests
        
        function testLargeDataset(testCase)
            % Test with large dataset (10000 samples)
            testFile = testCase.createSpaceSeparatedFile('test_large.txt', 10000);
            
            obj = MotionData(testFile, 'Large Dataset');
            
            testCase.verifyEqual(obj.SampleCount, 10000);
        end
        
        function testSingleDataPoint(testCase)
            % Test with single data point
            testFile = fullfile(testCase.TestDataDir, 'test_single.txt');
            fid = fopen(testFile, 'w');
            fprintf(fid, '0.622 0.823 2.367\n');
            fclose(fid);
            
            obj = MotionData(testFile, 'Single Point');
            
            testCase.verifyEqual(obj.SampleCount, 1);
        end
        
        function testMalformedPipedData(testCase)
            % Test with malformed piped data
            testFile = fullfile(testCase.TestDataDir, 'test_malformed.txt');
            fid = fopen(testFile, 'w');
            fprintf(fid, 'statusId|sensorName|value|timestamp\n');
            fprintf(fid, '8|Accelerometer|[1.0,2.0,3.0]|123456\n');
            fprintf(fid, '8|Accelerometer|malformed|123457\n');
            fprintf(fid, '8|Accelerometer|[4.0,5.0,6.0]|123458\n');
            fclose(fid);
            
            obj = MotionData(testFile, 'Malformed Test');
            
            % Should skip malformed line
            testCase.verifyGreaterThanOrEqual(obj.SampleCount, 2);
        end
        
        %% Property Tests
        
        function testPropertiesAreSet(testCase)
            % Test that all properties are properly set
            testFile = testCase.createSpaceSeparatedFile('test_props.txt', 10);
            
            obj = MotionData(testFile, 'Property Test');
            
            testCase.verifyNotEmpty(obj.Filename);
            testCase.verifyNotEmpty(obj.StateName);
            testCase.verifyNotEmpty(obj.X);
            testCase.verifyNotEmpty(obj.Y);
            testCase.verifyNotEmpty(obj.Z);
            testCase.verifyGreaterThan(obj.SampleCount, 0);
        end
    end
    
    methods (Access = private)
        function filepath = createSpaceSeparatedFile(testCase, filename, numSamples)
            % Helper: Create space-separated test file
            filepath = fullfile(testCase.TestDataDir, filename);
            fid = fopen(filepath, 'w');
            fprintf(fid, '# Test accelerometer data\n');
            fprintf(fid, '# Space separated format\n');
            for i = 1:numSamples
                fprintf(fid, '%.3f %.3f %.3f %d\n', ...
                    rand(), rand(), rand(), randi(20));
            end
            fclose(fid);
        end
        
        function filepath = createCommaSeparatedFile(testCase, filename, numSamples)
            % Helper: Create comma-separated test file
            filepath = fullfile(testCase.TestDataDir, filename);
            fid = fopen(filepath, 'w');
            for i = 1:numSamples
                fprintf(fid, '%.3f,%.3f,%.3f\n', rand(), rand(), rand());
            end
            fclose(fid);
        end
        
        function filepath = createPipedFile(testCase, filename, numSamples)
            % Helper: Create pipe-separated test file
            filepath = fullfile(testCase.TestDataDir, filename);
            fid = fopen(filepath, 'w');
            fprintf(fid, 'statusId|sensorName|value|timestamp\n');
            for i = 1:numSamples
                fprintf(fid, '8|3-axis Accelerometer|[%.3f,%.3f,%.3f]|%d\n', ...
                    rand(), rand(), rand(), 1485609775802 + i);
            end
            fclose(fid);
        end
    end
end
