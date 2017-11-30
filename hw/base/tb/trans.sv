`timescale 1ns/1ns
`ifndef TRANS
`define TRANS

class transaction;
    /* transaction models the hardware in non-synthesizeable sv */
    int cmd;
    int in1;
    int in2;
    int out;

    /* testing fixed point operations */
    function void drive_op( int op, int i1, int i2 );
        cmd = op;
        in1 = i1;
        in2 = i2;
    endfunction :drive_op

    /* drive reset on input */
    function void drive_reset();
        return; // don't need to do anything yet
    endfunction : drive_reset

    /* this checks that reset functions properly */
    function bit check_reset( bit o );
        return(o == 0 );
    endfunction : check_reset

    /* check reset on output */
    function bit check_not_reset( bit o );
        return(o == 1 );
    endfunction : check_not_reset

    function bit check_op( int o ); 
        case( cmd )
            NOOP: begin
                // do nothing
            end
            ADD: begin
                out = in1 + in2;
            end
        endcase
      return ( out == out );
    endfunction : check_op

    function bit check_noop( int out );
        return ( out == out );
    endfunction : check_noop
  
endclass
`endif
