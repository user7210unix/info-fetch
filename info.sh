#!/bin/bash

# simple system information script

wms=(berry awesomewm easywm tinywm bspwm sway hyprland dwl i3 fusionwm dwm openbox twobwm pekwm)

# define colors for color-echo
red="\e[31m"
grn="\e[32m"
ylw="\e[33m"
cyn="\e[36m"
blu="\e[34m"
prp="\e[35m"
rst="\e[0m"

color-echo() {  # print with colors
   printf "$red$1$cyn%10s : $rst$3\n" "$2"
}

print-kernel() {
   color-echo "$1" "Kernel" "$(uname -smr)"
}

print-uptime() {
   up=$(</proc/uptime)
   up=${up//.*}                # string before first . is seconds
   days=$((${up}/86400))       # seconds divided by 86400 is days
   hours=$((${up}/3600%24))    # seconds divided by 3600 mod 24 is hours
   mins=$((${up}/60%60))       # seconds divided by 60 mod 60 is mins
   
   color-echo "$1" "Uptime" "$(echo $days'd '$hours'h '$mins'm')"
}

print-shell() {
   color-echo "$1" "Shell" $SHELL
}

print-cpu() {
   cpu=$(grep -m1 -i 'model name' /proc/cpuinfo)
   color-echo "$1" "CPU" "${cpu#*: }" # everything after colon is processor name
}

print-disk() {
   # field 2 on line 2 is total, field 3 on line 2 is used
   disk=$(df -h / | awk 'NR==2 {total=$2; used=$3; print used" / "total}')
   color-echo "$1" "Disk" "$disk"
}

print-mem() {
   # field 2 on line 2 is total, field 3 on line 2 is used (in new format)
   if [[ $(free -m) =~ "buffers" ]]; then # using old format
      mem=$(free -m | awk 'NR==2 {total=$2} NR==3 {used=$3; print used"M / "total"M"}')
   else # using new format
      mem=$(free -m | awk 'NR==2 {total=$2} NR==2 {used=$3; print used"M / "total"M"}')
   fi

   color-echo "$1" "Mem" "$mem"
}

print-wm() {
   for wm in ${wms[@]}; do
      pid=$(pgrep -x -u $USER $wm) # if found, this wmname has running process
   if [[ "$pid" ]]; then
      color-echo "$1" "WM" $wm
      break
   fi
done
}

print-distro() {
   [[ -e /etc/os-release ]] && source /etc/os-release
   if [[ -n "$PRETTY_NAME" ]]; then
      color-echo "$1" "OS" "$PRETTY_NAME"
   else
      color-echo "$1" "OS" "not found"
   fi
}

print-packages() {
   package_count=$(dpkg-query -l | wc -l)
   color-echo "$1"  "Packages" "$((package_count - 5)) (dpkg-query)"
}

print-resolution() {
   res=$(xwininfo -root | grep 'geometry' | awk '{print $2}' | cut -d+ -f1)
   color-echo "$1" "Resolution" $res
}


print-init() {
   init=$(readlink /proc/1/exe | awk -F'/' '{print $NF}')
   
   case "$init" in
      "systemd")
         color-echo "$1" "Init System" "systemd"
         ;;
      "runit")
         color-echo "$1" "Init System" "runit"
         ;;
      "init")
         # check if init is sysvinit or openrc
         if [[ -f "/etc/init.d" ]]; then
            if [[ -f "/etc/init.d/system" ]]; then
               color-echo "$1" "Init System" "sysvinit"
            else
               color-echo "$1" "Init System" "OpenRC"
            fi
         else
            color-echo "$1" "Init System" "Unknown"
         fi
         ;;
      *)
         color-echo "$1" "Init System" "$init"
         ;;
   esac
}

current_time=$(date +"%H:%M - %d/%m/%Y")

print-tarballs() {
   tarballs=$(find /home/$USER/sources -type f -name "*.tar.*" | wc -l)  # changed to user's home directory
   color-echo "$1" "Tarballs" "$tarballs"
}

print-patches() {
   patches=$(find /home/$USER/sources -type f -name "*.patch" | wc -l)  # changed to user's home directory
   color-echo "$1" "Patches" "$patches"
}

color-echo "$1" "DATE" "$current_time"


print-distro
print-kernel
print-cpu
print-mem
print-shell
print-wm
print-resolution
print-packages
print-tarballs
print-patches

