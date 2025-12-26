# Swimming detection

Readings for DataPlotSensorLog.m look most promising.
Use the data from files, Nothing.doc, swim.doc, and drown.doc and save them as '.txt' files in your matlab path.
Run the code to see the plotted graphical output.

<img width="741" height="703" alt="image" src="https://github.com/user-attachments/assets/6d7631d0-59b9-435f-beae-de044be9f51a" />


Pebble Motion Analytics: Swimming & Distress DetectionThis project uses Pebble Smartwatch accelerometer data to classify aquatic movement patterns. By analyzing 3-axis motion signals, the system distinguishes between being stationary, active swimming, and erratic movement patterns associated with drowning.

📌 Project OverviewThe goal of this project is to create a baseline for a wearable safety system. Using MATLAB, we process raw sensor logs to visualize the "signature" of different water-based activities.Monitored States:Nothing (Baseline): Stationary or idle movement.Swimming: Rhythmic, periodic motion representing consistent strokes.Drowning: High-amplitude, chaotic, and non-periodic signals representing distress.

📊 Data VisualizationThe script processes three specific data files (edit.txt, edit1.txt, and edit2.txt). For each state, it generates a 3-axis plot (X, Y, and Z) to compare signal variance.ActivityData SourceExpected WaveformIdleedit.txtFlat lines with minor sensor noise.Swimmingedit1.txtPeriodic sinusoidal waves.Drowningedit2.txtSpiky, high-frequency, irregular peaks.


🔍 How the Code WorksThe script utilizes a custom textscan configuration to handle the specific metadata and delimiters exported by Pebble logger apps:Matlab% Example of the data ingestion logic
fileID = fopen('edit1.txt');
C = textscan(fileID,'%f,%f,%f','delimiter', '\n','CommentStyle',']|');
fclose(fileID);

% Visualization logic
subplot(3,1,1);
plot(1:length(C{1}),C{1});
title('X-axis');
Delimiter Handling: Uses \n and custom CommentStyle to ignore non-numeric header data.Subplotting: Organizes X, Y, and Z axes into a single vertical stack for easy comparison of directional force.🛠 Future Improvements[ ] Implement a Fast Fourier Transform (FFT) to detect stroke frequency.[ ] Add a real-time threshold trigger for "Drowning" detection.[ ] Support for Pebble's successor hardware (Fitbit/Garmin) data formats.
