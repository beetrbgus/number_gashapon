!define APP_NAME "Number Gashapon"
!define EXE_NAME "Gashapon.exe"
!define INSTALL_DIR "$PROGRAMFILES64\${APP_NAME}"

Outfile "${APP_NAME}_Setup.exe"
InstallDir "${INSTALL_DIR}"

Section
    SetOutPath "${INSTALL_DIR}"
    File /r "build\windows\runner\Release\*.*"
    CreateShortcut "$DESKTOP\${APP_NAME}.lnk" "${INSTALL_DIR}\${EXE_NAME}"
SectionEnd