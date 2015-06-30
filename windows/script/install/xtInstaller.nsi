;--------------------------------
; xtclient Setup NSIS Script
; @author zoubailiu
; @date   2012-5-7
;
; �÷���
; makensis.exe [/DSERVER_BINS] [/DBIN_SUBDIR=Standalone_Release] [/DPRODUCT_NAME_CN=ѸͶ�����ն�] [/DPRODUCT_NAME_EN=XtTradeClient] [/DPRODUCT_VERSION=x.x.x.xxxx] [/DORIGINAL_FILENAME=xxx.exe] [/DOUTFILE=c:\xxx.exe] xxx.nsi
;

!include "LogicLib.nsh"

; ��װ�����ʼ���峣��

!ifndef PRODUCT_NAME_CN
    !define PRODUCT_NAME_CN "ѸͶ�ʲ�����ƽ̨�ն�"
!endif

!ifndef BIN_SUBDIR
    !define BIN_SUBDIR "Deploy_Release"
!endif

!ifndef PRODUCT_NAME_EN
    !define PRODUCT_NAME_EN "XtAmpTradeClient"
!endif

!ifndef PRODUCT_VERSION
    !define PRODUCT_VERSION "1.0.0.0000"
!endif

!ifndef OUTFILE
    !define OUTFILE "xtClientSetup_${PRODUCT_VERSION}.exe"
!endif

!ifndef ORIGINAL_FILENAME
    !define ORIGINAL_FILENAME "${OUTFILE}"
!endif

!define PRODUCT_MAIN_EXE "${PRODUCT_NAME_EN}.exe"
!define PRODUCT_PUBLISHER "��������ڿƿع����޹�˾"
!define PRODUCT_COPYRIGHT "Copyright (C) 2012 Beijing RaiseTech Holding Ltd Company"
!define PRODUCT_WEB_SITE "http://www.thinktrader.net"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${PRODUCT_MAIN_EXE}"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME_CN}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_REASOURCE_DIR "installerResource"
!define PRODUCT_INSTALLER_NAME "${PRODUCT_NAME_CN} ��װ����"

SetCompressor lzma

; ------ MUI �ִ����涨�� (1.67 �汾���ϼ���) ------
!include "MUI.nsh"

; MUI Ԥ���峣��
!define MUI_ABORTWARNING
!define MUI_ICON "${PRODUCT_REASOURCE_DIR}\Setup.ico"
!define MUI_UNICON "${PRODUCT_REASOURCE_DIR}\uninst.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "${PRODUCT_REASOURCE_DIR}\welcome.bmp"

; ��ӭҳ��
!insertmacro MUI_PAGE_WELCOME
; ���Э��ҳ��
!define MUI_LICENSEPAGE_CHECKBOX
!insertmacro MUI_PAGE_LICENSE "${PRODUCT_REASOURCE_DIR}\license.txt"
; ��װĿ¼ѡ��ҳ��
!insertmacro MUI_PAGE_DIRECTORY
; ��װ����ҳ��
!insertmacro MUI_PAGE_INSTFILES
; ��װ���ҳ��
Page custom PageOtherTask
!define MUI_FINISHPAGE_RUN "$INSTDIR\bin\${PRODUCT_MAIN_EXE}"
!define MUI_FINISHPAGE_RUN_TEXT "���� ${PRODUCT_NAME_CN}"
!insertmacro MUI_PAGE_FINISH

; ��װж�ع���ҳ��
!insertmacro MUI_UNPAGE_INSTFILES

; ��װ�����������������
!insertmacro MUI_LANGUAGE "SimpChinese"

; ��װԤ�ͷ��ļ�
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI �ִ����涨����� ------

Name "${PRODUCT_NAME_CN} ${PRODUCT_VERSION}"
OutFile "${OUTFILE}"

; InstallDir "$PROGRAMFILES\${PRODUCT_NAME_CN}"
InstallDir "D:\${PRODUCT_NAME_CN}"

InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails show
ShowUnInstDetails show
BrandingText "${PRODUCT_NAME_CN}"


VIProductVersion "${PRODUCT_VERSION}"
VIAddVersionKey FileDescription "${PRODUCT_INSTALLER_NAME}"
VIAddVersionKey FileVersion "${PRODUCT_VERSION}"
; VIAddVersionKey ProductName "${PRODUCT_NAME_CN} ${PRODUCT_VERSION}" ;��Ʒ����
VIAddVersionKey ProductName "${PRODUCT_NAME_CN}"
VIAddVersionKey ProductVersion "${PRODUCT_VERSION}"
VIAddVersionKey Comments "${PRODUCT_INSTALLER_NAME}"
VIAddVersionKey CompanyName "${PRODUCT_PUBLISHER}"
VIAddVersionKey LegalCopyright "${PRODUCT_COPYRIGHT}"
VIAddVersionKey InternalName "${PRODUCT_INSTALLER_NAME}"
; VIAddVersionKey LegalTrademarks "${PRODUCT_PUBLISHER}" ;�Ϸ��̱� ;
VIAddVersionKey OriginalFilename "${ORIGINAL_FILENAME}"
; VIAddVersionKey PrivateBuild "XX" ;�����ڲ��汾˵��
; VIAddVersionKey SpecialBuild "XX" ;�����ڲ�����˵�� 


RequestExecutionLevel admin

; ��"un."��Ϊ�������룬��ǿʵ�ְ�װ��ж�ع��ú�������
; ʵ��������һ���궨����������

!macro DefFunc_CheckProcess un
Function ${un}CheckProcess
    Pop $0  ; module name
    Pop $1  ; exe name
    FindProcDLL::FindProc "$1"
    Pop $R0
    IntCmp $R0 0 not_found  ; ���FindProc���Ϊ0����ʾδ�ҵ����򣬷������
    MessageBox MB_ICONSTOP "��װ�����⵽ ${PRODUCT_NAME_CN} $0 �������У����˳��˳�������ԡ�" IDYES +2
    Quit
not_found:
FunctionEnd
!macroend

!macro DefFunc_KillProcess un
Function ${un}KillProcess
    Pop $0  ; module name
    Pop $1  ; exe name
    FindProcDLL::FindProc "$1"
    Pop $R0
    IntCmp $R0 0 no_more  ; ���FindProc���Ϊ0����ʾδ�ҵ����򣬷������
    MessageBox MB_ICONQUESTION|MB_YESNO "��װ�����⵽ ${PRODUCT_NAME_CN} $0 �������У��Ƿ���ֹ�˳���" IDYES try_kill
    MessageBox MB_ICONSTOP "${PRODUCT_NAME_CN} $0 �������У����˳��˳��������"
    Quit
try_kill:
    Push $1
    Push $0
    call ${un}ForceKillProcess  ; ��������
no_more:
FunctionEnd
!macroend

!macro DefFunc_ForceKillProcess un
Function ${un}ForceKillProcess
    Pop $0  ; module name
    Pop $1  ; exe name
try_kill_one:
    KillProcDLL::KillProc "$1"
    Pop $R0
    IntCmp $R0 0 try_kill_one       ; ����0��ʾɱ���̳ɹ�����Ӧ����ɱ�˽���������������
    IntCmp $R0 602 check_no_more    ; ����602��ʾ��Ϊ����ԭ��ɱ����ʧ�ܣ���ʵ���Ϸ�����ʱ����ʵ��ɱ�ɹ��˵ģ���C�̸�Ŀ¼�������ʹܵ�daemon�ٰ�װ������������Ҫ��һ�����
    IntCmp $R0 603 check_no_more    ; ����603��ʾû�ҵ��˽��̣������������a) ȷʵû�д˽��� b) ��Ȩ�޵�ԭ���޷����ʴ˽��̣������2�֣�Ӧ��Ϊɱ����ʧ�ܣ�������Ҫ��һ�����
    MessageBox MB_ICONSTOP "�޷���ֹ $0 ($1) (code=$R0)�����ֶ���ֹ�˳��������"   ; KillProc����ֵ��0��603
    Quit
check_no_more:
    FindProcDLL::FindProc "$1"
    Pop $R0
    IntCmp $R0 1 try_kill_one  ; ���FindProc���Ϊ1����ʾ�ҵ��˳���˵�����н��̴��ڣ�����ɱ
FunctionEnd
!macroend

!macro DefFunc_StartupCheck un
Function ${un}StartupCheck
    IfSilent force_kill

        Push "${PRODUCT_MAIN_EXE}"
        Push "����������"
        call ${un}CheckProcess

!ifndef SERVER_BINS
        ;Push "XtAmpBrowser.exe"
        ;Push "�Ż�������"
        ;call ${un}CheckProcess
!endif

        Push "XtQuoter.exe"
        Push "����������"
        call ${un}KillProcess

        Push "XtDaemon.exe"
        Push "�����س���"
        call ${un}KillProcess
    !ifdef SERVER_BINS
        Push "XtTraderService.exe"
        Push "���׷������"
        call ${un}KillProcess

        Push "XtService.exe"
        Push "���Է������"
        call ${un}KillProcess

        Push "XtBroker.exe"
        Push "���׺�̨����"
        call ${un}KillProcess

        Push "XtRiskControl.exe"
        Push "���׷�س���"
        call ${un}KillProcess
    !endif
        
        Push "crashui.exe"
        Push "����������"
        call ${un}ForceKillProcess

    goto cont

    force_kill:

        Push "${PRODUCT_MAIN_EXE}"
        Push "����������"
        call ${un}ForceKillProcess

!ifndef SERVER_BINS
        ;Push "XtAmpBrowser.exe"
        ;Push "�Ż�������"
        ;call ${un}ForceKillProcess
!endif

        Push "XtQuoter.exe"
        Push "����������"
        call ${un}ForceKillProcess

        Push "XtDaemon.exe"
        Push "�����س���"
        call ${un}ForceKillProcess
    !ifdef SERVER_BINS
        Push "XtTraderService.exe"
        Push "���׷������"
        call ${un}ForceKillProcess

        Push "XtService.exe"
        Push "���Է������"
        call ${un}ForceKillProcess

        Push "XtBroker.exe"
        Push "���׺�̨����"
        call ${un}ForceKillProcess
        
        Push "XtRiskControl.exe"
        Push "���׷�س���"
        call ${un}ForceKillProcess        

        Push "crashui.exe"
        Push "����������"
        call ${un}ForceKillProcess

    !endif

    cont:
FunctionEnd
!macroend

Section "MainSection" SEC01

    Delete "$DESKTOP\${PRODUCT_NAME_CN}.lnk"
    Delete "$INSTDIR\${PRODUCT_NAME_CN}.url"
    RMDir /r "$INSTDIR\bin"
    RMDir /r "$SMPROGRAMS\${PRODUCT_NAME_CN}"

    SetOutPath "$INSTDIR\bin"
    SetOverwrite on

!ifdef SERVER_BINS
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\XtTraderService.exe"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\XtService.exe"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\XtBroker.exe"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\XtRiskControl.exe"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\sfit.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\kingdom.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\CJStock.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\rzrkfutures.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\rzrkstock.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\CiticStock.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\qiluSecurities.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\cert.txt"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\cjcom.ini"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\arcom.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\libmysql.dll"
!endif

    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\HsFutuSDK.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\t2sdk.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\thosttraderapi.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\thostmduserapi.dll"

    ;V8T����dll
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\cpack.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\KSInterB2C.lkc"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\KSMarketDataAPI.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\ksPortalAPI.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\KSTradeAPI.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\lkcdll.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\SSPXEncode.dll"

    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\XtDaemon.exe"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\XtQuoter.exe"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\XtUpdate.exe"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\datasource.dll"

    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\log4cxx.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\lua51.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\ssleay32.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\libeay32.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\core.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\zookeeper.dll"

    ;VC����ʱ
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\msvcm90.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\msvcp90.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\msvcr90.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\Microsoft.VC90.CRT.manifest"

    ;QT��̬��
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\QtCore4.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\QtGui4.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\QtXml4.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\QtWebKit4.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\QtNetwork4.dll"

    ;server5 base dll
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\net.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\persist.dll"

    ;xtclient����
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\${PRODUCT_MAIN_EXE}"
!ifndef SERVER_BINS
    ;File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\XtAmpBrowser.exe"
!endif
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\crash.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\crashui.exe"
    
    ;�û�Э���ļ�
    SetOutPath "$INSTDIR\agreement"
    SetOverwrite on
    File /r "..\..\_runtime\agreement\*.*"
    
    ;��Դ�ļ�
    SetOutPath "$INSTDIR\resource"
    SetOverwrite on
    File /r "..\..\_runtime\resource\*.*"

    ;���
    ;ͼƬ���
    SetOutPath "$INSTDIR\plugins\imageformats"
    SetOverwrite on
    File "..\..\_runtime\plugins\imageformats\qgif4.dll"
    File "..\..\_runtime\plugins\imageformats\qico4.dll"
    File "..\..\_runtime\plugins\imageformats\qjpeg4.dll"
    File "..\..\_runtime\plugins\imageformats\qmng4.dll"
    File "..\..\_runtime\plugins\imageformats\qsvg4.dll"
    File "..\..\_runtime\plugins\imageformats\qtga4.dll"
    File "..\..\_runtime\plugins\imageformats\qtiff4.dll"
    
    ;�ؼ�����
    SetOutPath "$INSTDIR\translations"
    SetOverwrite on
    File /r "..\..\_runtime\translations\*.*"

    ;����
    SetOutPath "$INSTDIR\config"
    SetOverwrite on
    File /r "..\..\_runtime\config.pack\${BIN_SUBDIR}\*.*"

    ;lua�ű�
    SetOutPath "$INSTDIR\luaScripts"
    SetOverwrite on
    File /r "..\..\_runtime\luaScripts\*.*"
    
    ;��������
    SetOutPath "$INSTDIR\config_local"
    SetOverwrite on
    File /r "..\..\_runtime\config_local\customer.lua"

    CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME_CN}"
    CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME_CN}\����${PRODUCT_NAME_CN}.lnk" "$INSTDIR\bin\${PRODUCT_MAIN_EXE}"
!ifndef SERVER_BINS
    ;CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME_CN}\����ѸͶ�ʲ�����ƽ̨�Ż�.lnk" "$INSTDIR\bin\XtAmpBrowser.exe"
!endif
  
SectionEnd

Section -AdditionalIcons
    SetOutPath $INSTDIR\bin
    SetOverwrite on
    WriteIniStr "$INSTDIR\${PRODUCT_NAME_CN}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
    CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME_CN}\�ٷ���ҳ.lnk" "$INSTDIR\${PRODUCT_NAME_CN}.url"
    CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME_CN}\ж��${PRODUCT_NAME_CN}.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
    WriteUninstaller "$INSTDIR\uninst.exe"
    WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\bin\${PRODUCT_MAIN_EXE}"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\bin\${PRODUCT_MAIN_EXE}"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

/******************************
 *  �����ǰ�װ�����ж�ز���  *
 ******************************/

Section Uninstall
    Delete "$DESKTOP\${PRODUCT_NAME_CN}.lnk"
    Delete "$INSTDIR\${PRODUCT_NAME_CN}.url"
    Delete "$SMSTARTUP\${PRODUCT_NAME_CN}.lnk"
!ifndef SERVER_BINS
    ;Delete "$DESKTOP\ѸͶ�ʲ�����ƽ̨�Ż�.lnk"
!endif
    RMDir /r "$SMPROGRAMS\${PRODUCT_NAME_CN}"

    DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
    DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"

    DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "${PRODUCT_NAME_EN}"

    RMDir /r "$INSTDIR\bin"
    RMDir /r "$INSTDIR\resource"
    RMDir /r "$INSTDIR\config"
    RMDir /r "$INSTDIR\configurations"
    RMDir /r "$INSTDIR\translations"

    MessageBox MB_ICONQUESTION|MB_YESNO "�Ƿ�ɾ���û����ݣ������������ݻ��桢�����û����õȵȣ���" IDYES +3
    SetAutoClose true
    Quit
    RMDir /r "$INSTDIR\userdata"
    RMDir /r "$INSTDIR"
    SetAutoClose true
SectionEnd

#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#

; ���붨��õĺ꣬������̼����غ���

!insertmacro DefFunc_CheckProcess ""
!insertmacro DefFunc_CheckProcess "un."

!insertmacro DefFunc_KillProcess ""
!insertmacro DefFunc_KillProcess "un."

!insertmacro DefFunc_ForceKillProcess ""
!insertmacro DefFunc_ForceKillProcess "un."

!insertmacro DefFunc_StartupCheck ""
!insertmacro DefFunc_StartupCheck "un."

Function .onInit
    call StartupCheck
    !insertmacro INSTALLOPTIONS_EXTRACT "othertask.ini"
FunctionEnd

Function PageOtherTask
    InstallOptions::dialog "$PLUGINSDIR\othertask.ini"
FunctionEnd

Function .onInstSuccess
    ReadINIStr $R0 "$PLUGINSDIR\othertask.ini" "Field 3" "State"
    ReadINIStr $R1 "$PLUGINSDIR\othertask.ini" "Field 4" "State"

    IntCmp $R0 1 0 +2 +2
    CreateShortCut "$DESKTOP\${PRODUCT_NAME_CN}.lnk" "$INSTDIR\bin\${PRODUCT_MAIN_EXE}"
!ifndef SERVER_BINS
    ;CreateShortCut "$DESKTOP\ѸͶ�ʲ�����ƽ̨�Ż�.lnk" "$INSTDIR\bin\XtAmpBrowser.exe"
!endif

    IntCmp $R1 1 0 +2 +2
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "${PRODUCT_NAME_EN}" '"$INSTDIR\bin\${PRODUCT_MAIN_EXE}" -w 600'

    IfSilent test_run
        goto cont
    test_run:
        MessageBox MB_ICONQUESTION|MB_YESNO "��װ��ϣ��Ƿ��������� ${PRODUCT_NAME_CN}��" IDYES +2
        goto cont
        ExecShell "" "$INSTDIR\bin\${PRODUCT_MAIN_EXE}"
    cont:
FunctionEnd

Function un.onInit
    call un.StartupCheck
    MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "��ȷʵҪ��ȫ�Ƴ� $(^Name) ���������е������" IDYES +2
    Abort
FunctionEnd

Function un.onUninstSuccess
    HideWindow
    MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) �ѳɹ��ش���ļ�����Ƴ���"
FunctionEnd

