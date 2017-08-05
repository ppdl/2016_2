`timescale 1ps/1ps

module mnor2(O,A,B);
  input A,B;
  output O;
  assign #100 O=~(A|B);
endmodule
