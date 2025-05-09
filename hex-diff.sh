#!/usr/bin/env bash

OPTIND=1
usage="${0##*/} [-o outdir] FILE FILE2"
output_dir="/tmp/"

if [[ $# -eq 0 ]]; then 
	echo "$usage"
	exit
fi;

while getopts "ho:" opt; do case ${opt} in
	h)	
	echo "$usage"
	exit
	;;
	o)
	output_dir=$OPTARG
	;;
esac; done

shift $((OPTIND-1))
[ "${1:-}" = "--" ] && shift

if [[ ! -e $1 ]]; then
	echo "Filename $1 not found"
	exit
elif [[ ! -e $2 ]]; then
	echo "Filename $2 not found"
	exit
fi

out1="$output_dir/$(basename "$1")".xxd

if [[ $(basename "$1") == $(basename "$2") ]]; then
	out2="$output_dir/$(basename "$2")"_2.xxd
else
	out2="$output_dir/$(basename "$2")".xxd
fi

xxd "$1" > "$out1" && xxd "$2" > "$out2"
nvim -bd "$out1" "$out2"
