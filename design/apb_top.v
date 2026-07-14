`include "apb_master.v"
`include "apb_slave.v"
module apb_top(//system signals
  			   input clk,
               input rst,
               input transfer,
               input [31:0] addr, //address into apb interface
               input [31:0] wdata, //write addr into apb
               input write, //operation control into apb
               output [31:0] rdata, //output read data from slave
               
               //peripheral
               input [31:0] per_rdata, //data from peripheral to CPU
               output [31:0] per_wdata //data from CPU to peripheral
              );
  
  
  wire pready,psel,penable,pwrite,pslverr;
  wire [31:0] paddr,pwdata,prdata;
  
  apb_master master(.clk(clk), 
                    .rst(rst),
                    .transfer(transfer),
                    .addr(addr), 
                    .wdata(wdata),
                    .prdata(prdata),
                    .write(write), 
                    .pready(pready),
                    .psel(psel),
                    .penable(penable),
                    .paddr(paddr),
                    .pwdata(pwdata),
                    .rdata(rdata),
                    .pwrite(pwrite)
                   );
  
  apb_slave slave(.clk(clk),
                  .rst(rst),
                  .paddr(paddr),
                  .psel(psel),
                  .penable(penable),
                  .pwdata(pwdata),
                  .pwrite(pwrite),
                  .per_rdata(per_rdata),
                  .per_wdata(per_wdata),
                  .pready(pready),
                  .prdata(prdata),
                  .pslverr(pslverr)
                 );
endmodule 
