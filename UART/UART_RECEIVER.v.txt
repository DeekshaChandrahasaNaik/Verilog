//////////////////////////////////////////////////////////////////////////////////
/////////////////////////////receiver//////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////          
module receiver(
input i_clk, i_rst, ready_clr, rx_enb, rx, 
output reg ready, 
output reg [7:0]data_out
);

parameter start_state = 2'b00;
parameter data_state = 2'b01;
parameter stop_state = 2'b10;

reg [1:0]state = start_state;
reg [3:0] sample, index;
reg [7:0]temp;
    always @(posedge i_clk)
        begin 
            if(i_rst) begin
                ready <= 1'b0;
                data_out <= 8'h0;
                sample <= 0;
                index <=0;
            end 
        end
    
    always @(posedge i_clk)
        begin
            if(ready_clr)
                ready <= 0;
            if(rx_enb) 
                begin
                    case(state)
                
                        start_state: begin
                                        if(!rx || sample != 0)
                                            sample <= sample + 1'b1;
                                        if(sample == 15) begin
                                            state <= data_state;
                                            temp <= 8'h0;
                                            sample <= 0;
                                            index <= 0;
                                         end 
                                     end   
                            
                        data_state: begin
                                        sample <= sample + 1'b1;
                                        if(sample == 4'h8) begin
                                            temp[index] <= rx;
                                            index <= index + 1'b1;
                                         end 
                                         
                                        if(index == 8'h8 && sample ==15)
                                            state <= stop_state;
                                    end
                        stop_state: begin
                                        if(sample ==15)
                                            begin
                                                state <= start_state;
                                                data_out <= temp;
                                                ready <= 1'b1;
                                                sample <= 0;
                                            end
                                        else
                                            sample <= sample +1'b1;
                                    end
                      
                      default : begin
                                    state <= start_state;
                                end
                    endcase
                end     
        end    

endmodule
                
    

