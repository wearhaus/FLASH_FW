@echo off
setlocal EnableDelayedExpansion

::get the current address.
::================================================================================
:getAddress
cls
setlocal EnableDelayedExpansion
set /a count=1
for /f %%i in (addr.ini) do (
if !count! EQU 1 set curraddr=%%i
if !count! EQU 2 set maxaddr=%%i
set /a count+=1
)
echo ******************** START **************************************
echo the current address is %curraddr%
echo the max address is %maxaddr%
echo *****************************************************************
set backcurraddr=%curraddr:~2,6%
set backmaxaddr=%maxaddr:~2,6%

if %curraddr% GEQ %maxaddr% (
cls
echo *****************************************************************
echo                 ERROR                                            
echo The address is used up,please change the address settings!
echo current address is %curraddr%
echo the max address is %maxaddr%
echo *****************************************************************
pause
goto getAddress
)
echo Are you sure to start download?
pause


::start set envirment path
::::===========================================================================================
set csr_path= "C:\Program Files (x86)\CSR\BlueSuite 2.6.2"

::set csr_path= "C:\Program Files\CSR\BlueSuite 2.6.2"


::Test flash
::==========================================================================================
echo Test flash...

call %csr_path%\nvscmd -usb 0 erase
call %csr_path%\nvscmd -usb 0 burn sqif2.ptn all

if %ERRORLEVEL% == 0 (
	echo FLASH PASS
) ELSE (
	echo FLASH FAIL
::	msg /time:5 "%username%" B
	goto fail
)


::Download CSR firmware and PS key.
::==========================================================================================
echo Download CSR firmware...
call %csr_path%\BlueFlashCmd 20180312-dump

if %ERRORLEVEL% == 0 (
	echo CSR PASS
) ELSE (
	echo CSR FAIL
::	msg /time:5 "%username%" 失败
	goto fail
)

::Mic test.
::--------------------------------------

echo 开始麦克测试，检查耳机里是否能听到麦克风传来的声音？
echo 按任意键继续
pause

::Download ps key.
::--------------------------------------
set words=%curraddr:~2,2% %curraddr:~4,2% %curraddr:~6,2% 
call charlib str2hex words hexwords
::set hexwords=%hexwords:~2,2%%hexwords:~0,2% %hexwords:~6,2%%hexwords:~4,2% %hexwords:~10,2%%hexwords:~8,2% %hexwords:~14,2%%hexwords:~12,2% %hexwords:~18,2%%hexwords:~16,2%
set hexwords=%hexwords:~2,2%%hexwords:~0,2% %hexwords:~6,2%%hexwords:~4,2% %hexwords:~10,2%%hexwords:~8,2% %hexwords:~14,2%%hexwords:~12,2% %hexwords:~18,2%%hexwords:~16,2%

echo Update bluetooth address... 1CF0 3E %backcurraddr% 
set wearhausbeam=6557 7261 6168 7375 4220 6165 206d
>setaddr.psr echo ^&0001 = 00%curraddr:~2,2% %curraddr:~4,4% 003e 1cf0
>setname.psr echo ^&0108 = %wearhausbeam% %hexwords%

call %csr_path%\pscli -usb 0 merge setaddr.psr
call %csr_path%\pscli -usb 0 merge setname.psr
::call %csr_path%\pscli -usb 0 merge AfterMicTestUpdate.psr
call %csr_path%\pscli -usb 0 warm_reset

if %ERRORLEVEL% == 0 (
	echo ADDR PASS
) ELSE (
	echo ADDR FAIL
::	msg /time:5 "%username%" 失败
	goto fail
)


::write a log.
::==========================================================================================
echo 1CF0 3E %backcurraddr%    -- %time% --%date%. >> addr.log

::update address settings.
::==========================================================================================
set /a curraddr+=1
set str=
set code=0123456789ABCDEF
set var=%curraddr%
set /a pos=6
:again2
set /a tra=%var%%%16
call,set tra=%%code:~%tra%,1%%
if %var% geq 1 goto setdata2
set str=0%str%
goto continue2
:setdata2
set str=%tra%%str%
:continue2
set /a var/=16
set /a pos-=1
if %pos% geq 1 goto again2

rem echo current address is 0x%str% 
echo back current address is %backcurraddr%
echo back max address is %backmaxaddr%

echo 0x%str%  >  addr.ini
echo 0x%backmaxaddr% >> addr.ini

::Display status
::===========================================================================================
:success
echo         
echo           ################################
echo           #                              #
echo           #         Download OK          #
echo           #          下载 OK             #
echo           #                              # 
echo           ################################
echo         
pause

goto getAddress

:fail
echo         
echo           #################################
echo           #                               #
echo           #         Download Fail         #
echo           #          下载 NG              #
echo           #                               # 
echo           #################################
echo         
pause

goto getAddress
