#!/bin/bash

# Check if input file is provided
if [ $# -eq 0 ]; then
    echo "Please provide an input video file."
    exit 1
fi

input_file=$1
output_dir="output"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Get video information
video_info=$(ffprobe -v error -select_streams v:0 -count_packets -show_entries stream=nb_read_packets -of csv=p=0 "$input_file")

# Extract frame rate
fps=$(ffprobe -v error -select_streams v -of default=noprint_wrappers=1:nokey=1 -show_entries stream=r_frame_rate "$input_file")

echo "Detected frame rate: $fps"

# Determine hardware acceleration method
if command_exists nvidia-smi; then
    hw_accel="-hwaccel cuda -hwaccel_output_format cuda"
elif [ "$(uname)" == "Darwin" ]; then
    hw_accel="-hwaccel videotoolbox"
else
    hw_accel=""
fi

# Extract frames with optimizations
echo "Extracting frames..."
ffmpeg $hw_accel -i "$input_file" -vf "fps=$fps" -q:v 2 "$output_dir/frame_%04d.png"

echo "Frame extraction complete. Frames saved in $output_dir/"

# Optional: Remove the downloaded video to save space
# Uncomment the next line if you want to delete the video file after extraction
# rm "$input_file"

echo "Process completed successfully!"