module apb_slave(input clk,
                 input rst,
                 input [31:0] paddr, //input addr from master
                 input psel, //input from master
                 input penable,
                 input [31:0] pwdata,
                 input pwrite,
                 input [31:0] per_rdata, //data from peripheral to CPU
                 output [31:0] per_wdata, //data from CPU to peripheral
                 output pready,
                 output [31:0] prdata,
                 output pslverr
                );
  
  assign pready=1'b1;
  assign per_wdata = reg0;
  
  reg [31:0] reg0,reg1,reg2,reg3; //internal registers connected to peripherals
  
  //write logic
  always@(posedge clk) begin
    if(rst)
      begin
        reg0<=0;
        reg1<=0;
        reg2<=0;
        reg3<=0;
      end
    else if(psel && penable && pwrite && pready)
      begin
        case(paddr[3:2])
          2'b00: reg0<=pwdata;
          2'b01: reg1<=pwdata;
          2'b10: reg2<=pwdata;
          2'b11: reg3<=pwdata;
        endcase
      end
  end
  
  //comb read
  always@(*) begin
    if(psel && !pwrite)
      begin
        case(paddr[3:2])
          2'b00: prdata=reg0;
          2'b01: prdata=per_rdata; //peripheral data to CPU
          2'b10: prdata=reg2;
          2'b11: prdata=reg3;
        endcase
      end
    else prdata = 0;
  end
  
endmodule
