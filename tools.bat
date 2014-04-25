@echo off
color 1f
mode con cols=58 lines=30
title MTK BOOT/RECOVERY 解包/打包工具
:CHO
cls
@echo ********************************************************
@echo.
@echo               MTK BOOT/RECOVERY 解包/打包工具
@echo.
@echo.                                               by suda
@echo ********************************************************
echo --------------------------------------------------------
echo 请将boot.img/recovery.img置于此文件夹
echo 选择相应选项操作
echo 打包后将生成boot-new.img/recovery-new.img
echo 工具不支持中文路径
echo --------------------------------------------------------
echo.  [选择序号进行操作]
echo --------------------------------------------------------
echo   1.解包boot
echo   2.打包boot
echo   3.解包recovery		
echo   4.打包recovery			
echo   0.退出程序
echo. 
echo --------------------------------------------------------
echo.                            %date% %time%
set choice=
set /p choice= 选择[0-4]操作:
IF NOT "%choice%"=="" SET choice=%choice:~0,2%
if /i "%choice%"=="0" EXIT
if /i "%choice%"=="1" goto unpack_boot
if /i "%choice%"=="2" goto repack_boot
if /i "%choice%"=="3" goto unpack_recovery
if /i "%choice%"=="4" goto repack_recovery
echo 选择无效，请重新输入
ping 127.0.0.1 -n 2 >NUL
echo.
goto CHO

:unpack_boot
if not exist boot.img (echo.
echo 未发现boot.img文件夹,即将返回主菜单
ping 127.0.0.1 -n 2 >NUL
goto CHO
) 
if exist boot (rd /s /q boot)
echo 正在解包boot.img......
md boot
copy boot.img boot>NUL
cd boot
..\tools\bootimg.exe --unpack-bootimg
del boot-old.img
del boot.img 
cd ..
goto CHO

:repack_boot
if not exist boot (echo.
echo 未发现boot文件夹,即将返回主菜单
ping 127.0.0.1 -n 2 >NUL
goto CHO
) else echo.
echo 正在打包boot.img......
xcopy  /e/I/h/r/y/s "boot" "boot_bak">NUL
cd boot
..\tools\bootimg.exe --repack-bootimg
cd ..
move boot\boot-new.img .>NUL
rd /s /q boot
ren boot_bak boot
goto CHO

:unpack_recovery
if not exist recovery.img (echo.
echo 未发现recovery.img文件夹,即将返回主菜单
ping 127.0.0.1 -n 2 >NUL
goto CHO
) 
if exist recovery (rd /s /q recovery)
echo 正在解包recovery.img......
md recovery
copy recovery.img recovery\boot.img>NUL
cd recovery
..\tools\bootimg.exe --unpack-bootimg
del boot-old.img
del boot.img
cd ..
goto CHO

:repack_recovery
if not exist recovery (echo.
echo 未发现recovery文件夹,即将返回主菜单
ping 127.0.0.1 -n 2 >NUL
goto CHO
) else echo.
echo 正在打包recovery.img......
xcopy  /e/I/h/r/y/s "recovery" "recovery_bak">NUL
cd recovery
..\tools\bootimg.exe --repack-bootimg
cd ..
move recovery\boot-new.img .\recovery-new.img>NUL
rd /s /q recovery
ren recovery_bak recovery
goto CHO