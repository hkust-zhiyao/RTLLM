// module chatgpt_generate_adder_64bit(
//     input         clk,
//     input         rst_n,
//     input         i_en,
//     input  [63:0] adda,
//     input  [63:0] addb,
//     output [64:0] result,
//     output reg    o_en
// );

// reg [63:0] stage1_adda;
// reg [63:0] stage1_addb;
// reg        stage1_en;
// reg [64:0] stage2_result;
// reg [64:0] stage3_result;

// always @(posedge clk or negedge rst_n) begin
//     if (~rst_n) begin
//         stage1_adda <= 0;
//         stage1_addb <= 0;
//         stage1_en   <= 0;
//         stage2_result <= 0;
//         stage3_result <= 0;
//         o_en        <= 0;
//     end else begin
//         stage1_adda <= adda;
//         stage1_addb <= addb;
//         stage1_en   <= i_en;

//         if (stage1_en) begin
//             stage2_result <= {1'b0, stage1_adda} + {1'b0, stage1_addb};
//             stage3_result <= stage2_result;
//             o_en <= 1;
//         end else begin
//             o_en <= 0;
//         end
//     end
// end

// assign result = stage3_result;

// endmodule

// GPT4-1
// `define DATA_WIDTH 64
// `define STG_WITCH 16
// module chatgpt_generate_adder_64bit
// (
//     input clk,
//     input rst_n,
//     input i_en,
//     input [DATA_WIDTH-1:0] adda,
//     input [DATA_WIDTH-1:0] addb,
//     output [DATA_WIDTH:0] result,
//     output reg o_en
// );

//     reg [DATA_WIDTH-1:0] a_reg [0:3];
//     reg [DATA_WIDTH-1:0] b_reg [0:3];
//     wire [DATA_WIDTH:0] sum [0:3];
//     genvar i;
    
//     always @(posedge clk or negedge rst_n) begin
//         if (~rst_n) begin
//             a_reg[0] <= 0;
//             b_reg[0] <= 0;
//             o_en <= 0;
//         end else if (i_en) begin
//             a_reg[0] <= adda;
//             b_reg[0] <= addb;
//             for (i = 1; i < 4; i = i + 1) begin
//                 a_reg[i] <= a_reg[i-1];
//                 b_reg[i] <= b_reg[i-1];
//             end
//             o_en <= 1;
//         end else begin
//             for (i = 1; i < 4; i = i + 1) begin
//                 a_reg[i] <= a_reg[i-1];
//                 b_reg[i] <= b_reg[i-1];
//             end
//             o_en <= 0;
//         end
//     end

//     generate
//         for(i=0; i<4; i=i+1) begin : adder_gen
//             assign sum[i] = {1'b0, a_reg[i][i*STG_WITCH+:STG_WITCH]} + {1'b0, b_reg[i][i*STG_WITCH+:STG_WITCH]} + sum[i-1][i*STG_WITCH+STG_WITCH:STG_WITCH];
//         end
//     endgenerate
    
//     assign result = sum[3];
    
// endmodule


module chatgpt_generate_adder_64bit 
#(
    parameter           DATA_WIDTH = 64,
    parameter           STG_WITCH  = 16
)
(
    input clk,
    input rst_n,
    input i_en,
    input [DATA_WIDTH-1:0] adda,
    input [DATA_WIDTH-1:0] addb,
    output [DATA_WIDTH:0] result, 
    output reg o_en
);

    reg [STG_WITCH-1:0] stage_input_adda [0:3];
    reg [STG_WITCH-1:0] stage_input_addb [0:3];
    wire [STG_WITCH:0] stage_output [0:3];
    reg [STG_WITCH-1:0] stage_output_reg [0:3]; 

    genvar i;
    
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            {stage_input_adda[3], stage_input_adda[2], stage_input_adda[1], stage_input_adda[0]} <= 0;
            {stage_input_addb[3], stage_input_addb[2], stage_input_addb[1], stage_input_addb[0]} <= 0;
            o_en <= 0;
        end else if (i_en) begin
            {stage_input_adda[3], stage_input_adda[2], stage_input_adda[1], stage_input_adda[0]} <= adda;
            {stage_input_addb[3], stage_input_addb[2], stage_input_addb[1], stage_input_addb[0]} <= addb;
            o_en <= 1;
        end else begin
            o_en <= 0;
        end
    end

    generate
        for(i=0; i<4; i=i+1) begin : adder_gen
            assign stage_output[i] = {1'b0, stage_input_adda[i]} + {1'b0, stage_input_addb[i]} + (i==0 ? 0 : stage_output_reg[i-1][STG_WITCH]);
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) stage_output_reg[i] <= 0;
                else if (i_en) stage_output_reg[i] <= stage_output[i];
            end
        end
    endgenerate
    
    assign result = {stage_output_reg[3], stage_output_reg[2], stage_output_reg[1], stage_output_reg[0]};
    
endmodule