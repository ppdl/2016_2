`timescale 1ps/1ps

module mnot(O,A);
  input A;
  output O;
  assign #50 O=~A;
endmodule
