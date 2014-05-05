#!/bin/bash

###
### This is the script that was responsible for scraping your P3 subversion
### respositories. It highlights some degree of flexibility in directory
### structure and heavy use of redirection to build a clean output file
###

SVN_CMD='svn co'
SVN_PATH='470/P3'
ROOT='/afs/umich.edu/user'
UNIQS='uniqs.txt'
MAILS='mails'
TESTS_DIR=$(pwd)/tests

T_DIR=/tmp/470_co

rm -rf $T_DIR
mkdir $T_DIR

rm -rf $MAILS
mkdir $MAILS

total=0
missing=0
success=0

function _find_make() {
	echo "Considering candidate directory $(pwd): " | tee -a $1
	if [ ! -r Makefile ]; then
		echo -e "\t$(pwd) Does not contain a Makefile, skipping" >> $1
		return 1;
	fi

	if [ make -n simv -s >& /dev/null ]; then
		echo "This Makefile does not know how to 'make simv' skipping" >> $1
		echo "-----" >> $1
		echo "Output of 'make -n simv in $(pwd)':" >> $1
		make -n simv >& $1
		echo "-----" >> $1
		return 2;
	fi

	echo -e "\tChoosing Makefile in '$(pwd)'" | tee -a $1
	return 0;
}

function find_make() {
	for dir in $(find . -type d ! -path "*/.*"); do
		pushd $dir > /dev/null
		if _find_make $1; then
			return 0
		fi
		popd > /dev/null
	done

	echo -e "\nExhausted all candidate directories and could run simv." >> $1
	echo -e "\nSomewhere in your repository should be a file called 'Makefile' that" >> $1
	echo "is capable of building the target 'simv'. The program simv should then be" >> $1
	echo "able to be run an Alpha program image." >> $1
	echo -e "\nIf you have not yet finished P3, review the messages above and ensure" >> $1
	echo "that everything you think should be working is working" >> $1
	echo -e "\nIf you think there is an error, please email the **exact** steps" >> $1
	echo "to check out your repository, make a copy of simv, and run a test program." >> $1
	return 1;
}

while read uniq; do
	uniq=`echo $uniq | tr [:upper:] [:lower:]`
	path="${ROOT}/${uniq:0:1}/${uniq:1:1}/${uniq}/${SVN_PATH}"

	printf "$uniq          \r"

	let "total += 1"

	file="$(pwd)/${MAILS}/${uniq}@umich.edu"

	cat >> $file << EOF
This is an automated script designed to validate staff access to your subversion
repository. Please ensure it completed successfully or correct any errors. We
will run this script once more late Tuesday night.

EOF

#	echo -n "Testing for directory $path -- " >> $file

#	if [ -d $path ]; then
#		let "found += 1"
#		echo "SUCCESS" >> $file
#	else
#		let "missing += 1"
#		echo "MISSING: $path"
#		echo "FAILED" >> $file
#		continue
#	fi

	echo -ne "\nAttempting to check out svn repo at $path -- " >> $file

	out=$(svn co file://$path ${T_DIR}/${uniq}/ 2>&1)
	if [ $? -eq 0 ]; then
		echo "SUCCESS" >> $file
	else
		echo "FAILED" >> $file
		echo "$out" >> $file

		path="${path}/470_repo"
		echo -ne "\nAttempting to check out svn repot at $path -- " >> $file
		out=$(svn co file://$path ${T_DIR}/${uniq}/ 2>&1)
		if [ $? -eq 0 ]; then
			echo "SUCCESS" >> $file
		else
			echo "FAILED" >> $file
			echo "$out" >> $file
			let "missing += 1"
			continue
		fi
	fi

	echo -ne "\nGrabbing most recent commit message -- " >> $file

	pushd ${T_DIR}/${uniq} > /dev/null
	out=$(svn log -l 1 2>&1)
	if [ $? -eq 0 ]; then
		echo "SUCCESS" >> $file
		echo "This was the most recent commit message when I grabbed your repo:" >> $file
		echo "$out" >> $file
		echo "I pulled at `date`" >> $file
	else
		echo "FAILED" >> $file
		echo "$out" >> $file
		popd > /dev/null
		continue
	fi

	# At this point we are still push'd in the repo directory

	echo -e "\nLooking for a Makefile that knows how to build simv... " >> $file
	if ! find_make $file; then
		echo -e "\nERROR! Could not find a Makefile that knows how to build simv" >> $file
		popd > /dev/null
		continue
	fi

	# At this point we are still pushd'd in the project directory and repo directory

	echo -ne "\nBuilding simv... " | tee -a $file
	make nuke >& /dev/null
	make_out=$(make simv 2>&1)
	if [ $? -ne 0 ]; then
		echo "FAILED" | tee -a $file
		echo -e "'make simv' output:\n$make_out" >> $file
		popd > /dev/null # proj dir
		popd > /dev/null # repo dir
		continue
	else
		echo "SUCCESS" | tee -a $file
	fi

	echo -e "\nRunning some basic tests...\n" | tee -a $file

	append_me=

	for prog in `ls $TESTS_DIR/*.bin`; do
		cp $prog program.mem
		prog=$(echo ${prog##*/} | cut -d'.' -f1)
		echo "Testing $prog:" | tee -a $file
		./simv | grep '@@@' > program.out

		append_me="${append_me}$(echo -e \\n$prog.program.out diff:\\n\\n)"
		diff_out="$(grep '@@@' $TESTS_DIR/$prog.program.out | diff program.out - -y)"
		if [ $? -ne 0 ]; then
			echo -e "\tWARN: $prog.program.out does not match solution (diff at end)" | tee -a $file
			append_me="${append_me}${diff_out}"
		else
			echo -e "\t$prog.program.out matches solution" >> $file
		fi

		append_me="${append_me}$(echo -e \\n$prog.writeback.out diff:\\n\\n)"
		diff_out="$(diff writeback.out $TESTS_DIR/$prog.writeback.out -y)"
		if [ $? -ne 0 ]; then
			echo -e "\tWARN: $prog.writeback.out does not match solution (diff at end)" | tee -a $file
			append_me="${append_me}${diff_out}"
		else
			echo -e "\t$prog.writeback.out matches solution" >> $file
		fi

#		append_me="${append_me}$(echo -e \\n$prog.pipeline.out diff:)"
#		append_me="${append_me}$(diff $TESTS_DIR/pipeline.out $prog.pipeline.out -y)"
#		if [ $? -ne 0 ]; then
#			echo -e "\tWARN: $prog.pipeline.out does not match solution (diff at end)" | tee -a $file
#		else
#			echo -e "\t$prog.pipeline.out matched solution" >> $file
#		fi
	done

	popd > /dev/null # proj dir
	popd > /dev/null # repo dir

	cat >> $file << EOF



================================================================================

This is the end of the automated script. If you have reached this far, we can
successfully check out and test your project. As a courtesy we have tested a few
of the supplied programs and indicated whether your processor is currently doing
the correct thing or not.

================================================================================

Begin diffs:

EOF

	echo "$append_me" >> $file

	let "success += 1"
	echo $uniq >> successes.txt
done < $UNIQS

echo
echo "============"
echo "  Total: $total"
echo "Missing: $missing"
echo "Success: $success"
