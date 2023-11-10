import os
import time

design_name = ['accu', 'adder_8bit', 'adder_16bit', 'adder_32bit', 'asyn_fifo', 'calendar', 'counter_12', 'edge_detect',
               'freq_div', 'fsm', 'Johnson_Counter', 'multi_booth', 'multi_pipe', 'mux', 'parallel2serial', 'pulse_detect',
               'RAM', 'right_shifter', 'serial2parallel', 'signal_generator', 'width_8to16','adder_64bit', 'alu', 'div_16bit', 'multi_16bit', 'multi_pipe_8bit', 'pe']#,
	       #'radix2_div', 'traffic_light']

path = "."

syntax_success = 0
func_success = 0

for design in design_name:
    if os.path.exists(f"{design}/makefile"):
        makefile_path = os.path.join(design, "makefile")
        with open(makefile_path, "r") as file:
            makefile_content = file.read()
            modified_makefile_content = makefile_content.replace("${TEST_DESIGN}", f"{path}/{design}/{design}")
            # modified_makefile_content = makefile_content.replace(f"{path}/{design}/{design}", "${TEST_DESIGN}")
        with open(makefile_path, "w") as file:
            file.write(modified_makefile_content)
        # Run 'make vcs' in the design folder
        os.chdir(design)
        os.system("make vcs")

        # Wait for simv file to be generated
        simv_generated = False
        for _ in range(3):  # Try for 3 seconds
            if os.path.exists("simv"):
                simv_generated = True
                break
            time.sleep(1)

        if simv_generated:
            syntax_success += 1
            # Run 'make sim' and check the result
            os.system("make sim > output.txt")
            with open("output.txt", "r") as file:
                output = file.read()
                if "Pass" in output or "pass" in output:
                    func_success += 1
        
        with open("makefile", "w") as file:
            file.write(makefile_content)
        os.chdir("..")

print(f"Syntax Success: {syntax_success}/{len(design_name)}")
print(f"Functional Success: {func_success}/{len(design_name)}")