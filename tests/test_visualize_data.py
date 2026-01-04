import unittest
import os
import sys
import numpy as np
from io import StringIO

# Add src to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))
from visualize_data import parse_vector, load_motion_data, plot_data


class TestParseVector(unittest.TestCase):
    """Test cases for parse_vector function"""
    
    def test_parse_valid_vector(self):
        """Test parsing a valid vector string"""
        result = parse_vector("[-1.197, 2.145, 11.702]")
        self.assertIsNotNone(result)
        self.assertEqual(len(result), 3)
        self.assertAlmostEqual(result[0], -1.197, places=3)
        self.assertAlmostEqual(result[1], 2.145, places=3)
        self.assertAlmostEqual(result[2], 11.702, places=3)
    
    def test_parse_vector_no_spaces(self):
        """Test parsing vector without spaces"""
        result = parse_vector("[-1.197,2.145,11.702]")
        self.assertIsNotNone(result)
        self.assertEqual(len(result), 3)
    
    def test_parse_vector_with_whitespace(self):
        """Test parsing vector with extra whitespace"""
        result = parse_vector("  [-1.197, 2.145, 11.702]  \n")
        self.assertIsNotNone(result)
        self.assertEqual(len(result), 3)
    
    def test_parse_invalid_vector(self):
        """Test parsing invalid vector returns None"""
        result = parse_vector("invalid data")
        self.assertIsNone(result)
    
    def test_parse_empty_vector(self):
        """Test parsing empty string"""
        result = parse_vector("")
        self.assertIsNone(result)


class TestLoadMotionData(unittest.TestCase):
    """Test cases for load_motion_data function"""
    
    def setUp(self):
        """Set up test fixtures"""
        self.test_dir = 'test_data'
        os.makedirs(self.test_dir, exist_ok=True)
    
    def tearDown(self):
        """Clean up test files"""
        import shutil
        if os.path.exists(self.test_dir):
            shutil.rmtree(self.test_dir)
    
    def test_load_space_separated_data(self):
        """Test loading space-separated format"""
        filepath = os.path.join(self.test_dir, 'test_space.txt')
        with open(filepath, 'w') as f:
            f.write("# Comment line\n")
            f.write("0.622 0.823 2.367 10\n")
            f.write("0.568 0.732 2.070 10\n")
            f.write("0.572 0.590 1.794 10\n")
        
        x, y, z, fmt = load_motion_data(filepath)
        
        self.assertEqual(fmt, "Space Separated")
        self.assertEqual(len(x), 3)
        self.assertEqual(len(y), 3)
        self.assertEqual(len(z), 3)
        self.assertAlmostEqual(x[0], 0.622, places=3)
        self.assertAlmostEqual(y[1], 0.732, places=3)
        self.assertAlmostEqual(z[2], 1.794, places=3)
    
    def test_load_comma_separated_data(self):
        """Test loading comma-separated format"""
        filepath = os.path.join(self.test_dir, 'test_comma.txt')
        with open(filepath, 'w') as f:
            f.write("0.622,0.823,2.367\n")
            f.write("0.568,0.732,2.070\n")
            f.write("0.572,0.590,1.794\n")
        
        x, y, z, fmt = load_motion_data(filepath)
        
        self.assertEqual(fmt, "Comma Separated")
        self.assertEqual(len(x), 3)
        self.assertAlmostEqual(x[0], 0.622, places=3)
    
    def test_load_piped_data(self):
        """Test loading pipe-separated format"""
        filepath = os.path.join(self.test_dir, 'test_piped.txt')
        with open(filepath, 'w') as f:
            f.write("statusId|sensorName|value|timestamp\n")
            f.write("8|3-axis Accelerometer|[-1.197,2.145,11.702]|1485609775802\n")
            f.write("8|3-axis Accelerometer|[-1.063,1.608,11.607]|1485609775821\n")
        
        x, y, z, fmt = load_motion_data(filepath)
        
        self.assertEqual(fmt, "Piped Format")
        self.assertEqual(len(x), 2)
        self.assertAlmostEqual(x[0], -1.197, places=3)
        self.assertAlmostEqual(y[0], 2.145, places=3)
        self.assertAlmostEqual(z[0], 11.702, places=3)
    
    def test_load_data_with_comments(self):
        """Test loading data with comment lines"""
        filepath = os.path.join(self.test_dir, 'test_comments.txt')
        with open(filepath, 'w') as f:
            f.write("# Accelerometer Data File\n")
            f.write("# Started @Mon Jan 16 23:01:50 GMT+05:30 2017\n")
            f.write("#\n")
            f.write("# sensor Vendor: Kionix\n")
            f.write("0.622 0.823 2.367\n")
            f.write("0.568 0.732 2.070\n")
        
        x, y, z, fmt = load_motion_data(filepath)
        
        self.assertEqual(len(x), 2)
        self.assertAlmostEqual(x[0], 0.622, places=3)
    
    def test_load_data_with_invalid_lines(self):
        """Test loading data with some invalid lines"""
        filepath = os.path.join(self.test_dir, 'test_invalid.txt')
        with open(filepath, 'w') as f:
            f.write("0.622 0.823 2.367\n")
            f.write("invalid line\n")
            f.write("0.568 0.732 2.070\n")
        
        x, y, z, fmt = load_motion_data(filepath)
        
        # Should skip invalid line
        self.assertEqual(len(x), 2)
    
    def test_load_empty_file(self):
        """Test loading empty file"""
        filepath = os.path.join(self.test_dir, 'test_empty.txt')
        with open(filepath, 'w') as f:
            f.write("# Only comments\n")
            f.write("#\n")
        
        x, y, z, fmt = load_motion_data(filepath)
        
        # Should return empty arrays
        self.assertEqual(len(x), 0)
        self.assertEqual(len(y), 0)
        self.assertEqual(len(z), 0)


class TestPlotData(unittest.TestCase):
    """Test cases for plot_data function"""
    
    def setUp(self):
        """Set up test fixtures"""
        self.test_dir = 'test_plots'
        os.makedirs(self.test_dir, exist_ok=True)
    
    def tearDown(self):
        """Clean up test files"""
        import shutil
        if os.path.exists(self.test_dir):
            shutil.rmtree(self.test_dir)
    
    def test_plot_valid_data(self):
        """Test plotting valid data"""
        x = np.array([0.1, 0.2, 0.3, 0.4, 0.5])
        y = np.array([0.5, 0.4, 0.3, 0.2, 0.1])
        z = np.array([1.0, 1.1, 1.2, 1.3, 1.4])
        
        output_path = os.path.join(self.test_dir, 'test_plot.png')
        plot_data(x, y, z, "Test Plot", output_path)
        
        # Check that file was created
        self.assertTrue(os.path.exists(output_path))
        self.assertGreater(os.path.getsize(output_path), 0)
    
    def test_plot_empty_data(self):
        """Test plotting empty data"""
        x = np.array([])
        y = np.array([])
        z = np.array([])
        
        output_path = os.path.join(self.test_dir, 'test_empty_plot.png')
        
        # Capture stdout to check for warning message
        old_stdout = sys.stdout
        sys.stdout = StringIO()
        
        plot_data(x, y, z, "Empty Plot", output_path)
        
        output = sys.stdout.getvalue()
        sys.stdout = old_stdout
        
        # Should print warning and not create file
        self.assertIn("No data to plot", output)
        self.assertFalse(os.path.exists(output_path))
    
    def test_plot_single_point(self):
        """Test plotting single data point"""
        x = np.array([0.5])
        y = np.array([0.5])
        z = np.array([1.0])
        
        output_path = os.path.join(self.test_dir, 'test_single.png')
        plot_data(x, y, z, "Single Point", output_path)
        
        self.assertTrue(os.path.exists(output_path))
    
    def test_plot_large_dataset(self):
        """Test plotting large dataset"""
        n = 10000
        x = np.random.randn(n)
        y = np.random.randn(n)
        z = np.random.randn(n)
        
        output_path = os.path.join(self.test_dir, 'test_large.png')
        plot_data(x, y, z, "Large Dataset", output_path)
        
        self.assertTrue(os.path.exists(output_path))


class TestIntegration(unittest.TestCase):
    """Integration tests for the complete workflow"""
    
    def setUp(self):
        """Set up test fixtures"""
        self.test_dir = 'test_integration'
        os.makedirs(self.test_dir, exist_ok=True)
    
    def tearDown(self):
        """Clean up test files"""
        import shutil
        if os.path.exists(self.test_dir):
            shutil.rmtree(self.test_dir)
    
    def test_complete_workflow_space_format(self):
        """Test complete workflow with space-separated data"""
        # Create test data file
        data_file = os.path.join(self.test_dir, 'test_data.txt')
        with open(data_file, 'w') as f:
            f.write("# Test data\n")
            for i in range(100):
                f.write(f"{i*0.01} {i*0.02} {i*0.03}\n")
        
        # Load data
        x, y, z, fmt = load_motion_data(data_file)
        
        # Verify data
        self.assertEqual(len(x), 100)
        self.assertEqual(fmt, "Space Separated")
        
        # Plot data
        plot_file = os.path.join(self.test_dir, 'test_plot.png')
        plot_data(x, y, z, "Integration Test", plot_file)
        
        # Verify plot created
        self.assertTrue(os.path.exists(plot_file))
    
    def test_complete_workflow_piped_format(self):
        """Test complete workflow with piped data"""
        # Create test data file
        data_file = os.path.join(self.test_dir, 'test_piped.txt')
        with open(data_file, 'w') as f:
            f.write("statusId|sensorName|value|timestamp\n")
            for i in range(50):
                f.write(f"8|Accelerometer|[{i*0.1},{i*0.2},{i*0.3}]|{1485609775802+i}\n")
        
        # Load data
        x, y, z, fmt = load_motion_data(data_file)
        
        # Verify data
        self.assertEqual(len(x), 50)
        self.assertEqual(fmt, "Piped Format")
        
        # Plot data
        plot_file = os.path.join(self.test_dir, 'test_piped_plot.png')
        plot_data(x, y, z, "Piped Integration Test", plot_file)
        
        # Verify plot created
        self.assertTrue(os.path.exists(plot_file))


if __name__ == '__main__':
    # Run tests with verbose output
    unittest.main(verbosity=2)
