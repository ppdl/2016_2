library verilog;
use verilog.vl_types.all;
entity mnor is
    port(
        o               : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic
    );
end mnor;
