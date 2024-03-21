import os
import argparse
import numpy as np
import plotly.graph_objects as px


def parse_file(file_name):
    # Open the file
    with open(file_name, 'r') as file:
        # Initialize an empty list to store the rms values
        rms_values = []
        # Read the file line by line
        for line in file:
            # Split the line into fields based on the colon (:) separator
            fields = line.split(':')
            # Check if the line contains the 'rms' value
            if 'rms' in line:
                # Extract the 'rms' value from the line
                # print(line)
                rms_value = fields[1].strip().split()[1]
                # Append the 'rms' value to the list
                rms_values.append(float(rms_value))
    return rms_values


def main():
    # Create an ArgumentParser object
    parser = argparse.ArgumentParser(description='Extract rms values from a text file')

    # Add an argument for the file name
    parser.add_argument('-f', '--file', type=str, help='Name of the input file')
    # Add an argument for the directory path
    parser.add_argument('-d', '--directory', type=str, help='Path to the directory containing input files')

    # Parse the command-line arguments
    args = parser.parse_args()

    # Check if neither file nor directory argument is provided
    if not args.file and not args.directory:
        parser.error('Please provide either a file or a directory')

    # Create an empty dictionary to store the rms arrays
    rms_arrays = {}

    # If file argument is provided, process the single file
    if args.file:
        rms_values = parse_file(args.file)
        rms_array = np.array(rms_values)
        rms_arrays[args.file] = rms_array

    # If directory argument is provided, process all files in the directory
    if args.directory:
        for file_name in os.listdir(args.directory):
            file_path = os.path.join(args.directory, file_name)
            if os.path.isfile(file_path):
                rms_values = parse_file(file_path)
                rms_array = np.array(rms_values)
                rms_arrays[file_name] = rms_array

    # Print the rms arrays for each file
    for file_name, rms_array in rms_arrays.items():
        #print(f'RMS array for {file_name}: {rms_array}')
        plot = px.Figure(data=[px.Scatter(
            y=rms_array,
            mode='lines',
            # make the line red (for Malicious)
            # TODO: make the benign traffic blue, and the malicious traffic different shades of red
            # TODO: each malicious trace should have a different marker and line style (dashed, dotted, etc)
            line=dict(color="#FF0000")
        )])

        plot.update_layout(
            title="PTP Clock Offset for {}".format(file_name),
            yaxis_title="Offset (ns)",
            xaxis_title="Elapsed time (s)",
            xaxis=dict(
                rangeselector=dict(
                    buttons=list([
                        dict(count=1,
                             step="second",
                             stepmode="backward"),
                    ])
                ),
                rangeslider=dict(
                    visible=True
                ),
            ),
            yaxis=dict(
                autorange=True,
                fixedrange=False
            )
        )

        plot.show()


if __name__ == '__main__':
    main()

