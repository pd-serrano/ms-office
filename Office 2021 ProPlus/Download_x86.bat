@ECHO OFF

SET Mode=Download

SET AppName=Microsoft Office
SET AppName2=Office
SET AppVer=2021
SET AppEd=Professional Plus

SET AppArch=x86

SET BatchTitle=d

SET ExtSetup=.exe
SET ExtConfig=.xml
SET PathSetup=setup%ExtSetup%
SET PathConfig=Config_%AppName2%_%AppVer%_ProPlus_%AppArch%%ExtConfig%

SET PathBootstrap=https://github.com/pd-serrano/ms-office/
SET PathBootstrapDynamic

SET h=	[ STATUS LOG ]
SET b=--------------------------------
SET l= 
SET s=%l%-   
SET e= . . .
SET suc=%l%[*] 
SET err=%l%[!] 

SET stat=X

TITLE test

ECHO %b%
ECHO %h%
ECHO %b%

GOTO CheckSetup

:CheckSetup
ECHO %s%Checking existence of file, [ %PathSetup% ]%e%
IF EXIST "%PathSetup%". (
	ECHO %suc%[ %PathSetup% ] is PRESENT%e%
) ELSE (
	ECHO %err%[ %PathSetup% ] is NOT PRESENT !
	SET stat=A
)

GOTO CheckConfig

:CheckConfig
ECHO %s%Checking existence of file, [ %PathConfig% ]%e%
IF EXIST "%PathConfig%". (
	ECHO %suc%[ %PathConfig% ] is PRESENT%e%
) ELSE (
	ECHO %err%[ %PathConfig% ] is NOT PRESENT !
	IF %stat% == X (SET stat=B) ELSE (SET stat=C)
)

GOTO CheckIncomplete

:CheckIncomplete
IF %stat% == X (GOTO ODTdownload) ELSE (GOTO DownloadBootstrap)

:ODTdownload
ECHO %suc%Bootstrap files are PRESENT%e%
ECHO %s%Starting download via [ %PathSetup% ] with [ %PathConfig% ] applied%e%

:DownloadBootstrap
ECHO %s%Missing file(s) :
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
%s%Starting download via [ Background Intelligent Transfer Service ]%e%
bitsadmin /transfer Dragona.exe /download /priority high "%PathBootstrap%"

:END
PAUSE