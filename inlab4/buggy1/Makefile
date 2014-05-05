# Stripped down Makefile

VCS = SW_VCS=2011.03 vcs +v2k +vc -Mupdate -line -full64
LIB = /afs/engin.umich.edu/caen/generic/mentor_lib-D.1/public/eecs470/verilog/lec25dscc25.v
TEST = isr_test.v
VG = ISR.vg

test: simv
	./simv

simv: $(TEST) $(VG) $(LIB)
	$(VCS) $^ -o $@

dve:	$(TEST) $(VG) $(LIB)
	$(VCS) +memcbk $^ -o dve -R -gui

clean:
	rm -rvf simv *.daidir csrc vcs.key program.out \
	  syn_simv syn_simv.daidir syn_program.out \
	  int_simv int_simv.daidir syn_int_simv syn_int_simv.daidir \
          dve *.vpd *.vcd *.dump ucli.key 

.PHONY: test clean
