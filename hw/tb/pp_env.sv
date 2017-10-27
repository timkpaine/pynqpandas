`timescale 1ns/1ns

/* these are used to determine how frequently
 * to run a read/write/search/reset op
 */
class testing_env;
    rand int unsigned rn;
    rand int fx1;
    rand int fx2;
    
`ifdef CC_MODELSIM
    function void modelsim_randomize();
        rn =  $random();
        fx1 = $random();
        fx2 = $random();
    endfunction : modelsim_randomize
`endif

    int reset_thresh;
    bit reset;

    int fxop_thresh;
    int fxop;

    int iter;

    function void read_config( string filename );
        int file, chars_returned, seed, value;
        string param;
        file = $fopen( filename, "r" );

        while( ! $feof( file ) ) begin
            chars_returned = $fscanf( file, "%s %d", param, value );
            if( "RANDOM_SEED" == param ) begin
                seed = value;
`ifdef CC_MODELSIM

`else
                $srandom( seed );
`endif
            end else if( "ITERATIONS" == param ) begin
                iter = value;
            end else if( "RESET_PROB" == param ) begin
                reset_thresh = value;
            end else if( "FXOP_PROB" == param ) begin
                fxop_thresh = value;
            end else begin
              $display( "Invalid parameter - %s", param );
                $exit();
            end
        end
    endfunction

    function bit get_reset();
        return( ( rn % 1000 ) < reset_thresh );
    endfunction

    function int get_fxop();
        int val = ( rn % 1000 );
        if ( val  < fxop_thresh ) begin
            // choose op
          return NOOP;
        end else begin
            return 0;
        end
    endfunction

endclass


