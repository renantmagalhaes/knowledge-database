# Extract audio from video 

```
ffmpeg -i VIDEO_FILE.mp4(or .avi) -q:a 0 -map a AUDIO_FILE.mp3
```