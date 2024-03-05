#!/usr/bin/env sh

#
# SweetAda GPRbuild bind-phase output filter.
#
# Copyright (C) 2020-2024 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = elaboration dump filename
#
# Environment variables:
# none
#

# shellcheck disable=SC2154,SC2268,SC2317

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

SCRIPT_FILENAME=$(basename "$0")
LOG_FILENAME=""
if [ "x${LOG_FILENAME}" != "x" ] ; then
  rm -f "${LOG_FILENAME}"
  touch "${LOG_FILENAME}"
fi

################################################################################
# log_print()                                                                  #
#                                                                              #
################################################################################
log_print()
{
if [ "x${LOG_FILENAME}" != "x" ] ; then
  printf "%s\n" "$1" | tee -a "${LOG_FILENAME}"
else
  printf "%s\n" "$1"
fi
return 0
}

################################################################################
# log_print_error()                                                            #
#                                                                              #
################################################################################
log_print_error()
{
if [ "x${LOG_FILENAME}" != "x" ] ; then
  printf "%s\n" "$1" | tee -a "${LOG_FILENAME}" 1>&2
else
  printf "%s\n" "$1" 1>&2
fi
return 0
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

#
# Basic input parameters check.
#
if [ "x$1" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Notice: no elaboration dump file specified."
  ELABORATION_FILENAME="gnatbind_elab.lst"
else
  ELABORATION_FILENAME="$1"
fi

exit_status=0

STATE=0
ELABORATION_CREATEFILE=
while IFS= read -r line ; do
  ELABORATION=
  ELABORATION_ORDER_DEPS=
  ELABORATION_ORDER=
  EMPTY_LINE=
  case ${line} in
    __exitstatus__=*)
      eval ${line}
      exit_status=${__exitstatus__}
      break
      ;;
    "ELABORATION ORDER DEPENDENCIES")
      ELABORATION=Y
      ELABORATION_ORDER_DEPS=Y
      ;;
    "ELABORATION ORDER")
      ELABORATION=Y
      ELABORATION_ORDER=Y
      ;;
    "")
      EMPTY_LINE=Y
      ;;
    *)
      ;;
  esac
  case ${STATE} in
    0)
      PRINT=STDOUT
      if [ "${EMPTY_LINE}" = "Y" ] ; then
        PRINT=
        STATE=1
      fi
      ;;
    1)
        line="
${line}"
      if [ "${ELABORATION}" = "Y" ] ; then
        if [ "x${ELABORATION_CREATEFILE}" = "x" ] ; then
          ELABORATION_CREATEFILE=Y
          rm -f "${ELABORATION_FILENAME}"
          touch "${ELABORATION_FILENAME}"
        fi
        PRINT=FILE
        if   [ "${ELABORATION_ORDER}" = "Y" ] ; then
          STATE=2
        elif [ "${ELABORATION_ORDER_DEPS}" = "Y" ] ; then
          STATE=3
        fi
      else
        PRINT=STDOUT
        STATE=0
      fi
      ;;
    # ELABORATION ORDER
    2)
      if [ "${EMPTY_LINE}" = "Y" ] ; then
        STATE=0
      fi
      ;;
    # ELABORATION ORDER DEPENDENCIES
    3)
      # empty line after "ELABORATION ORDER DEPENDENCIES"
      if [ "${EMPTY_LINE}" = "Y" ] ; then
        STATE=4
      fi
      ;;
    4)
      if [ "${EMPTY_LINE}" = "Y" ] ; then
        STATE=0
      fi
      ;;
    # default
    *)
      ;;
  esac
  case ${PRINT} in
    STDOUT)
      printf "%s\n" "${line}"
      ;;
    FILE)
      printf "%s\n" "${line}" >> "${ELABORATION_FILENAME}"
      ;;
    *)
      ;;
  esac
done

exit ${exit_status}

