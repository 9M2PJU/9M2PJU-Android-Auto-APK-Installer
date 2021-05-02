@echo off
cls

SET adbv=adb\adb.exe
forfiles /P apk /S /M *.apk /c "cmd /c echo @path  & ..\%adbv% push @FILE /data/local/tmp/@FILE & ..\%adbv% shell pm install -i 'com.android.vending' -r /data/local/tmp/@FILE & ..\%adbv% shell rm /data/local/tmp/@FILE"

echo "inceptive.ru"

choice /c YN /m "Patch screen2auto - Confirmation of MediaProjection?"
goto run%errorlevel%
:run1
%adbv% -d shell cmd appops set ru.inceptive.screentwoauto PROJECT_MEDIA allow
%adbv% -d shell cmd appops set ru.inceptive.screentwoauto WRITE_SETTINGS allow
%adbv% -d shell cmd appops set ru.inceptive.screentwoauto SYSTEM_ALERT_WINDOW allow
%adbv% -d shell cmd appops set ru.inceptive.screentwoauto RUN_IN_BACKGROUND allow
%adbv% -d shell cmd appops set ru.inceptive.screentwoauto WAKE_LOCK allow
%adbv% shell am force-stop ru.inceptive.screentwoauto
:run2
echo Thanks a lot for using&pause&exit /b


@pause