//------------------------------------------------------------------------------
// Test harness validates hw4testbench by connecting it to various functional 
// or broken register files, and verifying that it correctly identifies each
//------------------------------------------------------------------------------
`include
"regfile.v"

module hw4testbenchharness();

  wire[31:0]	ReadData1;	// Data from first register read
  wire[31:0]	ReadData2;	// Data from second register read
  wire[31:0]	WriteData;	// Data to write to register
  wire[4:0]	ReadRegister1;	// Address of first register to read
  wire[4:0]	ReadRegister2;	// Address of second register to read
  wire[4:0]	WriteRegister;  // Address of register to write
  wire		RegWrite;	// Enable writing of register when High
  wire		Clk;		// Clock (Positive Edge Triggered)

  reg		begintest;	// Set High to begin testing register file
  wire		dutpassed;	// Indicates whether register file passed tests

  // Instantiate the register file being tested.  DUT = Device Under Test
  regfile DUT
  (
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData),
    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite),
    .Clk(Clk)
  );

  // Instantiate test bench to test the DUT
  hw4testbench tester
  (
    .begintest(begintest),
    .endtest(endtest), 
    .dutpassed(dutpassed),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData), 
    .ReadRegister1(ReadRegister1), 
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite), 
    .Clk(Clk)
  );

  // Test harness asserts 'begintest' for 1000 time steps, starting at time 10
  initial begin
    begintest=0;
    #10;
    begintest=1;
    #1000;
  end

  // Display test results ('dutpassed' signal) once 'endtest' goes high
  always @(posedge endtest) begin
    $display("DUT passed?: %b", dutpassed);
  end

endmodule


//------------------------------------------------------------------------------
// Your HW4 test bench
//   Generates signals to drive register file and passes them back up one
//   layer to the test harness. This lets us plug in various working and
//   broken register files to test.
//
//   Once 'begintest' is asserted, begin testing the register file.
//   Once your test is conclusive, set 'dutpassed' appropriately and then
//   raise 'endtest'.
//------------------------------------------------------------------------------

module hw4testbench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// Register File DUT connections
input[31:0]		ReadData1,
input[31:0]		ReadData2,
output reg[31:0]	WriteData,
output reg[4:0]		ReadRegister1,
output reg[4:0]		ReadRegister2,
output reg[4:0]		WriteRegister,
output reg		RegWrite,
output reg		Clk
);


integer r; //index for for loops to check multiple registers
  
// Initialize register driver signals
  initial begin
    WriteData=32'd0;
    ReadRegister1=5'd0;
    ReadRegister2=5'd0;
    WriteRegister=5'd0;
    RegWrite=0;
    Clk=0;
  end

  // Once 'begintest' is asserted, start running test cases
  always @(posedge begintest) begin
    endtest = 0;
    dutpassed = 1;
    #10

  // Test Case 1: 
  //   Write '42' to register 2, verify with Read Ports 1 and 2
  //   (Passes because example register file is hardwired to return 42)
  WriteRegister = 5'd2;
  WriteData = 32'd42;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;	// Generate single clock pulse

  // Verify expectations and report test result
  if((ReadData1 != 42) || (ReadData2 != 42)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 1 Failed");
  end

  // Test Case 2: 
  //   Write '15' to register 2, verify with Read Ports 1 and 2
  //   (Fails with example register file, but should pass with yours)
  WriteRegister = 5'd2;
  WriteData = 32'd15;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 != 15) || (ReadData2 != 15)) begin
    dutpassed = 0;
    $display("Test Case 2 Failed");
  end


// DELIVERABLE 8
//D8_TestBench1: Perfect Register file. Return True when dectected, False all others.

	for(r=1; r<32; r=r+1) begin
        	WriteRegister = r; //5 bit # between d1 and d32: Write to register r
        	WriteData = r*10;  //32 bit # changes loop to test different numbers
        	RegWrite = 1; //RegWrite Enabled
        	ReadRegister1 = r; //5 bit # between d1 and d32: Read from register r
        	ReadRegister2 = r; //5 bit # between d1 and d32  Read from register r
        	#5 Clk=1; #5 Clk=0; //clock pulse

        	if((ReadData1 != r*10) || (ReadData2 != r*10)) begin
	   	 //data written to register should equal data written to that same register!
            		dutpassed = 0;
            		$display("D8_TestBench1: failed at register %d", r);
        	end
    	end   

    if(dutpassed == 0) begin
        $display("FALSE");
	$display("Perfect register file has not been detected");
    end 
    else begin
        $display("TRUE");
	$display("Register File is Perfect  :)");
    end


//DELIVERABLE 8
//D8_TestBench2: WriteEnable is broken/ignored - Register is always written to

//
    WriteRegister = 5'd2; 
    WriteData = 32'd15;
    RegWrite = 1;
    ReadRegister1 = 5'd2;
    ReadRegister2 = 5'd2;
    #5 Clk=1; #5 Clk=0; //clock pulse

    if((ReadData1 != 15) || (ReadData2 != 15)) begin
	// When WriteEnable is True, and ReadRegister=WriteRegister,
	//WriteData should = the data read from the output of each mux
	//in this case d15
        dutpassed = 0; //dut failed
        $display("D8_TestBench2: Failed");
        $display("Data1: %b | Data2: %b", ReadData1, ReadData2);
    end

    WriteData = 32'd42; //new data
    RegWrite = 0; //RegWrite is 0 -> enable should be zero
    #5 Clk=1; #5 Clk=0; //clock cycle
    //New WriteData should not be written to register!
    //Data read from register should be the same as previously
    //Else: enable must be broken!

    if((ReadData1 != 15) || (ReadData2 != 15)) begin
        dutpassed = 0;
        $display("D8_TestBench2: Failed at Write Enable");
        $display("Data1: %b | Data2: %b", ReadData1, ReadData2);
    end


//DELIVERABLE 8
//D8_TestBench3: Decoder is broken - All registers are written to
	//reset all registers to 0.
	for(r=1; r<32; r=r+1) begin
        	WriteRegister = r; //5 bit # between d1 and d32: Write to register r
        	WriteData = 0;  //32 bit # changes loop to test different numbers
        	RegWrite = 1; //RegWrite Enabled
        	ReadRegister1 = r; //5 bit # between d1 and d32: Read from register r
        	ReadRegister2 = r; //5 bit # between d1 and d32  Read from register r
        	#5 Clk=1; #5 Clk=0; //clock pulse
	end

    WriteRegister = 5'd2;  
    WriteData = 32'd100;    //Set register 2 to 100
    RegWrite = 1;           //RegWrite Enabled
    
    for (r=0; r<32; r=r+1) begin
        ReadRegister1 = r; //Which register to read for Data1
        ReadRegister2 = r; //Which register to read for Data2
        #5 Clk=1; #5 Clk=0; //Clock pulse

	if ((((ReadData1 != WriteData) || (ReadData2 != WriteData)) && (r == WriteRegister)) || (((ReadData1 == WriteData) || (ReadData2 == WriteData)) && (r!= WriteRegister))) begin
            //if the register being read is the register that data should be being written to,  and the data read is not the data being written
	    //OR if the register being read is NOT the register that data should be being written to, and the data read IS the data being written
	    //then the decoder has failed - Writing to registers it should not be writing to.
	    dutpassed = 0;
            $display("D8_TestBench3: Failed at Decoder");
            $display("WriteRegister: %d ReadRegister: %d", WriteRegister, r);
	    $display("Data written: %b", WriteData, );
	    $display("ReadData1: %b, ReadData2 %b",ReadData1, ReadData2);
        end
    end



//DELIVERABLE 8
//D8_TestBench4: Register Zero is actually a register instead of constant zero
    WriteRegister = 5'd0; 
    WriteData = 32'd15;
    RegWrite = 1;
    ReadRegister1 = 5'd0;
    ReadRegister2 = 5'd0;
    #5 Clk=1; #5 Clk=0; //Clock pulse
	if ((ReadData1 != 0) || (ReadData2 != 0)) begin
		//if data read fom either port is not 0 when reading from register 0, Register Zero has failed.
		dutpassed = 0;
		$display( "D8_TestBench4: Failed at Register Zero");
		$display("Reister: %d, Output: %d", WriteRegister, ReadData1);
	end


//DELIVERABLE 8
//D8_TestBench5: Port 2 is broken and always reads register 17
   
    WriteRegister = 5'd17; 
    WriteData = 32'd100;   //Register 17 => d100
    RegWrite = 1;
    ReadRegister1 = 5'd17;
    ReadRegister2 = 5'd17;
    #5 Clk=1; #5 Clk=0; //Clock pulse


    WriteData = 32'd15;
    for (r=0; r<16; r=r+1) begin
	WriteRegister = r;
        ReadRegister1 = r; //Which register to read for Data1
	ReadRegister2 = r; //Which register to read for Data2
        #5 Clk=1; #5 Clk=0; //Clock pulse
	if (ReadData2 == 100) begin
		//port 2 is reading the value from register 17 
		//when it should be reading from one of the previouos
		//port 2 is broken
		dutpassed = 0;
		$display( "D8_TestBench5: Failed at Port2");
		$display("Data to be written: %d, Data read from port 2: %d",  WriteData, ReadData2);
	end
    end




  // All done!  Wait a moment and signal test completion.

  #5
  endtest = 1;

end

endmodule

