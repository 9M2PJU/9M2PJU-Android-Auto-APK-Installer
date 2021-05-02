@echo off
cls
SET adb="..\adb\adb.exe"
forfiles /P apk /S /M *.apk /c "cmd /c echo @path  & %adb% push @FILE /data/local/tmp/s2a.apk & %adb% shell pm install -i 'com.android.vending' -r /data/local/tmp/s2a.apk & %adb% shell rm /data/local/tmp/s2a.apk "

echo "inceptive.ru"

choice /c YN /m "Patch screen2auto - Confirmation of MediaProjection?"
goto run%errorlevel%
:run1
adb shell cmd appops set ru.inceptive.screentwoauto PROJECT_MEDIA allow
:run2
echo Thanks a lot for using&pause&exit /b


@pause