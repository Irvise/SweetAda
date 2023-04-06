#!/usr/bin/env python

#
# Intel(R) Quartus SweetAda integration.
#
# Copyright (C) 2020-2023 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# none
#
# Environment variables:
# SWEETADA_PATH
# LIBUTILS_DIRECTORY
# TOOLCHAIN_PROGRAM_PREFIX
# QUARTUS_PATH
# QSYS_PROJECT_PATH
# QSYS_SOF_FILENAME
# KERNEL_OUTFILE
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

import sys
# avoid generation of *.pyc
sys.dont_write_bytecode = True
import os

SCRIPT_FILENAME = os.path.basename(sys.argv[0])

################################################################################
#                                                                              #
################################################################################

import subprocess
sys.path.append(os.path.join(os.getenv('SWEETADA_PATH'), os.getenv('LIBUTILS_DIRECTORY')))
import library
import libopenocd

# helper function
def printf(format, *args):
    sys.stdout.write(format % args)
# helper function
def errprintf(format, *args):
    sys.stderr.write(format % args)

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

TOOLCHAIN_PROGRAM_PREFIX = os.getenv('TOOLCHAIN_PROGRAM_PREFIX')
QUARTUS_PATH             = os.getenv('QUARTUS_PATH')
SOF_FILE                 = os.getenv('QSYS_SOF_FILENAME')
ELF_FILE                 = os.path.join(os.getenv('SWEETADA_PATH'), os.getenv('KERNEL_OUTFILE'))

platform = library.platform_get()
if platform != 'unix':
    errprintf('%s: *** Error: platform not recognized.\n', SCRIPT_FILENAME)
    exit(1)

if len(sys.argv) > 1:
    if sys.argv[1] == '-jtagd':
        jtagd_command = [os.path.join(QUARTUS_PATH, 'quartus/bin/jtagd')]
        if library.is_python3():
            result = subprocess.run(jtagd_command)
            exit(result.returncode)
        else:
            result = subprocess.check_output(jtagd_command)
    else:
        errprintf('%s: *** Error: command not recognized.\n', SCRIPT_FILENAME)
        exit(1)

printf('Running nios2-configure-sof ...\n')
configure_sof_command = [
    'sh', '-c',
    'cd ' + QUARTUS_PATH + '/nios2eds && \
     ./nios2_command_shell.sh            \
     nios2-configure-sof                 \
       --debug                           \
       --cable "USB-Blaster"             \
       --device 1                        \
    ' + SOF_FILE
    ]
if library.is_python3():
    result = subprocess.run(configure_sof_command)
    if result.returncode != 0:
        errprintf('%s: *** Error: program failed.\n', SCRIPT_FILENAME)
        exit(1)
else:
    result = subprocess.check_output(configure_sof_command)

# NOTE: needs nios2-elf-objcopy
# --cpu_name "nios2_gen2_0"
# --instance 0
# --jdi ${JDI}
# --reset-target
printf('Running nios2-download ...\n')
download_command = [
    'sh', '-c',
    'cd ' + QUARTUS_PATH + '/nios2eds &&           \
     PATH=' + TOOLCHAIN_PROGRAM_PREFIX + ':${PATH} \
     ./nios2_command_shell.sh                      \
     nios2-download                                \
       --debug                                     \
       --cable "USB-Blaster"                       \
       --device 1                                  \
       --go                                        \
    ' + ELF_FILE
    ]
if library.is_python3():
    result = subprocess.run(download_command)
    if result.returncode != 0:
        errprintf('%s: *** Error: program failed.\n', SCRIPT_FILENAME)
        exit(1)
else:
    result = subprocess.check_output(download_command)

exit(0)

