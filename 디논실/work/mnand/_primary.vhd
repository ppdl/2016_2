library verilog;
use verilog.vl_types.all;
entity mnand is
    port(
        o               : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic
    );
end mnand;
