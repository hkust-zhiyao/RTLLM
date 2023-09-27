// module verified_adder_8bit(
//     input [7:0] a, b,input cin,
//     output [7:0] sum,
//     output cout
// );
// wire c1, c2, c3, c4, c5, c6, c7;
// full_adder f0(a[0], b[0], cin, sum[0], c1);
// full_adder f1(a[1],b[1],c1, sum[1],c2);
// full_adder f2(a[2],b[2], c2,sum[2],c3);
// full_adder f3(a[3], b[3], c3, sum[3], c4);
// full_adder f4(a[4],b[4],c4,sum[4],c5);
// full_adder f5(a[5],b[5], c5,sum[5],c6);
// full_adder f6(a[6],b[6], c6, sum[6], c7);
// full_adder f7(a[7], b[7], c7, sum[7], cout);

// endmodule

// module full_adder(
//     input a, b, cin,
//     output sum, cout
// );
//     assign sum = a ^ b ^ cin;
//     assign cout= (a & b)|(cin & (a^ b)); 
// endmodule

module verified_adder_8bit(
    input [7:0] a, b, 
    input cin, output [7:0] sum, 
    output SUM, 
    output cout);
    
    wire [8:0] c;

    full_adder FA0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c[0]));
    full_adder FA1 (.a(a[1]), .b(b[1]), .cin(c[0]), .sum(sum[1]), .cout(c[1]));
    full_adder FA2 (.a(a[2]), .b(b[2]), .cin(c[1]), .sum(sum[2]), .cout(c[2]));
    full_adder FA3 (.a(a[3]), .b(b[3]), .cin(c[2]), .sum(sum[3]), .cout(c[3]));
    full_adder FA4 (.a(a[4]), .b(b[4]), .cin(c[3]), .sum(sum[4]), .cout(c[4]));
    full_adder FA5 (.a(a[5]), .b(b[5]), .cin(c[4]), .sum(sum[5]), .cout(c[5]));
    full_adder FA6 (.a(a[6]), .b(b[6]), .cin(c[5]), .sum(sum[6]), .cout(c[6]));
    full_adder FA7 (.a(a[7]), .b(b[7]), .cin(c[6]), .sum(sum[7]), .cout(c[7]));

    assign cout = c[7]; 
    assign SUM = sum[7];
endmodule

module full_adder (input a, b, cin, output sum, cout);
    assign {cout, sum} = a + b + cin;
endmodule