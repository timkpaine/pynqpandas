`timescale 1ns/1ns

class transaction;
    /* transaction models the hardware in non-synthesizeable sv */

    int cmd;
    int fx1;
    int fx2;
    int fxout;

    bit valid;

    /* testing fixed point operations */
    function void drive_fxop( int op, int in1, int in2 );
        cmd = op;
        fx1 = in1;
        fx2 = in2;
    endfunction :drive_fxop
 
    
    /* drive reset on input */
    function void drive_reset();
        return; // don't need to do anything yet
    endfunction : drive_reset

    /* this checks that reset functions properly */
    function bit check_reset( int o, bit val );
        return ( o == 0 ) && ( val == 0 );
    endfunction : check_reset

    function bit check_fx_op( int out, bit val ); 
        case( cmd )
            NOOP: begin
                // do nothing
                valid = 0;
            end
        endcase
      return ( fxout == out ) && ( val == valid );
    endfunction : check_fx_op

    function bit check_noop( int out, bit val );
        return ( ( out == fxout ) | ( out == fpout ) ) && ( val == 0 );
    endfunction : check_noop
    
endclass


