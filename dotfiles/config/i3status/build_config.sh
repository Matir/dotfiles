#!/bin/bash

function general {
  cat <<-EOF
		general {
			colors = true
			interval = 5
		}
	EOF
}

function disks {
	local DISKS=(/ /home)
	local d
	local used
	for d in ${DISKS[@]} ; do
		local dev=`df $d | tail -1 | awk '{print $1}'`
		if [[ *$dev* == $used ]] ; then
			continue
		fi
		local size=`df $d | tail -1 | awk '{print $2}'`
		if [ $size -eq 0 ] ; then
			continue
		fi
		used="${used} ${dev}"
		cat <<-EOF
			disk "${d}" {
				format = "${d} %avail"
			}
			order += "disk ${d}"
		EOF
	done
}

function wireless {
	which iwconfig >/dev/null || return
	iwconfig 2>&1 | grep . | grep -vq 'no wireless extensions' || return
	cat <<-EOF
		wireless _first_ {
			format_up = "W: (%quality %essid) %ip"
			format_down = "W: down"
		}
		order += "wireless _first_"
	EOF
}

function wired {
	cat <<-EOF
		ethernet _first_ {
			format_up = "E: %ip"
			format_down = "E: down"
		}
		order += "ethernet _first_"
	EOF
}

function ipv6 {
	echo "order += \"ipv6\""
}

function load {
	cat <<-EOF
		load {
			format = "%1min %5min"
		}
		order += "load"
	EOF
}

function now {
	cat <<-EOF
		tztime local {
			format = "%Y-%m-%d %H:%M"
		}
		order += "tztime local"
	EOF
}

function battery {
	local bat
	shopt -s nullglob
	for bat in /sys/class/power_supply/BAT* ; do
		local bid=${bat##*BAT}
		cat <<-EOF
			battery ${bid} {
				low_threshold = 15
				threshold_type = time
				status_chr = "↑ CHR"
				status_bat = "↓ BAT"
				status_unk = "? UNK"
				status_full = "FULL"
				format = "%status %percentage (%remaining %consumption)"
				path = "/sys/class/power_supply/BAT${bid}/uevent"
				hide_seconds = true
			}
			order += "battery ${bid}"
		EOF
	done
}

general
disks
wireless
wired
ipv6
load
battery
now

# vim:set noexpandtab