module allTestBenchesHarness();

//wire to start all tests
reg startTests;
reg allTestsPass;

//wires for success and testdone on the datamemory module
wire dataMemoryDUT;
wire dataMemoryDone;

//set up the test bench harness for the data memory
datamemorytestbenchharness dataMemoryTester(
  .dutPassed(dataMemoryDUT),
  .testDone(dataMemoryDone),
  .startTests(startTests)
);

//start all tests
initial begin
    startTests=0;
    #10;
    startTests=1;
    #1000;
    if(allTestsPass === 1)
            $display("all tests have succesfully passed. congrats");
    else
	$display("at least one of your tests failed. take a look at the console to find which one");
  end

//now when datamemory test is done, check our succes wire
always @(posedge dataMemoryDone) begin
    $display("datamemory DUT passed?: %b", dataMemoryDUT);
    allTestsPass <= dataMemoryDUT; 
end




endmodule