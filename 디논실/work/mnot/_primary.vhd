library verilog;
use verilog.vl_types.all;
entity mnot is
    port(
        o               : out    vl_logic;
        a               : in     vl_logic
    );
end mnot;
