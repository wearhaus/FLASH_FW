
@echo off

:start

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

"C:\Program Files (x86)\Atmel\Studio\7.0\atbackend\atprogram" -t atmelice -i PDI -d ATXMEGA32E5 -cl 7500khz chiperase


echo. 
echo MTCH6301:

"C:\Program Files (x86)\Atmel\Studio\7.0\atbackend\atprogram" -t atmelice -i PDI -d ATXMEGA32E5 -cl 7500khz program -ee --format hex -f "wear - MTCH_SET.eep"

"C:\Program Files (x86)\Atmel\Studio\7.0\atbackend\atprogram" -t atmelice -i PDI -d ATXMEGA32E5 -cl 7500khz program -fl --format hex -f "wear - MTCH_SET.elf"

if %ERRORLEVEL% == 0 (
	echo MTCH6301 PASS
) ELSE (
	echo MTCH6301 FAIL
	msg /time:5 "%username%" B
	goto fail
)



echo. 
echo FLASH:

"C:\ADK3.5\tools\bin\nvscmd" -usb 0 erase
"C:\ADK3.5\tools\bin\nvscmd" -usb 0 burn sqif2.ptn all

if %ERRORLEVEL% == 0 (
	echo FLASH PASS
) ELSE (
	echo FLASH FAIL
	msg /time:5 "%username%" B
	goto fail
)



echo. 
echo CSR:

C:\ADK3.5\tools\bin\BlueFlashCmd dump-NELSON


if %ERRORLEVEL% == 0 (
	echo CSR PASS
) ELSE (
	echo CSR FAIL
	msg /time:5 "%username%" B
	goto fail
)



echo. 
echo ATMEL:

"C:\Program Files (x86)\Atmel\Studio\7.0\atbackend\atprogram" -t atmelice -i PDI -d ATXMEGA32E5 -cl 7500khz program -ee --format hex -f "wear - MTCH_SET.eep"

"C:\Program Files (x86)\Atmel\Studio\7.0\atbackend\atprogram" -t atmelice -i PDI -d ATXMEGA32E5 -cl 7500khz program -fl --format hex -f "wear - 11-11-2016.elf"

"C:\Program Files (x86)\Atmel\Studio\7.0\atbackend\atprogram" -t atmelice -i PDI -d ATXMEGA32E5 -cl 7500khz reset

if %ERRORLEVEL% == 0 (
	echo ATMEL PASS
) ELSE (
	echo ATMEL FAIL
	msg /time:5 "%username%" B
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

C:\ADK3.5\tools\bin\pscli -usb 0 merge setaddr.psr
C:\ADK3.5\tools\bin\pscli -usb 0 merge setname.psr
C:\ADK3.5\tools\bin\pscli -usb 0 merge setdefaulttricolor.psr
C:\ADK3.5\tools\bin\pscli -usb 0 warm_reset

echo .
echo ADDRESS: %byte01% %byte2% %byte3% %byte45%
echo .

if %ERRORLEVEL% == 0 (
	echo ADDR PASS
) ELSE (
	echo ADDR FAIL
	msg /time:5 "%username%" B
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
echo ````###````
echo ```##`##```
echo ``##```##``
echo `##`````##`
echo `#########`
echo `##`````##`
echo `##`````##`
echo.

msg /time:5 "%username%" A

goto start


:fail

echo `########``
echo `##`````##`
echo `##`````##`
echo `########``
echo `##`````##`
echo `##`````##`
echo `########``

goto start
