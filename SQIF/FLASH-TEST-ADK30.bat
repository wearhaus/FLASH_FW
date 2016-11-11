@echo off

:start

pause

"C:\ADK3.0\tools\bin\nvscmd" -usb 0 identify
if %ERRORLEVEL% == 0 (
	echo CONNECTED
) ELSE (
	echo FAIL
	msg /time:5 "%username%" NG or SPI
	goto fail
)




"C:\ADK3.0\tools\bin\nvscmd" -usb 0 erase
"C:\ADK3.0\tools\bin\nvscmd" -usb 0 burn sqif2.ptn all

if %ERRORLEVEL% == 0 (
	echo FLASH PASS
	msg /time:5 "%username%" FLASH OK
) ELSE (
	echo FLASH FAIL
	msg /time:5 "%username%" FLASH NG
	goto fail
)


echo.
echo.
echo.
echo.
echo.
echo.
echo ``@@@@@@@``@@````@@
echo `@@`````@@`@@```@@`
echo `@@`````@@`@@``@@``
echo `@@`````@@`@@@@@```
echo `@@`````@@`@@``@@``
echo `@@`````@@`@@```@@`
echo ``@@@@@@@``@@````@@
echo.

goto start

:fail

echo.
echo '@@''''@@''@@@@@@''
echo '@@@'''@@'@@''''@@'
echo '@@@@''@@'@@'''''''
echo '@@'@@'@@'@@'''@@@@
echo '@@''@@@@'@@''''@@'
echo '@@'''@@@'@@''''@@'
echo '@@''''@@''@@@@@@''

goto start
