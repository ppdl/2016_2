library verilog;
use verilog.vl_types.all;
entity mand is
    port(
        o               : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic
    );
end mand;
