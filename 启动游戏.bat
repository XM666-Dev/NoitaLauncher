@echo off
setlocal EnableDelayedExpansion
rem NoitaLauncher-Created by ImmotralDamned
rem Github:
rem Version 1.1
chcp 65001 >NUL
set config_path=config.txt
if not exist !config_path! (
    for /f "tokens=1,2*" %%i in ('reg query HKEY_CURRENT_USER\Software\Valve\Steam /v SteamPath') do (
        if %%i==SteamPath (
            set game_path=%%k\steamapps\common\Noita
        )
    )
    echo 游戏路径=!game_path!>> !config_path!
    echo 存档路径=Nolla_Games_Noita>> !config_path!
)
for /f "delims== tokens=1*" %%i in (!config_path!) do (
    if %%i==游戏路径 (
        set game_path=%%j
    )
    if %%i==存档路径 (
        set link_to_path=%%j
    )
)
set link_from_path=!USERPROFILE!\AppData\LocalLow\Nolla_Games_Noita
for /f "tokens=1,2*" %%i in ('fsutil reparsePoint query !link_from_path!') do (
    if %%i%%j==PrintName: (
        set old_link_to_path=%%k
    )
)
set current_path=!cd!
md !link_to_path! 2>NUL
cd /d !link_to_path!
set absolute_link_to_path=!cd!
if not !absolute_link_to_path!==!old_link_to_path! (
    echo 游戏存档未联接！
    set rename_path=!link_from_path!
    if !rename_path:~-1!==\ (
        set rename_path=!rename_path:~0,-1!
    )
    for %%i in (!rename_path!) do (
        set rename_from_directory=%%~ni
    )
    set rename_to_directory=!rename_from_directory!
    set count=0
    cd /d !rename_path!\..
    :loop
    if exist !rename_to_directory! (
        set rename_to_directory=!rename_from_directory!!count!
        set /a count+=1
        goto loop
    )
    ren !rename_path! !rename_to_directory! 2>NUL
    cd /d !current_path!
    mklink /j !link_from_path! !link_to_path! >NUL
    goto launch
) else (
    echo 游戏存档已联接！
)
:launch
cd /d !current_path!
for /d %%i in (!game_path!\mods\*) do (
	if exist %%i\mod_id.txt (
		for /f %%j in ('type %%i\mod_id.txt') do (
			ren %%i %%j
		)
	)
)
cd /d !game_path!
start noita.exe
endlocal