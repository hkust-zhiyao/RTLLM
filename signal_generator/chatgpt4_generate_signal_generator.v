module chatgpt4_generate_signal_generator(
    input clk,
    input rst_n,
    input [1:0] wave_choise,
    output reg [4:0] wave
);

    reg [4:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 5'd0;
            wave <= 5'd0;
        end else begin
            counter <= counter + 1;
            case (wave_choise)
                2'b00: wave <= counter[4]; // square wave
                2'b01: wave <= counter; // sawtooth wave
                2'b10: begin // triangular wave
                    if (counter < 16)
                        wave <= counter;
                    else
                        wave <= ~counter;
                end
                default: wave <= 5'd0;
            endcase
        end
    end

endmodule 