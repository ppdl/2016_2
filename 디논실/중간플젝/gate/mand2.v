`timescale 1ps/1ps

module mand2(O,A,B);
  input A,B;
  output O;
  assign #120 O=A&B;
endmodule
