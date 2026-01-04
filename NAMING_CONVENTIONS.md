# Naming Conventions

This document outlines the naming conventions used throughout the project for consistency and maintainability.

## File Naming Conventions

### MATLAB Files
- **Convention**: PascalCase
- **Examples**:
  - `MotionData.m` - Class definition
  - `MainAnalysis.m` - Main analysis script
  - `TestMotionData.m` - Test file

### Python Files
- **Convention**: snake_case
- **Examples**:
  - `visualize_data.py` - Visualization script
  - `test_visualize_data.py` - Test file

### Data Files
- **Convention**: PascalCase (for consistency and readability)
- **Examples**:
  - `Nothing.txt` - Idle state sensor data
  - `Swim.txt` - Swimming motion data
  - `Drown.txt` - Distress signal data
  - `SensorLogSwim.txt` - Raw sensor log
  - `EditData.txt` - Edited/processed data

### Documentation Files
- **Convention**: PascalCase with descriptive names
- **Examples**:
  - `Nothing.doc` - Idle state documentation
  - `Swim.doc` - Swimming documentation
  - `Drown.doc` - Drowning documentation
  - `EditData.docx` - Edited data documentation

### Generated Output Files
- **Convention**: lowercase snake_case
- **Examples**:
  - `nothing_plot.png`
  - `swim_plot.png`
  - `drown_plot.png`
  - `sensor_log_swim_plot.png`

## Code Naming Conventions

### MATLAB
- **Classes**: PascalCase (e.g., `MotionData`)
- **Methods**: camelCase (e.g., `loadData`, `plot`)
- **Properties**: PascalCase (e.g., `Filename`, `StateName`, `SampleCount`)
- **Variables**: camelCase (e.g., `fileID`, `dataLines`)
- **Constants**: UPPER_SNAKE_CASE (if any)

### Python
- **Functions**: snake_case (e.g., `parse_vector`, `load_motion_data`, `plot_data`)
- **Classes**: PascalCase (e.g., `TestMotionData`)
- **Variables**: snake_case (e.g., `file_path`, `data_lines`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `DATA_DIR`)

## Directory Structure
```
swimming-motion-detection-using-smartwatch/
├── data/                    # Raw sensor data files (PascalCase)
│   ├── Nothing.txt
│   ├── Swim.txt
│   ├── Drown.txt
│   ├── SensorLogSwim.txt
│   └── EditData.txt
├── docs/                    # Documentation files (PascalCase)
│   ├── Nothing.doc
│   ├── Swim.doc
│   ├── Drown.doc
│   └── EditData.docx
├── plots/                   # Generated plot files (snake_case)
│   ├── nothing_plot.png
│   ├── swim_plot.png
│   ├── drown_plot.png
│   └── sensor_log_swim_plot.png
├── src/                     # Source code
│   ├── MotionData.m        # MATLAB class (PascalCase)
│   ├── MainAnalysis.m      # MATLAB script (PascalCase)
│   └── visualize_data.py   # Python script (snake_case)
└── tests/                   # Test files
    ├── TestMotionData.m    # MATLAB tests (PascalCase)
    └── test_visualize_data.py  # Python tests (snake_case)
```

## Rationale

These conventions follow the standard practices for each language:
- **MATLAB**: Traditionally uses PascalCase for files and classes
- **Python**: PEP 8 style guide recommends snake_case for functions and modules
- **Output files**: Lowercase for better cross-platform compatibility
