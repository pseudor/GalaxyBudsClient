; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines

!ifndef PRODUCT_VERSION
!warning "VERSION not defined!"
!define PRODUCT_VERSION "0.0.0.0"
!endif

!ifndef PRODUCT_ARCH
!warning "ARCH not defined!"
!define PRODUCT_ARCH "unknown"
!endif

!ifndef BASE_DIR
!warning "BASE_DIR not defined!"
!define BASE_DIR "."
!endif

!define PRODUCT_NAME "Galaxy Buds Manager (Unofficial)"
!define PRODUCT_PUBLISHER "ThePBone"
!define PRODUCT_WEB_SITE "https://github.com/ThePBone/GalaxyBudsClient"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\Galaxy Buds Client.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!define MUI_LICENSEPAGE_CHECKBOX
!insertmacro MUI_PAGE_LICENSE "LICENSE"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_RUN "$INSTDIR\Galaxy Buds Client.exe"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "GalaxyBudsManager_Setup_${PRODUCT_ARCH}_${PRODUCT_VERSION}.exe"
InstallDir "$PROGRAMFILES\Galaxy Buds Manager"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Section "Hauptgruppe" SEC01
  ExecWait "taskkill /f /t /im $\"Galaxy Buds Client.exe$\""
  
  SetOutPath "$INSTDIR"
  SetOverwrite on
  File "$BASE_DIR\Galaxy Buds Client.exe"
  CreateDirectory "$SMPROGRAMS\Galaxy Buds Manager"
  CreateShortCut "$SMPROGRAMS\Galaxy Buds Manager\Galaxy Buds Manager.lnk" "$INSTDIR\Galaxy Buds Client.exe"
  CreateShortCut "$DESKTOP\Galaxy Buds Manager.lnk" "$INSTDIR\Galaxy Buds Client.exe"
SectionEnd

Section -AdditionalIcons
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\Galaxy Buds Client.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name) (${PRODUCT_ARCH})"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\Galaxy Buds Client.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) has been successfully uninstalled."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Do you want to uninstall $(^Name) and all its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  ExecWait "taskkill /f /t /im $\"Galaxy Buds Client.exe$\""

  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"

  Delete "$INSTDIR\Galaxy Buds Client.exe"

  Delete "$DESKTOP\Galaxy Buds Manager.lnk"
  Delete "$SMPROGRAMS\Galaxy Buds Manager\Galaxy Buds Manager.lnk"

  RMDir "$SMPROGRAMS\Galaxy Buds Manager"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd
