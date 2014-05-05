#!/bin/bash

###
### The original purpose of this script was to collect data from a series
### of remote machines, possibly hopping through an ssh tunnel into a
### corporate vpn.
###
### It shows good examples of how to handle unreliable programs as well as
### useful methods for dealing with networked machines
###

set -u

servers='oc-wsu oc-600 bb-710 oc-eqx1 oc-eqx2'

function usage {
cat << EOF
usage: $0 [OPTIONS] [servers...]

This tool will take a little while to run. By default it will
collect and combine the data sets from:
	$servers

OPTIONS:
	-t HOST		Set up ssh tunnels through host (e.g. -t pbj)
	-o SSH_OPTS	Pass options to ssh in the format used in ssh_config(5)
	-r RSYNC_OPTS	Options to pass to rsync (eg --bwlimit=## for buggy VPN)
	-a		Append listed servers instead of replacing
	...		Remaining options are considered servers to process

EOF
}

function get_dumps {
	echo "BEGIN DATA RETRIVAL"
	for server in $servers; do
		ssh_cmd="ssh $SSH_OPTS -q"
		rsync_cmd="rsync $RSYNC_OPTS -q --partial"
		if [[ -n $TUNNEL ]]; then
			port=$[ $RANDOM % 1000 + 2000 ]
			ssh -N -L $port:$server:22 $TUNNEL &
			sleep 3s # XXX establish tunnel
			ssh_cmd="$ssh_cmd -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p $port"
			rsync_cmd="$rsync_cmd -e='$ssh_cmd'"
			target="localhost"
		else
			target="$server"
		fi

		echo -en "\t$server: dumping... "
		$ssh_cmd $target "mysqldump -u root prtt destAgg destLT > /tmp/${server}_dump"

		echo -n "copying... "
		# bash has no do-while support and rsync no retry feature... :(
		rsync_cmd="$rsync_cmd $target:/tmp/${server}_dump dumps/"
		while true; do
			eval $rsync_cmd
			if [[ $? -eq 0 ]]; then
				break
			fi
			sleep 1s # to all Ctrl-c to catch
		done

		if [[ -n $TUNNEL ]]; then
			kill %1
		fi

		echo "DONE"
	done
	echo "DONE. Data retrieved successfully from all requested servers"
}

TUNNEL=
SSH_OPTS=
RSYNC_OPTS=
COMBINE=1
APPEND=0

while getopts “ht:o:r:a” OPTION
do
	case $OPTION in
		h)
			usage
			exit 1
			;;
		t)
			TUNNEL=$OPTARG
			;;
		o)
			SSH_OPTS=$OPTARG
			;;
		r)
			RSYNC_OPTS=$OPTARG
			;;
		a)
			APPEND=1
			;;
		?)
			usage
			exit
			;;
	esac
done

shift $(($OPTIND - 1))
user_servers="$*"

if [[ -n $user_servers ]]; then
	if [[ $APPEND -eq 1 ]]; then
		echo "Appending $user_servers to $servers"
		servers="$servers $user_servers"
	else
		echo "Replacing server list with $user_servers"
		servers=$user_servers
	fi
fi

if ! echo "$servers" | egrep -q '^([a-zA-Z0-9._-]+ )*[a-zA-Z0-9._-]+$'; then
	echo "Server list should be single-space delimited, please check:"
	echo "$servers"
	exit 1
fi

mkdir -p dumps
get_dumps
