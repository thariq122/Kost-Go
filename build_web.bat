@echo off
echo ==============================
echo  Build dan Deploy Flutter Web
echo ==============================
echo.

echo [1/2] Building Flutter Web...
call flutter build web --base-href "/kostgo_app/"
if %errorlevel% neq 0 (
    echo BUILD GAGAL!
    pause
    exit /b 1
)

echo.
echo [2/2] Copy ke XAMPP htdocs...
if exist "C:\xampp\htdocs\kostgo_app" (
    rmdir /s /q "C:\xampp\htdocs\kostgo_app"
)
xcopy /e /i /q "build\web" "C:\xampp\htdocs\kostgo_app"

echo.
echo ==============================
echo  SELESAI!
echo  Buka: http://localhost/kostgo_app/
echo ==============================
pause
