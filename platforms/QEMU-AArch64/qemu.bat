@ECHO OFF

REM
REM QEMU-AArch64 (QEMU emulator).
REM
REM Copyright (C) 2020-2023 Gabriele Galeotti
REM
REM This work is licensed under the terms of the MIT License.
REM Please consult the LICENSE.txt file located in the top-level directory.
REM

REM
REM Arguments:
REM -debug
REM
REM Environment variables:
REM TOOLCHAIN_PREFIX
REM GDB
REM KERNEL_OUTFILE
REM

REM ############################################################################
REM # Main loop.                                                               #
REM #                                                                          #
REM ############################################################################

REM QEMU executable
SET "QEMU_FILENAME=qemu-system-aarch64w.exe"
SET "QEMU_EXECUTABLE=C:\Program Files\QEMU\%QEMU_FILENAME%"

REM debug options
IF "%1"=="-debug" (
  SET "QEMU_DEBUG=-S -gdb tcp:localhost:1234,ipv4"
  SET "PYTHONHOME=%TOOLCHAIN_PREFIX%"
  ) ELSE (
  SET QEMU_DEBUG=
  )

REM telnet port numbers and listening timeout in s
SET MONITORPORT=4445
SET SERIALPORT0=4446
SET SERIALPORT1=4447
SET TILTIMEOUT=3

REM QEMU machine
REM EL1: -M virt
REM EL2: -M virt,virtualization=on
REM EL3: -M virt,secure=on
START "" "%QEMU_EXECUTABLE%" ^
  -M virt -cpu cortex-a53 -smp 4 -m 128 ^
  -kernel %KERNEL_OUTFILE% ^
  -monitor telnet:localhost:%MONITORPORT%,server,nowait ^
  -chardev socket,id=SERIALPORT0,port=%SERIALPORT0%,host=localhost,ipv4=on,server=on,telnet=on,wait=on ^
  -serial chardev:SERIALPORT0 ^
  -chardev socket,id=SERIALPORT1,port=%SERIALPORT1%,host=localhost,ipv4=on,server=on,telnet=on,wait=on ^
  -serial chardev:SERIALPORT1 ^
  %QEMU_DEBUG%

REM console for serial port
CALL :TCPPORT_IS_LISTENING %SERIALPORT0% %TILTIMEOUT%
START "" "C:\Program Files"\PuTTY\putty-w64.exe telnet://localhost:%SERIALPORT0%/
REM console for serial port
CALL :TCPPORT_IS_LISTENING %SERIALPORT1% %TILTIMEOUT%
START "" "C:\Program Files"\PuTTY\putty-w64.exe telnet://localhost:%SERIALPORT1%/

REM debug session
IF "%1"=="-debug" (
  "%GDB%" -q ^
  -iex "set new-console on" ^
  -iex "set basenames-may-differ" ^
  %KERNEL_OUTFILE% ^
  -ex "target extended-remote tcp:localhost:1234"
  ) ELSE (
  CALL :QEMUWAIT
  )

EXIT /B %ERRORLEVEL%

REM ############################################################################
REM # TCPPORT_IS_LISTENING                                                     #
REM #                                                                          #
REM ############################################################################
:TCPPORT_IS_LISTENING
SET "PORTOK=N"
SET "NLOOPS=0"
:TIL_LOOP
  timeout.exe /NOBREAK /T 1 >NUL
  FOR /F "tokens=*" %%I in ('NETSTAT.EXE -an ^| find.exe ":%1" ^| find.exe /C "LISTENING"') DO SET VAR=%%I
  IF "%VAR%" NEQ "0" (
    SET "PORTOK=Y"
    GOTO :TIL_LOOPEND
    )
  SET /A NLOOPS += 1
  IF "%NLOOPS%" NEQ "%2" GOTO :TIL_LOOP
:TIL_LOOPEND
IF NOT "%PORTOK%"=="Y" ECHO TIMEOUT WAITING FOR PORT %1
GOTO :EOF

REM ############################################################################
REM # QEMUWAIT                                                                 #
REM #                                                                          #
REM ############################################################################
:QEMUWAIT
:QW_LOOP
tasklist.exe | find.exe /I "%QEMU_FILENAME%" >NUL 2>&1
IF ERRORLEVEL 1 (
  GOTO :QW_LOOPEND
  ) ELSE (
  timeout.exe /NOBREAK /T 5 >NUL
  GOTO :QW_LOOP
  )
:QW_LOOPEND
GOTO :EOF

