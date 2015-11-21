module allTestBenchesHarness();

//wire to start all tests
reg startTests;
reg allTestsPass;

//wires for success and testdone on the datamemory module
wire dataMemoryDUT;
wire dataMemoryDone;

wire registerFileDUT;
wire registerFileDone;

wire instructionDecoderDUT;
wire instructionDecoderDone;

wire mux32DUT;
wire mux32Done;

wire mux5DUT;
wire mux5Done;

wire pcDUT;
wire pcDone;

wire raDUT;
wire raDone;

wire aluDUT;
wire aluDone;

//set up the test bench harness for the data memory
datamemorytestbenchharness dataMemoryTester(
  .dutPassed(dataMemoryDUT),
  .testDone(dataMemoryDone),
  .startTests(startTests)
);


//harness for register file
registerfiletestbenchharness registerFileTester(
.dutPassed(registerFileDUT),
.testDone(registerFileDone),
.startTests(startTests)
);

//harness for instruction decoder
instructiondecodertestharness instructionDecoderTester(
.dutPassed(instructionDecoderDUT),
.testDone(instructionDecoderDone),
.startTests(startTests)
);


//harness for 32 bit 2:1 mux
mux32testharness mux32Tester(
.dutPassed(mux32DUT),
.testDone(mux32Done),
.startTests(startTests)
);

//harness for 5 bit 2:1 mux
mux5testharness mux5Tester(
.dutPassed(mux5DUT),
.testDone(mux5Done),
.startTests(startTests)
);

//harness for pc register
pc_register_test_bench_harness pcTester(
.dutPassed(pcDUT),
.testDone(pcDone),
.startTests(startTests)
);

//harness for ra register
ra_register_test_bench_harness raTester(
.dutPassed(raDUT),
.testDone(raDone),
.startTests(startTests)
);

//harness for alu
alu_test_bench_harness aluTester(
.dutPassed(aluDUT),
.testDone(aluDone),
.startTests(startTests)
);

//now when datamemory test is done, check our succes wire
always @(posedge dataMemoryDone) begin
    $display("datamemory DUT passed?: %b", dataMemoryDUT);
    if (dataMemoryDUT === 0) begin
	$display("data memory failed tests");
    	allTestsPass <= 0; 
    end
end


//now when register file test is done, check our succes wire
always @(posedge registerFileDone) begin
    $display("registerFile DUT passed?: %b", registerFileDUT);
    if (registerFileDUT === 0) begin
	$display("register file failed tests");
    	allTestsPass <= 0;
    end
end

//now when instruction decoder test is done, check our succes wire
always @(posedge instructionDecoderDone) begin
    $display("registerFile DUT passed?: %b", instructionDecoderDUT);
    if (instructionDecoderDUT === 0) begin
	$display("instruction decoder failed tests");
    	allTestsPass <= 0;
    end
end

//now when 32bit mux test is done, check our succes wire
always @(posedge mux32Done) begin
    $display("mux32 DUT passed?: %b", mux32DUT);
    if (mux32DUT === 0) begin
	$display("32 bit mux file failed tests");
    	allTestsPass <= 0;
    end
end


//now when 5bit mux test is done, check our succes wire
always @(posedge mux5Done) begin
    $display("mux5 DUT passed?: %b", mux5DUT);
    if (mux32DUT === 0) begin
	$display("5 bit mux failed tests");
    	allTestsPass <= 0;
    end
end


//now when pc register test is done, check our succes wire
always @(posedge pcDone) begin
    $display("PC DUT passed?: %b", pcDUT);
    if (pcDUT === 0) begin
	$display("PC failed tests");
    	allTestsPass <= 0; 
    end
end

//now when ra register test is done, check our succes wire
always @(posedge raDone) begin
    $display("RA DUT passed?: %b", raDUT);
    if (raDUT === 0) begin
	$display("RA failed tests");
    	allTestsPass <= 0; 
    end
end

//now when alutest is done, check our succes wire
always @(posedge aluDone) begin
    $display("ALU DUT passed?: %b", aluDUT);
    if (aluDUT === 0) begin
	$display("ALU failed tests");
    	allTestsPass <= 0; 
    end
end


//=====================start all tests===========================
initial begin
    startTests=0;
    allTestsPass = 1;
    #10;
    startTests=1;
    #1000;
    if(allTestsPass === 1)
            $display("all tests have succesfully passed. congrats");
    else
	$display("at least one of your tests failed. take a look at the console to find which one");
  end
//=====================end of all tests===============================

endmodule