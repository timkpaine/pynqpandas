`timescale 1ns/1ns
`ifndef ENV
`define ENV

class testing_env;
    rand int unsigned rn;
    rand int in1;
    rand int in2;
    
`ifndef CC_VCS
    function void modelsim_randomize();
        rn =  $random();
        in1 = $random();
        in2 = $random();
    endfunction : modelsim_randomize
`endif

    int reset_thresh;
    bit reset;

    int op_thresh;
    int op;

    int iter;

    function void read_config( string filename );
        int file, chars_returned, seed, value;
        string param;
        file = $fopen( filename, "r" );

        while( ! $feof( file ) ) begin
            chars_returned = $fscanf( file, "%s %d", param, value );
            if( "RANDOM_SEED" == param ) begin
                seed = value;
`ifdef CC_VCS
                $srandom( seed );
`endif
            end else if( "ITERATIONS" == param ) begin
                iter = value;
            end else if( "RESET_PROB" == param ) begin
                reset_thresh = value;
            end else if( "OP_PROB" == param ) begin
                op_thresh = value;
            end else begin
              $display( "Invalid parameter - %s", param );
                $finish();
            end
        end
    endfunction

    function bit get_reset();
        return( ( rn % 1000 ) < reset_thresh );
    endfunction

    function int get_op();
        int val = ( rn % 1000 );
        if ( val  < op_thresh ) begin
            // choose op
            if ( val <  ( op_thresh / 4 ) ) begin
                return ADD;
            end else begin
                return NOOP;
            end
        end else begin
            return 0;
        end
    endfunction
endclass
`endif