Verilog Code Classification

1. Arithmetic Modules
    - Adder
        - adder_8bit
        - adder_16bit
        - adder_32bit
        - adder_pipe_64bit
        - **adder_bcd**
    - Substractor
        - **sub_64bit**
    - Multiplier
        - **multi_8bit**
        - multi_16bit
        - multi_booth_8bit
        - multi_pipie_4bit
        - multi_pipie_8bit
    - Divider
        - div_16bit
        - radix2_div
    - Comparator
        - **comparator_3bit**
        - **comparator_4bit**
    - Accumulator
        - accu
    - Other Units
        - **fixed_point_adder**
        - **fixed_point_substractor**
        - **float_multi**

2. Memory Modules
    - FIFO (First-In, First-Out)
        - asyn_fifo
    - LIFO (Last-In, First-Out)
        - **LIFObuffer**
    - Shifter
        - right_shifter
        - **LFSR**
        - **barrel_shifter**

3. Control Modules
    - Finite State Machine (FSM)
        - fsm
        - **sequence_detector**
    - Counter
        - counter_12
        - JC_counter
        - **ring_counter**
        - **up_down_counter**

4. Miscellaneous Modules
    - Signal generation
        - signal_generator
        - **square_wave**
    - RISC-V
        - **clkgenerator**
        - **instr_reg**
        - **ROM**
        - RAM 
        - alu
        - pe
    - Frequency divider
        - freq_div
        - **freq_divbyeven**
        - **freq_divbyodd**
        - **freq_divbyfrac**
    - Others
        - calendar
        - traffic_light
        - width_8to16
        - synchronizer
        - edge_detect
        - pulse_detect
        - parallel2serial
        - serial2parallel


