setlocal
fsutil reparsepoint query %1
if not errorlevel 1 (
    rd %1
)
:next
set /a i+=1
if exist %1%i% (
    goto next
)
ren %1 %~n1%i%
md %2
mklink /j %1 %2
endlocal