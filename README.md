# Swimming Motion Detection Using Smartwatch

This project uses Pebble Smartwatch accelerometer data to classify aquatic movement patterns. By analyzing 3-axis motion signals, the system distinguishes between being stationary, active swimming, and erratic movement patterns associated with drowning.

## Project Structure

The project is organized into the following professional directory structure:

- `data/`: Contains raw sensor logs (`.txt` files) in various formats (space, comma, or pipe separated).
- `src/`: Contains MATLAB source code featuring a class-based architecture.
- `docs/`: Contains original project documentation and reports.

## Getting Started

### Prerequisites

- MATLAB (R2018a or later recommended)

### Running the Analysis

1.  Navigate to the `src/` directory in MATLAB.
2.  Run the `main_analysis.m` script:
    ```matlab
    main_analysis
    ```
3.  The script will automatically detect the format of each file in the `data/` directory and generate professional visualizations.

## Technical Architecture

The project has been refactored for robustness and professional standards:

### `MotionData` Class
A custom MATLAB class (`src/MotionData.m`) serves as the core data engine. It features:
- **Automatic Format Detection**: Seamlessly handles multiple legacy and modern data formats.
- **Robust Parsing**: Extracts coordinate data even from complex string representations.
- **Professional Visualization**: Generates standardized, publication-quality 3-axis plots with automatic time scaling.

### Analysis Entry Point
`src/main_analysis.m` handles the high-level orchestration, ensuring that all study states (Idle, Swimming, Drowning) are processed and compared correctly.

## Data Signatures

| Activity | Expected Waveform |
| :--- | :--- |
| **Idle** | Flat lines with minor sensor noise. |
| **Swimming** | Periodic sinusoidal waves representing rhythmic strokes. |
| **Drowning** | Spiky, high-frequency, irregular peaks indicating distress. |

## Testing

The project includes comprehensive unit tests for both Python and MATLAB implementations.

### Running Python Tests

```bash
# Run all tests
python -m unittest discover tests -v

# Expected output: 17 tests passed
```

### Running MATLAB Tests

```matlab
% In MATLAB
addpath('tests');
results = runtests('TestMotionData');
```

See `tests/README.md` for detailed testing documentation.

## Future Improvements

- [ ] Implement a Fast Fourier Transform (FFT) to detect stroke frequency.
- [ ] Add a real-time threshold trigger for "Drowning" detection.
- [ ] Support for modern hardware formats (Fitbit, Garmin, Apple Watch).

---
*Developed for aquatic safety research using Pebble Smartwatch analytics.*
