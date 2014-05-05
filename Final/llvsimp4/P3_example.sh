#!/bin/bash

# Setup your configuration variables

assemble=./vs-asm
copy=cp

# Build a fresh simv
#echo "> Building simv..."
#make_out=$(make simv 2>&1)
# Redirect stdout->stderr and capture
# both in the variable make_out
#if [ $? -ne 0 ]; then
  # if make fails...
#  echo "> Building simv failed!"
#  echo "$make_out"
  # These quotes are important to
  # preserve whitespace in the output
#fi
#echo "> simv is built"

# Run all the test cases
echo "> Running regressions..."
for file in `ls test_progs`;
do 
  file=$(echo $file | cut -d'.' -f1);
  $assemble ./test_progs/$file.s > ./test_mems/$file.mem;
  $copy ./test_mems/$file.mem ./program.mem
  simv_out=$(./syn_simv | tee program.out 2>&1)
  $copy writeback.out ./log/$file.writeback.gold.out; 
  $copy program.out ./log/$file.program.gold.out; 
done
echo "> Finished running regressions."



# Print the results!
