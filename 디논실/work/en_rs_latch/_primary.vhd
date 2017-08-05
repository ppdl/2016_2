library verilog;
use verilog.vl_types.all;
entity en_rs_latch is
    port(
        S               : in     vl_logic;
        R               : in     vl_logic;
        Enb             : in     vl_logic;
        Q               : out    vl_logic;
        QN              : out    vl_logic
    );
end en_rs_latch;
