# Extracting frames

## Retrieving the video
 ```bash
 yt-dlp -f "bestvideo[ext=mp4]/best[ext=mp4]/best" -o "input/downloaded_video.mp4" "<URL>"
 sh ./extract_frames.sh "input/downloaded_video.mp4"
 ```