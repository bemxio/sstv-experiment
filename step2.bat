@echo off

: needed to increment variables in a loop
setlocal EnableDelayedExpansion

: clear & remake the "frames" directory
rmdir /s /q frames
mkdir frames

: copy the frames from the RX-SSTV's history
copy "C:\Users\bemxio\Amateur Radio\RX-SSTV\History" frames

: rename the frames
set i = 1

for /r %%f in (frames\*) do (
    set /a i += 1
    ren %%f frame!i!.bmp
)

: make the final video
ffmpeg -r 15 -s 320:240 -i frames/frame%%01d.bmp final.avi

: clean up stuff and pause
rmdir /s /q frames

endlocal
pause