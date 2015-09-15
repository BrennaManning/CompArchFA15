module hw1test;
reg A; // input A
reg B; // input B
wire nA;
wire nB;
wire nAandnB;
not Ainv(nA, A); // top inverter produces signal nA and takes
		 // signal A, and is named A inv
not Binv(nB, B); // inverter produces signal nB and takes
		 // signal B, and is named Binv
and andgate(nAandnB, nA, nB); // and gaate produces nAandnB from nA and nB

initial begin
$display("A B | ~A ~B  | ~(AB) ~A+~B | ~(A+B) ~A~B "); // prints header for truth table
A=0;B=0; #1 //Set A and B, wait for update (#1)
$display("%b %b |  %b  %b  |   %b     %b   |   %b    %b  ", A,B, nA, nB, !(A && B), nA||nB, !(A||B), nAandnB);
A=0;B=1; #1 //Set A and B, wait for new update
$display("%b %b |  %b  %b  |   %b     %b   |   %b    %b  ", A,B, nA, nB, !(A && B), nA||nB, !(A||B), nAandnB);
A=1;B=0; #1
$display("%b %b |  %b  %b  |   %b     %b   |   %b    %b  ", A,B, nA, nB, !(A && B), nA||nB, !(A||B), nAandnB);
A=1;B=1; #1
$display("%b %b |  %b  %b  |   %b     %b   |   %b    %b  ", A,B, nA, nB, !(A && B), nA||nB, !(A||B), nAandnB);
end
endmodule
