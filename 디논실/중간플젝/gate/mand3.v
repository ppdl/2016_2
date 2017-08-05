`timescale 1ps/1ps

module mand3(O,A,B,C);
  input A,B,C;
  output O;
  assign #170 O=A&B&C;
endmodule
