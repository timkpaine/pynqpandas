`timescale 1ns/1ns

class transaction;
    /* transaction models the hardware in non-synthesizeable sv */
    int cmd;
    int in1;
    int in2;
    int out;

    bit valid;

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
    function bit check_reset( int o, bit val );
        return ( o == 0 ) && ( val == 0 );
    endfunction : check_reset

    function bit check_op( int o, bit val ); 
        case( cmd )
            NOOP: begin
                // do nothing
                valid = 0;
            end
        endcase
      return ( out == o ) && ( val == valid );
    endfunction : check_op

    function bit check_noop( int o, bit val );
        return ( ( out == o ) | ( o == out ) ) && ( val == 0 );
    endfunction : check_noop
    
endclass


