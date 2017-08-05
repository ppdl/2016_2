`timescale 1ps/1ps

module mxor2(O,A,B);
  input A,B;
  output O;
  assign #140 O=A^B;
endmodule
