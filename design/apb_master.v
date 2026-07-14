module APB_master(input clk,
                  input rst,
                  input transfer,
                  input [31:0] addr, //address into apb interface
                  input [31:0] wdata, //write addr into apb
                  input [31:0] prdata,//read data from slave
                  input write, //operation control into apb
                  input pready,
                  output psel,
                  output penable,
                  output [31:0] paddr, //output addr into slave
                  output [31:0] pwdata, //output write data into slave
                  output [31:0] rdata, //output read data from slave
                  output pwrite, //output operation control to slave
                 );
  
  reg [1:0] state,nxt_state;
  localparam IDLE = 0, SETUP = 1, ACCESS = 2;
  
  //state register
  always@(posedge clk) begin
    if(rst)
      state<=IDLE;
    else
      state<=nxt_state;
  end
  
  //transition logic
  always@(*) begin
    nxt_state = state;
    case(state)
      IDLE: begin
        if(transfer)
          nxt_state = SETUP;
        else
          nxt_state = IDLE;
      end
      SETUP: nxt_state = ACCESS;
      ACCESS: begin
        if(!pready)
          nxt_state = ACCESS;
        else begin
          if(transfer)
            nxt_state = SETUP;
          else
            nxt_state = IDLE;
        end
      end
      default: nxt_state = IDLE;
    endcase
  end
  
  //output logic
  always@(posedge  clk) begin
    if(rst)
      begin
        psel<=0;
        penable<=0;
        pwdata<=0;
        paddr<=0;
        pwrite<=0;
      end
    else begin
      case(nxt_state)
        IDLE: begin
          psel <=1'b0;
          penable<=0;
        end
        SETUP:
          begin
            psel<=1'b1;
            penable<=0;
            paddr<=addr;
            pwdata<=wdata;
            pwrite<=write;
          end
        ACCESS:
          begin
            psel<=1'b1;
            penable<=1'b1;
            if(!pwrite && pready)
              rdata<=prdata;
          end
      endcase
    end
  end
  
endmodule
