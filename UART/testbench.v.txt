
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2025 13:29:13
// Design Name: 
// Module Name: test_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_tb();

reg i_clk, i_rst, wr_enb, ready_clr;
reg [7:0]data_in;
wire ready, busy;
wire [7:0]data_out;

uart dut(
.i_clk(i_clk),
.i_rst(i_rst), 
.wr_enb(wr_enb), 
.ready_clr(ready_clr),
.data_in(data_in), 
.data_out(data_out), 
.ready(ready), 
.busy(busy)
);

    initial begin
        { i_clk, i_rst, wr_enb, ready_clr, data_in} = 0;
        end 
    
    always #5 i_clk = ~i_clk;
    
    task send ( input [7:0] din);
        begin
            @(negedge i_clk);
            data_in = din;
            wr_enb = 1'b1;
            @(negedge i_clk)
            wr_enb =1'b0;
        end  
    endtask
     
     task clear_ready;
        begin
            @(negedge i_clk)
                 ready_clr = 1'b1;
            @(negedge i_clk)
                 ready_clr = 1'b0; 
        end
     endtask
     
     initial begin
        @(negedge i_clk)
         i_rst = 1;
        @(negedge i_clk)
         i_rst = 0;
         
        send(8'h41);
        wait(!busy);
        wait(ready);
        $display("received data is %h", data_out);
        clear_ready;     
        
        send(8'h55);
        wait(!busy);
        wait(ready);
        $display("received data is %h", data_out);
        clear_ready;
        
        //#400 $finish;
     end
        
endmodule



