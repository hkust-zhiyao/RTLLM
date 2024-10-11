module verified_adder_32bit(A,B,S,C32);
     input [32:1] A;
     input [32:1] B;
     output [32:1] S;
     output C32;

     wire px1,gx1,px2,gx2;
     wire c16;

  CLA_16 CLA1(
      .A(A[16:1]),
        .B(B[16:1]),
        .c0(0),
        .S(S[16:1]),
        .px(px1),
        .gx(gx1)
    );

  CLA_16 CLA2(
        .A(A[32:17]),
          .B(B[32:17]),
          .c0(c16),
          .S(S[32:17]),
          .px(px2),
          .gx(gx2)
    );

  assign c16 = gx1 ^ (px1 && 0), //c0 = 0
         C32 = gx2 ^ (px2 && c16);
endmodule

module CLA_16(A,B,c0,S,px,gx);
    input [16:1] A;
    input [16:1] B;
    input c0;
    output gx,px;
    output [16:1] S;

    wire c4,c8,c12;
    wire Pm1,Gm1,Pm2,Gm2,Pm3,Gm3,Pm4,Gm4;

    adder_4 adder1(
         .x(A[4:1]),
          .y(B[4:1]),
          .c0(c0),
          .c4(),
          .F(S[4:1]),
          .Gm(Gm1),
          .Pm(Pm1)
    );

    adder_4 adder2(
         .x(A[8:5]),
          .y(B[8:5]),
          .c0(c4),
          .c4(),
          .F(S[8:5]),
          .Gm(Gm2),
          .Pm(Pm2)
    );

    adder_4 adder3(
         .x(A[12:9]),
          .y(B[12:9]),
          .c0(c8),
          .c4(),
          .F(S[12:9]),
          .Gm(Gm3),
          .Pm(Pm3)
    );

    adder_4 adder4(
         .x(A[16:13]),
          .y(B[16:13]),
          .c0(c12),
          .c4(),
          .F(S[16:13]),
          .Gm(Gm4),
          .Pm(Pm4)
    );

    assign   c4 = Gm1 ^ (Pm1 & c0),
             c8 = Gm2 ^ (Pm2 & Gm1) ^ (Pm2 & Pm1 & c0),
             c12 = Gm3 ^ (Pm3 & Gm2) ^ (Pm3 & Pm2 & Gm1) ^ (Pm3 & Pm2 & Pm1 & c0);

    assign  px = Pm1 & Pm2 & Pm3 & Pm4,
            gx = Gm4 ^ (Pm4 & Gm3) ^ (Pm4 & Pm3 & Gm2) ^ (Pm4 & Pm3 & Pm2 & Gm1);
endmodule

module adder_4(x,y,c0,c4,F,Gm,Pm);
      input [4:1] x;
      input [4:1] y;
      input c0;
      output c4,Gm,Pm;
      output [4:1] F;

      wire p1,p2,p3,p4,g1,g2,g3,g4;
      wire c1,c2,c3;
      adder adder1(
                 .X(x[1]),
                     .Y(y[1]),
                     .Cin(c0),
                     .F(F[1]),
                     .Cout()
                );

      adder adder2(
                 .X(x[2]),
                     .Y(y[2]),
                     .Cin(c1),
                     .F(F[2]),
                     .Cout()
                );  

      adder adder3(
                 .X(x[3]),
                     .Y(y[3]),
                     .Cin(c2),
                     .F(F[3]),
                     .Cout()
                );

      adder adder4(
                 .X(x[4]),
                     .Y(y[4]),
                     .Cin(c3),
                     .F(F[4]),
                     .Cout()
                );      

        CLA CLA(
            .c0(c0),
            .c1(c1),
            .c2(c2),
            .c3(c3),
            .c4(c4),
            .p1(p1),
            .p2(p2),
            .p3(p3),
            .p4(p4),
            .g1(g1),
            .g2(g2),
            .g3(g3),
            .g4(g4)
        );



  assign   p1 = x[1] ^ y[1],      
           p2 = x[2] ^ y[2],
           p3 = x[3] ^ y[3],
           p4 = x[4] ^ y[4];

  assign   g1 = x[1] & y[1],
           g2 = x[2] & y[2],
           g3 = x[3] & y[3],
           g4 = x[4] & y[4];

  assign Pm = p1 & p2 & p3 & p4,
         Gm = g4 ^ (p4 & g3) ^ (p4 & p3 & g2) ^ (p4 & p3 & p2 & g1);
endmodule

module CLA(c0,c1,c2,c3,c4,p1,p2,p3,p4,g1,g2,g3,g4);

     input c0,g1,g2,g3,g4,p1,p2,p3,p4;
     output c1,c2,c3,c4;

     assign c1 = g1 ^ (p1 & c0),
            c2 = g2 ^ (p2 & g1) ^ (p2 & p1 & c0),
            c3 = g3 ^ (p3 & g2) ^ (p3 & p2 & g1) ^ (p3 & p2 & p1 & c0),
            c4 = g4^(p4&g3)^(p4&p3&g2)^(p4&p3&p2&g1)^(p4&p3&p2&p1&c0);
endmodule

module adder(X,Y,Cin,F,Cout);

  input X,Y,Cin;
  output F,Cout;

  assign F = X ^ Y ^ Cin;
  assign Cout = (X ^ Y) & Cin | X & Y;
endmodule