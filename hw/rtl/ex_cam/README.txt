To build fftestbench.exe for part 1, run:
$ make ffbench

To build camtestbench.exe for all subsequent parts, run:
$ make cambench

(1) There are only two elements of functionality to check for the flip flop. We want to make sure that on reset, the output is driven to 0. We also want to check that if I drive a value A on cycle n, the output is A on cycle n+1. Both of these are validated in the flip flop test bench.

(2) The skeleton for the CAM contains a software model of the CAM and the check* and golden_output* functions called “transaction”, an environment setup and number generator called testing_env, and the test bench program itself. In total this was around 100 lines of code in the test bench, as well as creating an interface file and cam_top file modeled off the ones we looked at in class. We also needed to modify the CAM to work with the interface, and correct the issues from lab 1. There were no specific issues here, but we did learn that in addition to “rand int var_name”, you can use constructs from system verilog as random numbers, like “rand logic[4:0] var_name”, which we used to generate the indices for reads and writes. 

(3) We started with the Makefile given for the flip flop example and modified it to support the cam. This didn’t require too much, but we did need to add the other sv files, like priority encoder and register, to the compile statement. This took maybe 6 lines of additional code, copied from the flip flop examples and modified. 


(4) We tested reset in multiple parts. For this part, the only thing we could really do was check that the reset drives the initial x outputs to 0s. However, once we implemented read/write functionality, we could also test that reset properly reset the valid bits in the CAM. This took around 20 lines in cam_tb, writing both the check_reset function for the transaction and deciding how frequently to run reset in the test bench program. 


(5) This took the majority of the work, and around 50 lines of code. We needed to make sure that the timing was correct, i.e. if we read from an index we are writing to, we need to take into account the clock cycle delay. One bug we had was that during writes, we stored the previous value in a temp variable that way we could check it if we did a read on the same iteration. However, we didn’t overwrite it, so a read coming several cycles after a write would still match the temporary variable. So we added a clock_tic function which flushes that temp variable, signifying that a written variable has clobbered the value in the cam, and call this at the end of every iteration. This solves the bug. 


(6) After doing read/write, search was easy, as it is essentially the same thing as read (in terms of things like how its timing works, etc). This took maybe 25 lines of code. We had no notable bugs for this section. 



(7) We didn’t really find any bugs here, but it was cool to monitor the outputs and see all of the possible combinations of tests we were performing, which we would never have been able to manually program. We also were randomly asserting resets, which we didn’t do in our simple test bench. Its clear that this is a way more robust form of testing.



(8) Again, no more bugs here. In our config file, we set thresholds that are out of 1000. I.e. if READ_PROB is 600, than there is a 60% chance that we are going to read a random index in the current cycle. We set the threshold for read, write, and search relatively high, because we want to make sure these all work concurrently. We also set the value of reset around 10%, to make sure our system can handle intermittent resets. 

