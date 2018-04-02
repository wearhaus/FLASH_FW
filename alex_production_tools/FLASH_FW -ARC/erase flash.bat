@echo off

:start

set atmel_path= "C:\Program Files (x86)\Atmel\Studio\7.0"
set csr_path= "C:\Program Files (x86)\CSR\BlueSuite 2.6.2"
pause


echo. 
echo FLASH:

call %csr_path%\nvscmd -usb 0 erase
call %csr_path%\nvscmd -usb 0 burn sqif2.ptn all

if %ERRORLEVEL% == 0 (
	echo FLASH PASS
) ELSE (
	echo FLASH FAIL

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
