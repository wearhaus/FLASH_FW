@echo off

:start

set atmel_path= "C:\Program Files\Atmel\Atmel Studio 6.2"
set csr_path= "C:\Program Files\CSR\BlueSuite 2.6.2"

pause

echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.

echo ******************** START **************************

::call %atmel_path%\atbackend\atprogram -t jtagice3 -i PDI -d ATXMEGA32E5 -cl 7500khz chiperase


echo. 
echo MTCH6301:

::call %atmel_path%\atbackend\atprogram -t jtagice3 -i PDI -d ATXMEGA32E5 -cl 7500khz program -ee --format hex -f "wear - MTCH_SET.eep"

::call %atmel_path%\atbackend\atprogram -t jtagice3 -i PDI -d ATXMEGA32E5 -cl 7500khz program -fl --format hex -f "wear - MTCH_SET_3.hex"


if %ERRORLEVEL% == 0 (
	echo MTCH6301 PASS
) ELSE (
	echo MTCH6301 FAIL

	goto fail
)



echo. 
echo FLASH:

::call %csr_path%\nvscmd -usb 0 erase
::call %csr_path%\nvscmd -usb 0 burn sqif2.ptn all

if %ERRORLEVEL% == 0 (
	echo FLASH PASS
) ELSE (
	echo FLASH FAIL

	goto fail
)



echo. 
echo CSR:

::call %csr_path%\BlueFlashCmd 20161108-dump--mictest


if %ERRORLEVEL% == 0 (
	echo CSR PASS
) ELSE (
	echo CSR FAIL
	
	goto fail
)

echo PRESS ANY KEY WHEN LEDS ARE FLASHING RAINBOW/GREEN. IF FLASHING RED, OPEN AND CLOSE TEST MACHINE.
pause

echo. 
echo ATMEL:

::call %atmel_path%\atbackend\atprogram -t jtagice3 -i PDI -d ATXMEGA32E5 -cl 7500khz chiperase
::call %atmel_path%\atbackend\atprogram -t jtagice3 -i PDI -d ATXMEGA32E5 -cl 7500khz program -ee --format hex -f "wear - MTCH_SET.eep"

::call %atmel_path%\atbackend\atprogram -t jtagice3 -i PDI -d ATXMEGA32E5 -cl 7500khz program -fl --format hex -f "wear20161112.hex"

::call %atmel_path%\atbackend\atprogram -t jtagice3 -i PDI -d ATXMEGA32E5 -cl 7500khz reset

if %ERRORLEVEL% == 0 (
	echo ATMEL PASS
) ELSE (
	echo ATMEL FAIL
	
	goto fail
)




echo. 
echo ADDRESS:

set byte01=1cf0
set byte2=003e
set byte3=0010

for /f "tokens=* delims=" %%x in (decaddr.txt) do (
 set /a dec=%%x+1
)

call tohex %dec% byte45

set wearhausarc=6557 7261 6168 7375 4120 6372
set words=%byte3% %byte45% 
set words= %words:~2,5% %words:~7%

call charlib str2hex words hexwords
set hexwords=%hexwords:~2,2%%hexwords:~0,2% %hexwords:~6,2%%hexwords:~4,2% %hexwords:~10,2%%hexwords:~8,2% %hexwords:~14,2%%hexwords:~12,2% %hexwords:~18,2%%hexwords:~16,2%

>decaddr.txt echo %dec%

>setaddr.psr echo ^&0001 = %byte3% %byte45% %byte2% %byte01%

>setname.psr echo ^&0108 = %wearhausarc% %hexwords%

::call %csr_path%\pscli -usb 0 merge setaddr.psr
::call %csr_path%\pscli -usb 0 merge setname.psr
::call %csr_path%\pscli -usb 0 merge setdefaulttricolor.psr
::call %csr_path%\pscli -usb 0 warm_reset

echo .
echo ADDRESS: %byte01% %byte2% %byte3% %byte45%
echo .

if %ERRORLEVEL% == 0 (
	echo ADDR PASS
) ELSE (
	echo ADDR FAIL

	goto fail
)



:success

echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo `##########```##``````##`
echo `##``````##```##````##```
echo `##``````##```##``##`````
echo `##``````##```####```````
echo `##``````##```##``##`````
echo `##``````##```##````##```
echo `##########```##``````##`
echo.

goto start


:fail

::echo `##``````##```##########`
::echo `####````##```##`````````
::echo `##`##```##```##`````````
::echo `##``##``##```##````####`
::echo `##```##`##```##``````##`
::echo `##````####```##``````##`
::echo `##``````##```##########`
echo `##########````###``````##```##`````````
echo `##```````````##`##`````##```##`````````
echo `##``````````##```##````##```##`````````
echo `#########``##`````##```##```##`````````
echo `##`````````#########```##```##`````````
echo `##`````````##`````##```##```##`````````
echo `##`````````##`````##```##```##########`
echo.

goto start
