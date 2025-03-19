@>nul 2>&1(setlocal enabledelayedexpansion

rem NoitaLauncher - Version 1.1.3
rem Created by ImmortalDamned
rem Github https://github.com/XM666-Dev/NoitaLauncher

set game_directory_original=Noita
set save_directory_original=Nolla_Games_Noita
set exe_filename=noita.exe
set config_filename=config.ini

set game_directory=!game_directory_original!
set save_directory=!save_directory_original!
if not exist "!game_directory!\!exe_filename!" (
	set game_directory=
	if not exist "!game_directory!\!exe_filename!" (
		for /f "skip=1 tokens=2*" %%i in ('reg query HKEY_CURRENT_USER\Software\Valve\Steam /v SteamPath') do (
			set game_directory=%%~fj\steamapps\common\!game_directory_original!
			if not exist "!game_directory!\!exe_filename!" (
				set game_directory=
			)
		)
	)
)

for /f "eol=; delims== tokens=1* usebackq" %%i in ("!config_filename!") do (
    set %%i=%%j
)

echo 2>"!config_filename!"
echo ; The game directory for launching>>"!config_filename!"
echo game_directory=!game_directory!>>"!config_filename!"
echo ; The save directory for linking>>"!config_filename!"
echo save_directory=!save_directory!>>"!config_filename!"

for /f "delims=: tokens=1*" %%i in ('fsutil reparsepoint query "%LOCALAPPDATA%Low\!save_directory_original!"') do for /f "tokens=*" %%j in ("%%j") do (
	if "%%i"=="Print Name" if exist "%%j\data" if not exist "!save_directory!\data" call islinker.bat "!save_directory!\data" "%%j\data"
)
call islinker.bat "%LOCALAPPDATA%Low\!save_directory_original!" "!save_directory!"

for /d %%i in ("!game_directory!\mods\*") do (
	for /f "usebackq" %%j in ("%%i\mod_id.txt") do (
		ren "%%i" "%%j"
	)
)

start /d "!game_directory!" "" "!exe_filename!"

endlocal)