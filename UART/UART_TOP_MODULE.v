
 
//////////////////////////////////////////////////////////////////////////////////
/////////////////////////////main module//////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module uart(
input i_clk,i_rst, wr_enb, ready_clr,
input [7:0]data_in, 
output [7:0]data_out, 
output ready, busy
);
wire rx_enb, tx_enb;//collecting output of baud rate generator
wire tx; //output of transmitter module

///////baud rate genrator instantiation
baud_generator baud_generator(
.i_clk(i_clk),
.i_rst(i_rst),
.rx_enb(rx_enb), 
.tx_enb(tx_enb)
);

///////transmitter instantiation
transmitter transmitter(
.i_clk(i_clk), 
.wr_enb(wr_enb), 
.tx_enb(tx_enb), 
.i_rst(i_rst), 
.data_in(data_in), 
.tx(tx), 
.busy(busy)
);

///////receiver instantiation
receiver receiver(
.i_clk(i_clk), 
.i_rst(i_rst), 
.ready_clr(ready_clr), 
.rx_enb(rx_enb), 
.rx(tx), 
.ready(ready), 
.data_out(data_out)
);
endmodule
