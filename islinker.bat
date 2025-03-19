setlocal
fsutil reparsepoint query %1 && rd %1
if exist %2 set exist=1
:next
set /a i+=1
if exist %1%i% goto next
ren %1 %~n1%i%
if not exist %2 if "%exist%"=="1" ren %1%i% %~n1 & exit /b
md %2
mklink /j %1 %2
endlocal