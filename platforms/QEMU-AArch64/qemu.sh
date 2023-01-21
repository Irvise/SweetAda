#!/usr/bin/env sh

#
# QEMU-AArch64 QEMU configuration file.
#

# QEMU executable
QEMU_EXECUTABLE="/opt/sweetada/bin/qemu-system-aarch64"

# telnet port numbers for serial ports
SPPORT0=4446
SPPORT1=4447

# console for serial port
/usr/bin/xterm \
  -T "QEMU-1" -geometry 80x24 -bg blue -fg white -sl 1024 -e \
  /bin/telnet localhost ${SPPORT0} \
  &
# console for serial port
/usr/bin/xterm \
  -T "QEMU-2" -geometry 80x24 -bg blue -fg white -sl 1024 -e \
  /bin/telnet localhost ${SPPORT1} \
  &

# QEMU machine
"${QEMU_EXECUTABLE}" \
  -M virt -cpu cortex-a53 -m 128 \
  -kernel ${KERNEL_OUTFILE} \
  -monitor "telnet:localhost:4445,server,nowait" \
  -chardev "socket,id=SERIALPORT0,port=${SPPORT0},host=localhost,ipv4=on,server=on,telnet=on,wait=off" \
  -serial "chardev:SERIALPORT0" \
  -chardev "socket,id=SERIALPORT1,port=${SPPORT1},host=localhost,ipv4=on,server=on,telnet=on,wait=off" \
  -serial "chardev:SERIALPORT1"

exit 0

