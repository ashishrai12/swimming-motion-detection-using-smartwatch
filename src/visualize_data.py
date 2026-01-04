import os
import numpy as np
import matplotlib.pyplot as plt

def parse_vector(s):
    # Parse strings like "[-1.1971009,2.1452048,11.702858]"
    try:
        s = s.strip(' \n\r[]')
        return [float(x) for x in s.split(',')]
    except:
        return None

def load_motion_data(filepath):
    filename = os.path.basename(filepath)
    print(f"Loading {filename}...")
    
    with open(filepath, 'r') as f:
        lines = f.readlines()
    
    # Skip comments and find first data line
    data_lines = []
    is_piped = False
    is_comma = False
    
    for line in lines:
        if line.startswith('#') or not line.strip():
            continue
        if '|' in line:
            is_piped = True
        if ',' in line and not is_piped:
            is_comma = True
        data_lines.append(line.strip())
            
    x, y, z = [], [], []
    
    if is_piped:
        for line in data_lines:
            parts = line.split('|')
            if len(parts) >= 3:
                vec = parse_vector(parts[2])
                if vec and len(vec) >= 3:
                    x.append(vec[0])
                    y.append(vec[1])
                    z.append(vec[2])
        return np.array(x), np.array(y), np.array(z), "Piped Format"
    
    elif is_comma:
        for line in data_lines:
            # Handle possible trailing comments like in edit.txt style
            clean_line = line.split(']|')[0] if ']|' in line else line
            parts = clean_line.replace(']', '').split(',')
            if len(parts) >= 3:
                try:
                    x.append(float(parts[0]))
                    y.append(float(parts[1]))
                    z.append(float(parts[2]))
                except ValueError:
                    continue
        return np.array(x), np.array(y), np.array(z), "Comma Separated"
    
    else:
        for line in data_lines:
            parts = line.split()
            if len(parts) >= 3:
                try:
                    x.append(float(parts[0]))
                    y.append(float(parts[1]))
                    z.append(float(parts[2]))
                except ValueError:
                    continue
        return np.array(x), np.array(y), np.array(z), "Space Separated"

def plot_data(x, y, z, title, out_filename):
    if len(x) == 0:
        print(f"No data to plot for {title}")
        return

    fig, axes = plt.subplots(3, 1, figsize=(10, 8), sharex=True)
    fig.suptitle(title, fontsize=16, fontweight='bold')
    
    colors = ['#0072BD', '#D95319', '#EDB120']
    labels = ['X-axis', 'Y-axis', 'Z-axis']
    data = [x, y, z]
    
    for i in range(3):
        axes[i].plot(data[i], color=colors[i], linewidth=1)
        axes[i].set_title(labels[i])
        axes[i].set_ylabel('m/s²')
        axes[i].grid(True, linestyle='--', alpha=0.7)
    
    axes[2].set_xlabel('Sample Index')
    plt.tight_layout(rect=[0, 0.03, 1, 0.95])
    plt.savefig(out_filename)
    plt.close()

def main():
    data_dir = 'data'
    files = [
        ('Nothing.txt', 'Idle State (Stationary)'),
        ('Swim.txt', 'Active Swimming (Periodic)'),
        ('Drown.txt', 'Distress Signal (Chaotic)'),
        ('SensorLogSwim.txt', 'Raw Sensor Log (Piped)')
    ]
    
    plot_dir = 'plots'
    if not os.path.exists(plot_dir):
        os.makedirs(plot_dir)
        
    for fname, label in files:
        fpath = os.path.join(data_dir, fname)
        if os.path.exists(fpath):
            try:
                x, y, z, fmt = load_motion_data(fpath)
                out_name = os.path.join(plot_dir, f"{fname.split('.')[0]}_plot.png")
                plot_data(x, y, z, f"{label} - {fmt}", out_name)
                print(f"Generated {out_name}")
            except Exception as e:
                print(f"Error processing {fname}: {e}")

if __name__ == "__main__":
    main()
