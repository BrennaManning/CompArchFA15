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
    $display("registerFile DUT passed?: %b", registerFileDUT);
    if (instructionDecoderDUT === 0) begin
	$display("register file failed tests");
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