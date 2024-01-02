.PHONY: vcs sim clean

TEST_DESIGN = freq_div

vcs:
		vcs -sverilog +v2k -timescale=1ns/1ns       \
		-debug_all         							\
		-l compile.log 								\
		/home/coguest/luyao/SmallDesigns/chatgpt35/t5/freq_div.v testbench.v

sim:
		./simv -l run.log

clean:
		rm -rf *.log  csrc  simv*  *.key *.vpd  DVEfiles coverage *.vdb output.txt
