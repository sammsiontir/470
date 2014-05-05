#!/bin/bash

###
### This script is the lab submission script. It showcases some basic
### user interaction and is generally a simpler script
###

SUBMIT_DIR=/afs/umich.edu/user/p/p/ppannuto/470_W12
project=3_late
#req_files=("arbiter.v" "arbiter_test.v")
#req_files=("fa1_test.v" "fa1.v" "fa64_test.v" "fa64.v")
req_files=("part_a/fsm_ab.v" "part_b/fsm_cd.v")
sub_dirs=("part_a" "part_b")

##### Should not need to modify below this line #####

function usage ()
{
	echo
	echo "$0 <Directory to Submit>"
	echo "i.e. $0 470tut/"
}

function unsafeExit ()
{
  usage
  echo
  echo "The submission could not be completed. Exiting ....";
  exit -1
}

function safeExit ()
{
  echo
  echo "The submission was completed. All the best :) ...";
  exit 0 
}
user=`whoami`

function nuke ()
{
	echo
	echo "The submission script is about to 'make nuke' in $1 to minimize"
	echo -n "the amount of data submitted, do you wish to continue? [y/N] "
	read resp
	resp=`echo $resp | tr [:lower:] [:upper:]`
	if [ "$resp" != "Y" ]; then
		echo "User did not allow us to 'make nuke' dying"
		exit -1
	fi
	make nuke
}

if [ "$1" == "" ]; then
	echo "Missing Submission Directory"
	usage
	exit -1
fi

echo "Checking for required files in the submission directory \"$1\"..."
pushd $1

for ((j=0;j<${#req_files[*]};j++)); do
	file=$(echo ${req_files[${j}]})
	if [ ! -e $file ]; then
		echo "Could not find required file \"$file\", dying"
		exit -1
	fi
done
echo "All required files found"

if [ -n "$sub_dirs" ]; then
	for ((j=0;j<${#sub_dirs[*]};j++)); do
		dir=$(echo ${sub_dirs[${j}]})
		pushd $dir
		nuke $dir
		popd
	done
else
	nuke $1
fi

popd

echo "Submitting lab$project from $user ........"

echo "Starting submission process ...."
echo
mkdir -p "$SUBMIT_DIR/submit/lab$project/$user"

submit_cnt=0
while [ -e $SUBMIT_DIR/submit/lab$project/$user/submit$submit_cnt ]; do
	submit_cnt=$((submit_cnt + 1))
done

echo
echo "This is submission $submit_cnt for user $user."
echo "You may submit as many times are you wish until the deadline, only the"
echo "most recent submission will be scored"

cp -rf $1 $SUBMIT_DIR/submit/lab$project/$user/submit$submit_cnt
if [ $? -eq 0 ]; then
	safeExit
else
	unsafeExit
fi
