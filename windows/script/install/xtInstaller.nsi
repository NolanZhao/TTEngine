;--------------------------------
; xtclient Setup NSIS Script
; @author zoubailiu
; @date   2012-5-7
;
; 用法：
; makensis.exe [/DSERVER_BINS] [/DBIN_SUBDIR=Standalone_Release] [/DPRODUCT_NAME_CN=迅投交易终端] [/DPRODUCT_NAME_EN=XtTradeClient] [/DPRODUCT_VERSION=x.x.x.xxxx] [/DORIGINAL_FILENAME=xxx.exe] [/DOUTFILE=c:\xxx.exe] xxx.nsi
;

!include "LogicLib.nsh"

; 安装程序初始定义常量

!ifndef PRODUCT_NAME_CN
    !define PRODUCT_NAME_CN "迅投资产管理平台终端"
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
!define PRODUCT_PUBLISHER "北京睿智融科控股有限公司"
!define PRODUCT_COPYRIGHT "Copyright (C) 2012 Beijing RaiseTech Holding Ltd Company"
!define PRODUCT_WEB_SITE "http://www.thinktrader.net"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${PRODUCT_MAIN_EXE}"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME_CN}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_REASOURCE_DIR "installerResource"
!define PRODUCT_INSTALLER_NAME "${PRODUCT_NAME_CN} 安装程序"

SetCompressor lzma

; ------ MUI 现代界面定义 (1.67 版本以上兼容) ------
!include "MUI.nsh"

; MUI 预定义常量
!define MUI_ABORTWARNING
!define MUI_ICON "${PRODUCT_REASOURCE_DIR}\Setup.ico"
!define MUI_UNICON "${PRODUCT_REASOURCE_DIR}\uninst.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "${PRODUCT_REASOURCE_DIR}\welcome.bmp"

; 欢迎页面
!insertmacro MUI_PAGE_WELCOME
; 许可协议页面
!define MUI_LICENSEPAGE_CHECKBOX
!insertmacro MUI_PAGE_LICENSE "${PRODUCT_REASOURCE_DIR}\license.txt"
; 安装目录选择页面
!insertmacro MUI_PAGE_DIRECTORY
; 安装过程页面
!insertmacro MUI_PAGE_INSTFILES
; 安装完成页面
Page custom PageOtherTask
!define MUI_FINISHPAGE_RUN "$INSTDIR\bin\${PRODUCT_MAIN_EXE}"
!define MUI_FINISHPAGE_RUN_TEXT "运行 ${PRODUCT_NAME_CN}"
!insertmacro MUI_PAGE_FINISH

; 安装卸载过程页面
!insertmacro MUI_UNPAGE_INSTFILES

; 安装界面包含的语言设置
!insertmacro MUI_LANGUAGE "SimpChinese"

; 安装预释放文件
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI 现代界面定义结束 ------

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
; VIAddVersionKey ProductName "${PRODUCT_NAME_CN} ${PRODUCT_VERSION}" ;产品名称
VIAddVersionKey ProductName "${PRODUCT_NAME_CN}"
VIAddVersionKey ProductVersion "${PRODUCT_VERSION}"
VIAddVersionKey Comments "${PRODUCT_INSTALLER_NAME}"
VIAddVersionKey CompanyName "${PRODUCT_PUBLISHER}"
VIAddVersionKey LegalCopyright "${PRODUCT_COPYRIGHT}"
VIAddVersionKey InternalName "${PRODUCT_INSTALLER_NAME}"
; VIAddVersionKey LegalTrademarks "${PRODUCT_PUBLISHER}" ;合法商标 ;
VIAddVersionKey OriginalFilename "${ORIGINAL_FILENAME}"
; VIAddVersionKey PrivateBuild "XX" ;个人内部版本说明
; VIAddVersionKey SpecialBuild "XX" ;特殊内部本本说明 


RequestExecutionLevel admin

; 把"un."作为参数传入，勉强实现安装和卸载共用函数代码
; 实际上是用一个宏定义两个函数

!macro DefFunc_CheckProcess un
Function ${un}CheckProcess
    Pop $0  ; module name
    Pop $1  ; exe name
    FindProcDLL::FindProc "$1"
    Pop $R0
    IntCmp $R0 0 not_found  ; 如果FindProc结果为0，表示未找到程序，否则继续
    MessageBox MB_ICONSTOP "安装程序检测到 ${PRODUCT_NAME_CN} $0 正在运行，请退出此程序后重试。" IDYES +2
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
    IntCmp $R0 0 no_more  ; 如果FindProc结果为0，表示未找到程序，否则继续
    MessageBox MB_ICONQUESTION|MB_YESNO "安装程序检测到 ${PRODUCT_NAME_CN} $0 正在运行，是否终止此程序？" IDYES try_kill
    MessageBox MB_ICONSTOP "${PRODUCT_NAME_CN} $0 正在运行，请退出此程序后重试"
    Quit
try_kill:
    Push $1
    Push $0
    call ${un}ForceKillProcess  ; 函数调用
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
    IntCmp $R0 0 try_kill_one       ; 返回0表示杀进程成功，则应继续杀此进程名的其它进程
    IntCmp $R0 602 check_no_more    ; 返回602表示因为其它原因杀进程失败，但实际上发现有时候其实是杀成功了的（如C盘根目录先跑着资管的daemon再安装单机），故需要进一步检查
    IntCmp $R0 603 check_no_more    ; 返回603表示没找到此进程，有两种情况：a) 确实没有此进程 b) 因权限等原因无法访问此进程，如果第2种，应认为杀进程失败，所以需要进一步检查
    MessageBox MB_ICONSTOP "无法终止 $0 ($1) (code=$R0)，请手动终止此程序后重试"   ; KillProc返回值非0非603
    Quit
check_no_more:
    FindProcDLL::FindProc "$1"
    Pop $R0
    IntCmp $R0 1 try_kill_one  ; 如果FindProc结果为1，表示找到了程序，说明还有进程存在，继续杀
FunctionEnd
!macroend

!macro DefFunc_StartupCheck un
Function ${un}StartupCheck
    IfSilent force_kill

        Push "${PRODUCT_MAIN_EXE}"
        Push "交易主程序"
        call ${un}CheckProcess

!ifndef SERVER_BINS
        ;Push "XtAmpBrowser.exe"
        ;Push "门户主程序"
        ;call ${un}CheckProcess
!endif

        Push "XtQuoter.exe"
        Push "行情服务程序"
        call ${un}KillProcess

        Push "XtDaemon.exe"
        Push "服务监控程序"
        call ${un}KillProcess
    !ifdef SERVER_BINS
        Push "XtTraderService.exe"
        Push "交易服务程序"
        call ${un}KillProcess

        Push "XtService.exe"
        Push "策略服务程序"
        call ${un}KillProcess

        Push "XtBroker.exe"
        Push "交易后台程序"
        call ${un}KillProcess

        Push "XtRiskControl.exe"
        Push "交易风控程序"
        call ${un}KillProcess
    !endif
        
        Push "crashui.exe"
        Push "错误反馈程序"
        call ${un}ForceKillProcess

    goto cont

    force_kill:

        Push "${PRODUCT_MAIN_EXE}"
        Push "交易主程序"
        call ${un}ForceKillProcess

!ifndef SERVER_BINS
        ;Push "XtAmpBrowser.exe"
        ;Push "门户主程序"
        ;call ${un}ForceKillProcess
!endif

        Push "XtQuoter.exe"
        Push "行情服务程序"
        call ${un}ForceKillProcess

        Push "XtDaemon.exe"
        Push "服务监控程序"
        call ${un}ForceKillProcess
    !ifdef SERVER_BINS
        Push "XtTraderService.exe"
        Push "交易服务程序"
        call ${un}ForceKillProcess

        Push "XtService.exe"
        Push "策略服务程序"
        call ${un}ForceKillProcess

        Push "XtBroker.exe"
        Push "交易后台程序"
        call ${un}ForceKillProcess
        
        Push "XtRiskControl.exe"
        Push "交易风控程序"
        call ${un}ForceKillProcess        

        Push "crashui.exe"
        Push "错误反馈程序"
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

    ;V8T行情dll
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

    ;VC运行时
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\msvcm90.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\msvcp90.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\msvcr90.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\Microsoft.VC90.CRT.manifest"

    ;QT动态库
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\QtCore4.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\QtGui4.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\QtXml4.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\QtWebKit4.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\QtNetwork4.dll"

    ;server5 base dll
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\net.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\persist.dll"

    ;xtclient程序
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\${PRODUCT_MAIN_EXE}"
!ifndef SERVER_BINS
    ;File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\XtAmpBrowser.exe"
!endif
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\crash.dll"
    File "..\..\_runtime\bin.pack\${BIN_SUBDIR}\crashui.exe"
    
    ;用户协议文件
    SetOutPath "$INSTDIR\agreement"
    SetOverwrite on
    File /r "..\..\_runtime\agreement\*.*"
    
    ;资源文件
    SetOutPath "$INSTDIR\resource"
    SetOverwrite on
    File /r "..\..\_runtime\resource\*.*"

    ;插件
    ;图片插件
    SetOutPath "$INSTDIR\plugins\imageformats"
    SetOverwrite on
    File "..\..\_runtime\plugins\imageformats\qgif4.dll"
    File "..\..\_runtime\plugins\imageformats\qico4.dll"
    File "..\..\_runtime\plugins\imageformats\qjpeg4.dll"
    File "..\..\_runtime\plugins\imageformats\qmng4.dll"
    File "..\..\_runtime\plugins\imageformats\qsvg4.dll"
    File "..\..\_runtime\plugins\imageformats\qtga4.dll"
    File "..\..\_runtime\plugins\imageformats\qtiff4.dll"
    
    ;控件语言
    SetOutPath "$INSTDIR\translations"
    SetOverwrite on
    File /r "..\..\_runtime\translations\*.*"

    ;配置
    SetOutPath "$INSTDIR\config"
    SetOverwrite on
    File /r "..\..\_runtime\config.pack\${BIN_SUBDIR}\*.*"

    ;lua脚本
    SetOutPath "$INSTDIR\luaScripts"
    SetOverwrite on
    File /r "..\..\_runtime\luaScripts\*.*"
    
    ;本地配置
    SetOutPath "$INSTDIR\config_local"
    SetOverwrite on
    File /r "..\..\_runtime\config_local\customer.lua"

    CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME_CN}"
    CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME_CN}\启动${PRODUCT_NAME_CN}.lnk" "$INSTDIR\bin\${PRODUCT_MAIN_EXE}"
!ifndef SERVER_BINS
    ;CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME_CN}\启动迅投资产管理平台门户.lnk" "$INSTDIR\bin\XtAmpBrowser.exe"
!endif
  
SectionEnd

Section -AdditionalIcons
    SetOutPath $INSTDIR\bin
    SetOverwrite on
    WriteIniStr "$INSTDIR\${PRODUCT_NAME_CN}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
    CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME_CN}\官方首页.lnk" "$INSTDIR\${PRODUCT_NAME_CN}.url"
    CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME_CN}\卸载${PRODUCT_NAME_CN}.lnk" "$INSTDIR\uninst.exe"
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
 *  以下是安装程序的卸载部分  *
 ******************************/

Section Uninstall
    Delete "$DESKTOP\${PRODUCT_NAME_CN}.lnk"
    Delete "$INSTDIR\${PRODUCT_NAME_CN}.url"
    Delete "$SMSTARTUP\${PRODUCT_NAME_CN}.lnk"
!ifndef SERVER_BINS
    ;Delete "$DESKTOP\迅投资产管理平台门户.lnk"
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

    MessageBox MB_ICONQUESTION|MB_YESNO "是否删除用户数据（包括行情数据缓存、本地用户配置等等）？" IDYES +3
    SetAutoClose true
    Quit
    RMDir /r "$INSTDIR\userdata"
    RMDir /r "$INSTDIR"
    SetAutoClose true
SectionEnd

#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#

; 插入定义好的宏，定义进程检查相关函数

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
    ;CreateShortCut "$DESKTOP\迅投资产管理平台门户.lnk" "$INSTDIR\bin\XtAmpBrowser.exe"
!endif

    IntCmp $R1 1 0 +2 +2
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "${PRODUCT_NAME_EN}" '"$INSTDIR\bin\${PRODUCT_MAIN_EXE}" -w 600'

    IfSilent test_run
        goto cont
    test_run:
        MessageBox MB_ICONQUESTION|MB_YESNO "安装完毕，是否立即运行 ${PRODUCT_NAME_CN}？" IDYES +2
        goto cont
        ExecShell "" "$INSTDIR\bin\${PRODUCT_MAIN_EXE}"
    cont:
FunctionEnd

Function un.onInit
    call un.StartupCheck
    MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "你确实要完全移除 $(^Name) ，及其所有的组件？" IDYES +2
    Abort
FunctionEnd

Function un.onUninstSuccess
    HideWindow
    MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从你的计算机移除。"
FunctionEnd

