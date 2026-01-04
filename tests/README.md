# Test Suite

This directory contains comprehensive unit tests for the Swimming Motion Detection project.

## Python Tests

### Running Python Tests

```bash
# Run all tests
python -m unittest discover tests

# Run with verbose output
python -m unittest discover tests -v

# Run specific test file
python -m unittest tests.test_visualize_data

# Run with coverage (if coverage.py is installed)
coverage run -m unittest discover tests
coverage report
coverage html
```

### Test Coverage

The Python test suite (`test_visualize_data.py`) includes:

- **`TestParseVector`**: Tests for vector string parsing
  - Valid vector parsing
  - Vectors without spaces
  - Vectors with extra whitespace
  - Invalid vector handling
  - Empty string handling

- **`TestLoadMotionData`**: Tests for data loading functionality
  - Space-separated format
  - Comma-separated format
  - Pipe-separated format
  - Files with comment lines
  - Files with invalid lines
  - Empty files

- **`TestPlotData`**: Tests for plotting functionality
  - Valid data plotting
  - Empty data handling
  - Single data point
  - Large datasets (10,000+ samples)

- **`TestIntegration`**: End-to-end integration tests
  - Complete workflow with space format
  - Complete workflow with piped format

## MATLAB Tests

### Running MATLAB Tests

```matlab
% Add tests directory to path
addpath('tests');

% Run all tests
results = runtests('TestMotionData');

% Display results
disp(results);

% Run with detailed output
results = runtests('TestMotionData', 'OutputDetail', 'Verbose');

% Generate code coverage report (requires MATLAB R2018b+)
import matlab.unittest.TestRunner;
import matlab.unittest.plugins.CodeCoveragePlugin;

runner = TestRunner.withTextOutput;
runner.addPlugin(CodeCoveragePlugin.forFolder('../src'));
results = runner.run(TestMotionData);
```

### Test Coverage

The MATLAB test suite (`TestMotionData.m`) includes:

- **Constructor Tests**
  - Valid file loading
  - Invalid file error handling
  - Empty file error handling

- **Format Detection Tests**
  - Space-separated format
  - Comma-separated format
  - Pipe-separated format

- **Data Integrity Tests**
  - Correct value parsing
  - Comment line handling
  - Timestamp parsing

- **Plotting Tests**
  - Figure creation
  - Empty data warning

- **Edge Case Tests**
  - Large datasets (10,000 samples)
  - Single data point
  - Malformed piped data

- **Property Tests**
  - All properties properly set

## Test Data

Test files are automatically created and cleaned up by the test suites. No manual test data preparation is required.

## Continuous Integration

To integrate these tests into a CI/CD pipeline:

```yaml
# Example GitHub Actions workflow
- name: Run Python Tests
  run: |
    python -m unittest discover tests -v

# For MATLAB (requires MATLAB installation)
- name: Run MATLAB Tests
  run: |
    matlab -batch "addpath('tests'); runtests('TestMotionData')"
```
