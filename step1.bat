@echo off

: needed to increment variables in a loop
setlocal EnableDelayedExpansion

: clear the "frames" and the "audio" directory
rmdir /s /q frames
rmdir /s /q audio

: remake the "frames" directory
mkdir frames

: convert the video to frames
ffmpeg -i %1 frames/frame%%01d.png

: convert the frames to SSTV audio files
echo Converting frames to SSTV audio files, please wait...

mkdir audio
set i = 1

for /r %%f in (frames\*) do (
    set /a i += 1
    python -m pysstv --mode Robot36 %%f audio/frame!i!.wav
)

: concatenate all of the files
(for %%f in (audio\*.wav) do (
    echo file '%%f'
)) > files.txt

ffmpeg -f concat -safe 0 -i files.txt -c copy audio.wav

: clean up stuff and pause
rmdir /s /q audio
rmdir /s /q frames
del files.txt

endlocal
pause

: show the end message
cls
echo Done! You can now play the 'audio.wav' file while RX-SSTV is on.
echo After the audio ends, run the 'step2.bat' script to continue!