: Adjust the paths as necessary to match your configuration.
: The /Fl generates a listing file, and the /map generates a map file.

set file="prog+ucr"

if exist %file%.lst del %file%.lst
if exist %file%.map del %file%.map
if exist %file%.obj del %file%.obj
if exist %file%.exe del %file%.exe
if exist prog.exe del prog.exe

ml.exe /Fl /c %file%.asm

pause

link16 /map %file%.obj;

pause
ren %file%.exe prog.exe