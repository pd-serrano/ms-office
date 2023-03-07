@ECHO OFF

SET Mode=Download

SET AppName=Microsoft Office
SET AppName2=Office
SET AppVer=2021
SET AppEd=Professional Plus

SET AppArch=x64

TITLE [ %Mode% Mode ] %AppName2% %AppVer% %AppEd% ( %AppArch% )

SET ExtSetup=.exe
SET ExtConfig=.xml
SET PathSetup=setup%ExtSetup%
SET PathConfig=Config_%AppName2%_%AppVer%_ProPlus_%AppArch%%ExtConfig%

SET PathBootstrap=https://raw.githubusercontent.com/pd-serrano/ms-office/main/Office%%202021%%20ProPlus/

SET h=	[ STATUS LOG ]
SET b=--------------------------------
SET l= 
SET s=%l%- 
SET e= . . .
SET suc=%s%[*] 
SET err=%s%[!] 

SET stat=X

:START
ECHO %b%
ECHO %h%

GOTO CheckSetup

:CheckSetup
SET stat=X
ECHO %b%
ECHO.
ECHO %s%Checking existence of [ %PathSetup% ] in [ %cd%\%PathSetup% ]%e%
IF EXIST "%cd%\%PathSetup%". (
	ECHO %suc%[ %PathSetup% ] is PRESENT%e%
) ELSE (
	ECHO %err%[ %PathSetup% ] is NOT PRESENT !
	SET stat=A
)

GOTO CheckConfig

:CheckConfig
ECHO.
ECHO %s%Checking existence of [ %PathConfig% ] in [ %cd%\%PathConfig% ]%e%
IF EXIST "%cd%\%PathConfig%". (
	ECHO %suc%[ %PathConfig% ] is PRESENT%e%
) ELSE (
	ECHO %err%[ %PathConfig% ] is NOT PRESENT !
	IF %stat% == X (SET stat=B) ELSE (SET stat=C)
)

GOTO CheckIncomplete

:CheckIncomplete
IF %stat% == X (GOTO ODTdownload) ELSE (GOTO DownloadBootstrap)

:DownloadBootstrap
ECHO %b%
ECHO %s%Missing bootstrap file(s) :
IF %stat% == A (
	ECHO %s%[ %PathSetup% ]
)
IF %stat% == B (
	ECHO %s%[ %PathConfig% ]
)
IF %stat% == C (
	ECHO %s%[ %PathSetup% ]
	ECHO %s%[ %PathConfig% ]
)
ECHO %b%
ECHO %s%Starting bootstrap download via [ Background Intelligent Transfer Service ]%e%
%WINDIR%\System32\timeout.exe /t 5 /nobreak > nul
IF %stat% == A (
	bitsadmin /transfer %PathSetup% /download /priority high "%PathBootstrap%%PathSetup%" "%cd%\%PathSetup%"
)
IF %stat% == B (
	bitsadmin /transfer %PathConfig% /download /priority high "%PathBootstrap%%PathConfig%" "%cd%\%PathConfig%"
)
IF %stat% == C (
	bitsadmin /transfer %PathSetup% /download /priority high "%PathBootstrap%%PathSetup%" "%cd%\%PathSetup%"
	bitsadmin /transfer %PathConfig% /download /priority high "%PathBootstrap%%PathConfig%" "%cd%\%PathConfig%"
)
GOTO START

:ODTdownload
ECHO %b%
ECHO.
ECHO %suc%Bootstrap files are PRESENT%e%
ECHO.
ECHO %s%Downloading installer files for [ %AppName2% %AppVer% %AppEd% ( %AppArch% ) ]%e%
ECHO %s%Download via [ %PathSetup% ] with [ %PathConfig% ] applied%e%
ECHO.
ECHO %suc%Destination folder for installer files : [ %cd%\Office ]
%WINDIR%\System32\timeout.exe /t 5 /nobreak > nul
ECHO %suc%DOWNLOAD HAS STARTED%e% DO NOT CLOSE THIS WINDOW !
ECHO %e%
"%cd%\%PathSetup%" /download "%cd%\%PathConfig%"
GOTO END

:END
ECHO %b%
ECHO %suc%DOWNLOAD COMPLETED%e%
ECHO %b%
ECHO %s%TO INSTALL : Open [ Install_%AppArch%.bat ]
ECHO.
ECHO %s%To reuse downloaded files WITHOUT downloading again%e%
ECHO %e% copy/paste the [ Office ] folder from [ %cd%\Office ]%e%
ECHO %e% and then just open [ Install_%AppArch%.bat ] again.
ECHO %b%
ECHO %s% This window may now be closed.
ECHO %s% ~UwU~
ECHO %b%
PAUSE