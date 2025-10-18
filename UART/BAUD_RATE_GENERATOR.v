
//////////////////////////////////////////////////////////////////////////////////
/////////////////////////////baud rate generator//////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module baud_generator(input i_clk, i_rst, output rx_enb, tx_enb);
reg [12:0]tx_counter; 
reg [8:0]rx_counter;
    always @(posedge i_clk)
        begin
            if(i_rst)
                tx_counter <= 0;
            else if(tx_counter == 5208)
                tx_counter <= 0;
            else
                 tx_counter <= tx_counter+1;
        end
// receiver side counter
    always @(posedge i_clk)
        begin
            if(i_rst)
                rx_counter <= 0;
            else if(rx_counter == 325)
                rx_counter <= 0;
            else
                 rx_counter <= rx_counter+1;
        end  
        
    assign tx_enb = (tx_counter == 0) ? 1'b1: 1'b0;
    assign rx_enb = (rx_counter == 0) ? 1'b1: 1'b0;
endmodule
