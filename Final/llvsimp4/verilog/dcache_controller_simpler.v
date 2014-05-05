//ting
`define MSHR_STORE     1'b0
`define MSHR_LOAD      1'b1
//ting

module dcache_controller(// inputs
			clock,
			reset,
                        ////LSQ
                        lsq2ctr_rd_addr,
                        lsq2ctr_rd_en,
                        lsq2ctr_st_addr,
                        lsq2ctr_st_data,
                        lsq2ctr_st_en,
                        ////cache
			cache2ctr_rd_data,
			cache2ctr_rd_valid,
                        ////mem
			mem2ctr_tag,
			mem2ctr_response,
                        mem2ctr_wr_data,

			// outputs
                        ////LSQ
			ctr2lsq_rd_data,
			ctr2lsq_rd_valid,
                        ctr2lsq_st_valid,
                        ctr2lsq_response,
                        ctr2lsq_tag_data,
                        ctr2lsq_tag,
                        ////cache
                        ctr2cache_wr_addr,
                        ctr2cache_wr_data,
			ctr2cache_wr_enable,
                        ctr2cache_rd_addr,
                        ////mem
			ctr2mem_req_addr,
			ctr2mem_command,
                        ctr2mem_data
			);

input clock;
input reset;
//input LSQ
input [63:0] lsq2ctr_rd_addr;
input        lsq2ctr_rd_en;
input [63:0] lsq2ctr_st_addr;
input [63:0] lsq2ctr_st_data;
input        lsq2ctr_st_en;
//input cache
input [63:0] cache2ctr_rd_data;
input        cache2ctr_rd_valid;
//input mem
input  [3:0] mem2ctr_tag;
input  [3:0] mem2ctr_response;
input [63:0] mem2ctr_wr_data;

//output LSQ
output [63:0] ctr2lsq_rd_data;
output        ctr2lsq_rd_valid;
output        ctr2lsq_st_valid;
output  [3:0] ctr2lsq_response;
output [63:0] ctr2lsq_tag_data;
output  [3:0] ctr2lsq_tag;
//output cache
output [63:0] ctr2cache_wr_addr;
output [63:0] ctr2cache_wr_data;
output        ctr2cache_wr_enable;
output [63:0] ctr2cache_rd_addr;
//output mem
output [63:0] ctr2mem_req_addr;
output  [1:0] ctr2mem_command;
output [63:0] ctr2mem_data;

//MSHR
reg    [63:0] MSHR_addr[15:0];
reg    [15:0] MSHR_valid;
reg    [15:0] next_MSHR_valid;


assign ctr2lsq_rd_data     = cache2ctr_rd_data;
assign ctr2lsq_rd_valid    = cache2ctr_rd_valid;
assign ctr2lsq_st_valid    = lsq2ctr_st_en & (mem2ctr_response != 0);
assign ctr2lsq_response    = mem2ctr_response;
assign ctr2lsq_tag_data    = mem2ctr_wr_data;
assign ctr2lsq_tag         = mem2ctr_tag;
assign ctr2cache_wr_addr   = ctr2lsq_st_valid ? lsq2ctr_st_addr : MSHR_addr[mem2ctr_tag];
assign ctr2cache_wr_data   = ctr2lsq_st_valid ? lsq2ctr_st_data : mem2ctr_wr_data;
assign ctr2cache_wr_enable = ((MSHR_valid[mem2ctr_tag] == `TRUE) | ctr2lsq_st_valid ) ? `TRUE:`FALSE;
assign ctr2cache_rd_addr   = lsq2ctr_rd_addr;
assign ctr2mem_req_addr    = lsq2ctr_st_en ? lsq2ctr_st_addr:lsq2ctr_rd_addr;
assign ctr2mem_command     = lsq2ctr_st_en ? `BUS_STORE :
                             lsq2ctr_rd_en ? `BUS_LOAD  :
                                             `BUS_NONE  ;
assign ctr2mem_data        = lsq2ctr_st_data;





//MSHR
always@* begin
  next_MSHR_valid = MSHR_valid;
  if(mem2ctr_response != 0 & lsq2ctr_rd_en)begin
    next_MSHR_valid[mem2ctr_response] = `TRUE;
  end
  if(MSHR_valid[mem2ctr_tag] == `TRUE) next_MSHR_valid[mem2ctr_tag] = `FALSE;
end
always@(posedge clock) begin
  if(reset)
    MSHR_valid <= `SD 0;
  else begin
    MSHR_valid <= `SD next_MSHR_valid;
  end
end
always@(posedge clock) begin
  if(mem2ctr_response != 0)begin
    if(lsq2ctr_st_en) begin
      MSHR_addr[mem2ctr_response]    <= `SD lsq2ctr_st_addr;
    end else if(lsq2ctr_rd_en) begin
      MSHR_addr[mem2ctr_response]    <= `SD lsq2ctr_rd_addr;
    end
  end
end
//MSHR

endmodule
