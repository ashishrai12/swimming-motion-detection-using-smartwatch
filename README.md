# Swimming Motion Detection Using Smartwatch

This project uses Pebble Smartwatch accelerometer data to classify aquatic movement patterns. By analyzing 3-axis motion signals, the system distinguishes between being stationary, active swimming, and erratic movement patterns associated with drowning.

## Project Structure

The project is organized into the following directories:

- `data/`: Contains raw sensor logs (`.txt` files) exported from the smartwatch.
- `src/`: Contains MATLAB source code for data analysis and visualization.
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
3.  The script will process the data in the `data/` directory and generate plots for the following states:
    - **Idle (Nothing)**: Baseline stationary motion.
    - **Swimming**: Rhythmic, periodic motion.
    - **Distress (Drowning)**: chaotic, high-amplitude signals.

## Technical Details

### Signal Characteristics

| Activity | Data Source | Expected Waveform |
| :--- | :--- | :--- |
| **Idle** | `data/Nothing.txt` | Flat lines with minor sensor noise. |
| **Swimming** | `data/Swim.txt` | Periodic sinusoidal waves. |
| **Drowning** | `data/Drown.txt` | Spiky, high-frequency, irregular peaks. |

### Core Components

- **`src/plot_motion_data.m`**: A reusable function that handles data ingestion (using `textscan`) and organizes X, Y, and Z axes into a vertical subplot stack.
- **`src/main_analysis.m`**: The main execution script that configures and calls the plotting utility for all study cases.

## Future Improvements

- [ ] Implement a Fast Fourier Transform (FFT) to detect stroke frequency.
- [ ] Add a real-time threshold trigger for "Drowning" detection.
- [ ] Support for modern hardware formats (Fitbit, Garmin, Apple Watch).

---
*Developed for aquatic safety research using Pebble Smartwatch analytics.*
