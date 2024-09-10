## Bash Timer
##   https://github.com/hopeseekr/bash-timer/
##   https://github.com/hopeseekr/BashScripts/
##
## Copyright © 2020-2024 Theodore R. Smith <theodore@phpexperts.pro>
##   GPG Fingerprint: 4BF8 2613 1C34 87AC D28F  2AD8 EB24 A91D D612 5690
##   https://stackoverflow.com/users/story/430062
##
## Based off of the work of
##  * https://jakemccrary.com/blog/2020/04/21/using-bash-preexec-for-monitoring-the-runtime-of-your-last-command/
##
## This file is licensed under the Creative Commons Attribution License v4.0 International.
##
## Version 1.5.0 @ 2024-08-24.

## Set up tput for multi-terminal color support.
if [ $(builtin type -P "tput" 2>&1)  ]; then
  tput init
  BOLD="\[$(tput bold)\]"
  RESET="\[$(tput sgr0)\]"
else
  BOLD="\[\033[1m\]"
  RESET="\[\033[0m\]"
fi

pad_number() {
  number="$1"
  while [ ${#number} -lt 3 ]; do
    number="0${number}"
  done
  echo "$number"
}

human_time()
{
  local msg
  local s=$1
  local days=$((s / (60*60*24)))
  s=$((s - days*60*60*24))
  local hours=$((s / (60*60)))
  s=$((s - hours*60*60))
  local min=$((s / 60))
  s=$((s - min*60))

  if (($days > 0)); then
    printf "%1d:%02d:%02d:%02d" $days $hours $min $s
    return
  fi

  if (($hours > 0)); then
    printf "%1d:%02d:%02d" $hours $min $s
    return
  fi

  if (($min > 0)); then
    printf "%1d:%02d" $min $s
    return
  fi
}

bashtimer_preexec() {
  # Thanks to /u/OneTurnMore
  # https://www.reddit.com/r/bash/comments/ivz276/tired_of_typing_time_all_the_time_try_bashtimer/g5wui2l/
  if [ ! -z "$EPOCHREALTIME" ]; then
    # Replace "," decimal separator with ".". This is needed for European locales, among others.
    local _EPOCHREALTIME="${EPOCHREALTIME/,/.}"

    begin_s=${_EPOCHREALTIME%.*}
    begin_ns=${_EPOCHREALTIME#*.}
    begin_ns="${begin_ns#0}"
  else
    read begin_s begin_ns <<< $(date +"%s %N")
  fi
  timer_show="0"
}

bashtimer_precmd() {
  if [ ! -z "$begin_ns" ]; then
    local s
    local ms
    local end_s
    local end_ns

    # Thanks to /u/OneTurnMore
    # https://www.reddit.com/r/bash/comments/ivz276/tired_of_typing_time_all_the_time_try_bashtimer/g5wui2l/
    if [ ! -z "$EPOCHREALTIME" ]; then
      # Replace "," decimal separator with ".". This is needed for European locales, among others.
      local _EPOCHREALTIME="${EPOCHREALTIME/,/.}"

      end_s=${_EPOCHREALTIME%.*}
      # echo "Begin Seconds: $begin_s | End Seconds: $end_s"
      end_ns=${_EPOCHREALTIME#*.}
      end_ns="${end_ns#0}"

      if [ $end_ns -lt $begin_ns ]; then
        end_ns=$((1000000 + $end_ns))
        end_s=$(($end_s - 1))
      fi
      # Convert strings with leading zeros to base 10 integers
      begin_ns=$((10#$begin_ns))
      end_ns=$((10#$end_ns))

      s=$((end_s - begin_s))
      if [ "$end_ns" -ge "$begin_ns" ]; then
        ms=$(( (end_ns - begin_ns) / 1000 ))
      else
        ms=$((((1000000 + end_ns) - begin_ns) / 1000))
      fi

      # Ensure ms is always three digits for consistency in output:
      ms=$(pad_number "$ms")
    else
      # For Bash < v5.0
      read end_s end_ns <<< $(date +"%s %N")
      end_ns="${end_ns##+(0)}"

      s=$((end_s - begin_s))
      if [ "$end_ns" -ge "$begin_ns" ]
      then
        ms=$(((end_ns - begin_ns) / 1000000))
      else
        s=$((s - 1))
        ms=$(((1000000000 + end_ns - begin_ns) / 1000000))
      fi
    fi

    if (($s > 60)); then
      timer_show="$(human_time $s).$ms"
    else
      timer_show="$s.$ms "
    fi
  fi

  if [ -z "$PS1orig" ]; then
    PS1orig=$PS1
  else
      if [ -z "$NO_BASHTIMER" ]; then
    PS1="${BOLD}$timer_show${RESET}$PS1orig"
        fi
  fi
}

## Using `bash-preexec` functions arrays makes this script compatible with other scripts that use `bash-preexec`.
## It avoids overwriting variables `preexec` and `precmd`. 
preexec_functions+=(bashtimer_preexec)
precmd_functions+=(bashtimer_precmd)
