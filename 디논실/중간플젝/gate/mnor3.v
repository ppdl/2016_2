`timescale 1ps/1ps

module mnor3(O,A,B,C);
  input A,B,C;
  output O;
  assign #150 O=~(A|B|C);
endmodule
