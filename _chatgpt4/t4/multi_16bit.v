module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // Internal signals
    reg [31:0] product;
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [4:0] count; // 16-bit multiplier requires a 5-bit counter

    // Control FSM states
    localparam IDLE = 0, MULTIPLY = 1, DONE = 2;
    reg [1:0] state;

    // FSM for controlling the multiplication process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Synchronous reset
            state <= IDLE;
            product <= 0;
            multiplicand <= 0;
            multiplier <= 0;
            count <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        multiplicand <= ain;
                        multiplier <= bin;
                        product <= 0;
                        count <= 0;
                        state <= MULTIPLY;
                        done <= 0;
                    end
                end
                MULTIPLY: begin
                    if (count < 16) begin
                        // Perform shift and add
                        if (multiplier[0]) begin
                            product <= product + (multiplicand << count);
                        end
                        multiplier <= multiplier >> 1;
                        count <= count + 1;
                    end else begin
                        state <= DONE;
                    end
                end
                DONE: begin
                    // Multiplication done, assert done signal
                    done <= 1;
                    state <= IDLE; // Optionally, go back to IDLE or wait for a reset or a new start
                end
                default: state <= IDLE;
            endcase
        end
    end

    // Assign the output
    always @(posedge clk) begin
        if (state == DONE) begin
            yout <= product; // Assign the product to output when done
        end
    end

endmodule