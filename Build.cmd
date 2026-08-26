@echo off

set "ROOT=%~dp0"
set "SKSE_BUILD_ROOT=%ROOT%build"
set "COMMON_SOURCE=%SKSE_BUILD_ROOT%\common"
set "SKSE_SOURCE=%SKSE_BUILD_ROOT%\skse64"
set "SKSE_COMMON_BUILD=%COMMON_SOURCE%\build"
set "SKSE_BUILD=%SKSE_SOURCE%\build"
set "SKSE_EXTERNAL=%SKSE_BUILD_ROOT%\extern"
set "SKSE64Path=%SKSE_BUILD_ROOT%\skse64-sdk"

if not exist "%COMMON_SOURCE%\.git" git clone https://github.com/ianpatt/common "%COMMON_SOURCE%" || goto :error
if not exist "%SKSE_SOURCE%\.git" git clone https://github.com/ianpatt/skse64 "%SKSE_SOURCE%" || goto :error

cmake -B "%SKSE_COMMON_BUILD%" -S "%COMMON_SOURCE%" -G "Visual Studio 17 2022" -A x64 -DCMAKE_INSTALL_PREFIX="%SKSE_EXTERNAL%" || goto :error
cmake --build "%SKSE_COMMON_BUILD%" --config Release --target install || goto :error
cmake -B "%SKSE_BUILD%" -S "%SKSE_SOURCE%" -G "Visual Studio 17 2022" -A x64 -DCMAKE_PREFIX_PATH="%SKSE_EXTERNAL%" -DCMAKE_INSTALL_PREFIX="%SKSE_EXTERNAL%" || goto :error
cmake --build "%SKSE_BUILD%" --config Release || goto :error

powershell -NoProfile -ExecutionPolicy Bypass -File "%ROOT%scripts\prepare_skse_sdk.ps1" -Source "%SKSE_SOURCE%" -Destination "%SKSE64Path%" || goto :error

md "%ROOT%package\Fomod"
md "%ROOT%package\SDK"

pushd "%ROOT%"
cmake --preset vs2022-windows -Wno-deprecated || goto :error
cmake --build build --config Release || goto :error
cmake --install build --component "SKSEPlugin" --prefix "package/Fomod/SkyrimSE" || goto :error

cmake --preset vs2022-windows-vr -Wno-deprecated || goto :error
cmake --build buildVR --target "MCMHelper" --config Release || goto :error
cmake --install buildVR --component "SKSEPlugin" --prefix "package/Fomod/SkyrimVR" || goto :error

cmake --install build --component "Fomod" --prefix "package/Fomod" || goto :error
cmake --install build --component "ESP" --prefix "package/Fomod/ESP" || goto :error
cmake --install build --component "ESL" --prefix "package/Fomod/ESL" || goto :error
cmake --install build --component "BSA" --prefix "package/Fomod/BSA" || goto :error
cmake --install build --component "Loose" --prefix "package/Fomod/Loose" || goto :error
cmake --install build --component "Data" --prefix "package/Fomod/Data" || goto :error
cmake --install build --component "SDK" --prefix "package/SDK" || goto :error

powershell -NoProfile -Command "Compress-Archive -Path '%ROOT%package\Fomod\*' -DestinationPath '%ROOT%package\MCM.Helper.zip' -Force" || goto :error
powershell -NoProfile -Command "Compress-Archive -Path '%ROOT%package\SDK\*' -DestinationPath '%ROOT%package\MCM.SDK.zip' -Force" || goto :error

popd
goto :EOF

:error
exit /b %errorlevel%
