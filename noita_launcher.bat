setlocal

rem NoitaLauncher - Version 1.1.2
rem Created by ImmortalDamned
rem Github https://github.com/XM666-Dev/NoitaLauncher

chcp 65001

for /f "skip=1 tokens=2*" %%i in ('reg query HKEY_CURRENT_USER\Software\Valve\Steam /v SteamPath') do (
    set game_path=%%~fj\steamapps\common\Noita
)
set save_path=Nolla_Games_Noita

set config_path=config.ini
for /f "eol=; delims== tokens=1* usebackq" %%i in ("%config_path%") do (
    set %%i=%%j
)

echo 2>"%config_path%"
echo ;The game directory of Noita. Default is "YourSteamPath"\steamapps\common\Noita>>"%config_path%"
echo ;Noita的游戏目录。默认是"你的Steam路径"\steamapps\common\Noita>>"%config_path%"
echo game_path=%game_path%>>"%config_path%"
echo ;The save directory which will link to>>"%config_path%"
echo ;要联接到的存档目录>>"%config_path%"
echo save_path=%save_path%>>"%config_path%"

call islinker "%USERPROFILE%\AppData\LocalLow\Nolla_Games_Noita" "%save_path%"

for /d %%i in ("%game_path%\mods\*") do (
	for /f "usebackq" %%j in ("%%i\mod_id.txt") do (
		ren "%%i" "%%j"
	)
)

cd /d %game_path%
start noita

endlocal