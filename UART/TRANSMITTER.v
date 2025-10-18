//////////////////////////////////////////////////////////////////////////////////
/////////////////////////////transmitter module//////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module transmitter(
input i_clk, wr_enb, tx_enb, i_rst, 
input [7:0]data_in, 
output reg tx, 
output busy
);

reg [7:0]data;
reg [2:0]index;


parameter idle_state = 2'b00;
parameter start_state = 2'b01;
parameter data_state = 2'b10;
parameter stop_state = 2'b11;
reg [1:0]state = idle_state;

    always @(posedge i_clk)
        begin
            if(i_rst)
                tx = 1'b1;
        end
    
    always @(posedge i_clk)
        begin
            case(state)
                idle_state: begin
                                if(wr_enb == 1'b1) begin
                                    state <= start_state;
                                    data <= data_in;
                                    index <= 3'h0;
                                    end
                                else
                                    state <= idle_state;
                            end
                start_state: begin
                                if(tx_enb == 1'b1) begin
                                    state <= data_state;
                                    tx <= 1'b0;
                                    end
                                else
                                    state <= start_state;
                            end
                                
                data_state: begin
                                if(tx_enb == 1'b1) begin
                                    if(index == 3'h7)
                                        state <= stop_state;
                                    else
                                        index <= index + 1'b1;
                                        tx <= data[index];
                                    end
                            end
                stop_state: begin
                                if(tx_enb == 1'b1) begin
                                    state <= idle_state;
                                    tx <= 1'b1;
                                    end
                            end
                
                default: begin
                                    state <= idle_state;
                                    tx <= 1'b1;
                               end
            endcase
       end 
       
       assign busy = (state != idle_state);
 endmodule   

