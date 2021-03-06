`timescale 1ns/1ns

module testbench;
  reg [3:0] a4;
  reg [3:0] b4;
  wire [3:0] o_csa4;
  wire [3:0] o_cla4;
  
  reg [7:0] a8;
  reg [7:0] b8;
  wire [7:0] o_csa8;
  wire [7:0] o_cla8;
  
  //CSA4 mcsa4(o_csa4, a4, b4);
  CLA4 mcla4(o_csa4, a4, b4);
  
  //CSA8 mcsa8(o_csa8, a8, b8);
  //CLA8 mcla8(o_cla8, a8, b8);
  
  always begin
    #0 a4=4'b0101; b4=4'b0110; a8=0; b8=0;
    #1 a4=4'b0000; b4=4'b1111; a8=0; b8=0;
    #1 a4=4'b1100; b4=4'b0011; a8=0; b8=0;
    #1 a4=0; b4=0; a8=0; b8=0;
    #1 a4=0; b4=0; a8=0; b8=0;
    #1 a4=0; b4=0; a8=0; b8=0;
    #1 a4=0; b4=0; a8=0; b8=0;
    #1 a4=0; b4=0; a8=0; b8=0;
  end
  
endmodule
