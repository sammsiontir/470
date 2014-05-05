/////////////////////////////////////////////////////////////////////////
//                                                                     //
//                     Modulename :  LSQ.v                              //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
`define NO_DATA        64'd0


//`timescale 1ns/100ps

module simLSQ(// Inputs
	     clock,
	     reset,

             PreDe_load_port1_allocate_en,
             PreDe_load_port1_destination,
             PreDe_load_port1_NPC,
             PreDe_load_port2_allocate_en,
             PreDe_load_port2_destination,
             PreDe_load_port2_NPC,

             PreDe_store_port1_allocate_en,
             PreDe_store_port1_data,
             PreDe_store_port1_NPC,
             PreDe_store_port2_allocate_en,
             PreDe_store_port2_data,
             PreDe_store_port2_NPC,
            
             Ex_load_port1_address_en,
     	     Ex_load_port1_address,
             Ex_load_port1_address_insert_position,
             Ex_load_port2_address_en,
     	     Ex_load_port2_address,
             Ex_load_port2_address_insert_position,

             Ex_store_port1_address_en,
     	     Ex_store_port1_address,
             Ex_store_port1_address_insert_position,
             Ex_store_port2_address_en,
     	     Ex_store_port2_address,
             Ex_store_port2_address_insert_position,

             Rob_store_port1_retire_en,  
             Rob_store_port2_retire_en,  
             Rob_load_retire_en, 
            
             Dcash_load_valid,
             Dcash_load_valid_data,
             Dcash_store_valid,                   
           

             Dcash_response,
             Dcash_tag_data,
             Dcash_tag,

             br_marker_port1_en,
             br_marker_port1_num,
             br_marker_port2_en,
             br_marker_port2_num,
             recovery_en,
             recovery_br_marker_num,
                         
             stall,
	  // Outputs
             LSQ_PreDe_tail_position,
             LSQ_PreDe_tail_position_plus_one,
             
             LSQ_Rob_store_retire_en,
             LSQ_Rob_destination,
             LSQ_Rob_data,
             LSQ_Rob_NPC,
             LSQ_Rob_write_dest_n_data_en,

             LSQ_Dcash_load_address_en,
             LSQ_Dcash_load_address, 
             LSQ_Dcash_store_address_en,
             LSQ_Dcash_store_address,
             LSQ_Dcash_store_data,
             
             LSQ_str_hazard
           );

input	     clock;
input	     reset;

input        PreDe_load_port1_allocate_en;
input [5:0]  PreDe_load_port1_destination;
input [63:0] PreDe_load_port1_NPC;
input        PreDe_load_port2_allocate_en;
input [5:0]  PreDe_load_port2_destination;
input [63:0] PreDe_load_port2_NPC;

input        PreDe_store_port1_allocate_en;
input [63:0] PreDe_store_port1_data;
input [63:0] PreDe_store_port1_NPC;
input        PreDe_store_port2_allocate_en;
input [63:0] PreDe_store_port2_data;
input [63:0] PreDe_store_port2_NPC;

input        Ex_load_port1_address_en;
input [63:0] Ex_load_port1_address;
input [4:0]  Ex_load_port1_address_insert_position;
input        Ex_load_port2_address_en;
input [63:0] Ex_load_port2_address;
input [4:0]  Ex_load_port2_address_insert_position;

input        Ex_store_port1_address_en;
input [63:0] Ex_store_port1_address;
input [4:0]  Ex_store_port1_address_insert_position;
input        Ex_store_port2_address_en;
input [63:0] Ex_store_port2_address;
input [4:0]  Ex_store_port2_address_insert_position;

input        Rob_store_port1_retire_en;
input        Rob_store_port2_retire_en;   
input        Rob_load_retire_en; 

input        Dcash_load_valid;
input [63:0] Dcash_load_valid_data;
input        Dcash_store_valid;

input        br_marker_port1_en;
input [2:0]  br_marker_port1_num;
input        br_marker_port2_en;
input [2:0]  br_marker_port2_num;

input        recovery_en;
input [2:0]  recovery_br_marker_num;

input [3:0]  Dcash_response;
input [63:0] Dcash_tag_data;
input [3:0]  Dcash_tag;

input        stall;


output     [4:0] LSQ_PreDe_tail_position;
output     [4:0] LSQ_PreDe_tail_position_plus_one;

output reg LSQ_Rob_store_retire_en;
output reg [5:0] LSQ_Rob_destination;
output reg [63:0]LSQ_Rob_data;
output reg [63:0]LSQ_Rob_NPC;
output reg LSQ_Rob_write_dest_n_data_en;             

output reg LSQ_Dcash_load_address_en;
output reg [63:0]LSQ_Dcash_load_address;
output reg       LSQ_Dcash_store_address_en;
output reg [63:0]LSQ_Dcash_store_address;
output reg [63:0]LSQ_Dcash_store_data;
             
output reg LSQ_str_hazard;

reg       LSQ_ld_or_st_stack [0:15];
reg [3:0] LSQ_ready_bit_stack [0:15];
reg [3:0] LSQ_response_stack [0:15];
reg [63:0]LSQ_address_stack [0:15];
reg [5:0] LSQ_destination_stack [0:15];
reg [63:0]LSQ_data_stack [0:15];

reg [63:0]LSQ_NPC_stack[0:15];



reg [2:0] br_marker_num_stack [0:3];
reg [4:0] br_marker_tail_stack [0:3];

reg [4:0]head_ptr;
reg [4:0]next_head_ptr;
reg [4:0]tail_ptr;
wire [4:0]head_plus_one;
wire [4:0]tail_plus_one;
wire [4:0]tail_plus_two;
wire [4:0]tail_plus_three;
assign head_plus_one = head_ptr + 1;
assign tail_plus_one = tail_ptr + 1;
assign tail_plus_two = tail_ptr + 2;
assign tail_plus_three = tail_ptr + 3;

reg [3:0] LSQ_store_retire_accumulator;
wire[3:0] LSQ_store_retire_accumulator_plus_one;
wire[3:0] LSQ_store_retire_accumulator_plus_two;
wire[3:0] LSQ_store_retire_accumulator_minus_one;
assign LSQ_store_retire_accumulator_plus_one = LSQ_store_retire_accumulator + 1;
assign LSQ_store_retire_accumulator_plus_two = LSQ_store_retire_accumulator + 2;
assign LSQ_store_retire_accumulator_minus_one = LSQ_store_retire_accumulator - 1;

wire LSQ_retire_enable;
assign LSQ_retire_enable = (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd7)? 1:0; 
assign LSQ_PreDe_tail_position = tail_ptr;

wire [4:0] LSQ_PreDe_tail_position_plus_one;
assign LSQ_PreDe_tail_position_plus_one = LSQ_PreDe_tail_position + 1;

wire write_in_case_2;
assign write_in_case_2 = (PreDe_store_port1_allocate_en && PreDe_store_port2_allocate_en) 
                      || (PreDe_load_port1_allocate_en && PreDe_load_port2_allocate_en) 
                      || (PreDe_store_port1_allocate_en && PreDe_load_port2_allocate_en)
                      || (PreDe_load_port1_allocate_en && PreDe_store_port2_allocate_en);
wire write_in_1;
assign write_in_1 = (PreDe_store_port1_allocate_en || PreDe_store_port2_allocate_en || PreDe_load_port1_allocate_en || PreDe_load_port2_allocate_en) && ~write_in_case_2;

always @*
begin
  LSQ_Rob_store_retire_en = 1'b0;
  if(LSQ_ld_or_st_stack[head_ptr[3:0]]  && LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd7) LSQ_Rob_store_retire_en = 1'b1;//
end

always @*
begin
  LSQ_str_hazard = 1'b0;
  if({!head_ptr[4],head_ptr[3:0]} == tail_plus_three && write_in_case_2) LSQ_str_hazard = 1'b1;
  if({!head_ptr[4],head_ptr[3:0]} == tail_plus_two && (write_in_1 || write_in_case_2) ) LSQ_str_hazard = 1'b1;
  if(({!head_ptr[4],head_ptr[3:0]} == tail_plus_one || {!head_ptr[4],head_ptr[3:0]} == tail_ptr)) LSQ_str_hazard = 1'b1;
end

always @*
begin
  LSQ_Dcash_store_address_en = 1'b0;
  LSQ_Dcash_store_address = 64'd0;
  LSQ_Dcash_store_data = 64'd0;
  if(LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_store_retire_accumulator != 4'd0 && (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd2 || LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd3))begin
    LSQ_Dcash_store_address_en = 1'b1;
    LSQ_Dcash_store_address = LSQ_address_stack[head_ptr[3:0]];
    LSQ_Dcash_store_data = LSQ_data_stack[head_ptr[3:0]];
  end
end


always @*
begin
  LSQ_Dcash_load_address_en = 1'b0;
  LSQ_Dcash_load_address = 64'd0;
  if(~LSQ_ld_or_st_stack[head_ptr[3:0]] && (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd1 || LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd2))begin
    LSQ_Dcash_load_address_en = 1'b1;
    LSQ_Dcash_load_address = LSQ_address_stack[head_ptr[3:0]];
  end
end

always @*
begin
  LSQ_Rob_destination = 6'd31; 
  LSQ_Rob_data = 64'd0;
  LSQ_Rob_NPC = 64'd0;
  LSQ_Rob_write_dest_n_data_en = 1'b0;
  if(~stall && ~recovery_en && ~LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd7)begin//
    LSQ_Rob_destination = LSQ_destination_stack[head_ptr[3:0]]; 
    LSQ_Rob_data = LSQ_data_stack[head_ptr[3:0]];
    LSQ_Rob_NPC = LSQ_NPC_stack[head_ptr[3:0]];          
    LSQ_Rob_write_dest_n_data_en = 1'b1;
  end
end

always @*
begin
  next_head_ptr = head_ptr;
  if(LSQ_retire_enable && ~stall && ~recovery_en) next_head_ptr = head_ptr + 1;
  else if(recovery_en) begin
    if(br_marker_num_stack[ 0] != 3'b100 && br_marker_num_stack[ 0] == recovery_br_marker_num && (br_marker_tail_stack[ 0][3:0] < head_ptr[3:0]) && (br_marker_tail_stack[ 0][4] == head_ptr[4])) next_head_ptr = br_marker_tail_stack[ 0];
    if(br_marker_num_stack[ 1] != 3'b100 && br_marker_num_stack[ 1] == recovery_br_marker_num && (br_marker_tail_stack[ 1][3:0] < head_ptr[3:0]) && (br_marker_tail_stack[ 1][4] == head_ptr[4])) next_head_ptr = br_marker_tail_stack[ 1];
    if(br_marker_num_stack[ 2] != 3'b100 && br_marker_num_stack[ 2] == recovery_br_marker_num && (br_marker_tail_stack[ 2][3:0] < head_ptr[3:0]) && (br_marker_tail_stack[ 2][4] == head_ptr[4])) next_head_ptr = br_marker_tail_stack[ 2];
    if(br_marker_num_stack[ 3] != 3'b100 && br_marker_num_stack[ 3] == recovery_br_marker_num && (br_marker_tail_stack[ 3][3:0] < head_ptr[3:0]) && (br_marker_tail_stack[ 3][4] == head_ptr[4])) next_head_ptr = br_marker_tail_stack[ 3];
  end
end

always@(posedge clock) begin
  if(reset) head_ptr <= `SD 0;
  else      head_ptr <= `SD next_head_ptr;
end

always @(posedge clock)
    if (reset)
    begin
 
      LSQ_ld_or_st_stack[ 0]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[ 1]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[ 2]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[ 3]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[ 4]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[ 5]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[ 6]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[ 7]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[ 8]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[ 9]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[10]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[11]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[12]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[13]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[14]   <= `SD 1'b0;
      LSQ_ld_or_st_stack[15]   <= `SD 1'b0;
         
      LSQ_ready_bit_stack[ 0]  <= `SD 3'd0;
      LSQ_ready_bit_stack[ 1]  <= `SD 3'd0;
      LSQ_ready_bit_stack[ 2]  <= `SD 3'd0;
      LSQ_ready_bit_stack[ 3]  <= `SD 3'd0;
      LSQ_ready_bit_stack[ 4]  <= `SD 3'd0;
      LSQ_ready_bit_stack[ 5]  <= `SD 3'd0;
      LSQ_ready_bit_stack[ 6]  <= `SD 3'd0;
      LSQ_ready_bit_stack[ 7]  <= `SD 3'd0;
      LSQ_ready_bit_stack[ 8]  <= `SD 3'd0;
      LSQ_ready_bit_stack[ 9]  <= `SD 3'd0;
      LSQ_ready_bit_stack[10]  <= `SD 3'd0;
      LSQ_ready_bit_stack[11]  <= `SD 3'd0;
      LSQ_ready_bit_stack[12]  <= `SD 3'd0;
      LSQ_ready_bit_stack[13]  <= `SD 3'd0;
      LSQ_ready_bit_stack[14]  <= `SD 3'd0;
      LSQ_ready_bit_stack[15]  <= `SD 3'd0;

      LSQ_response_stack[ 0]   <= `SD 4'd0;
      LSQ_response_stack[ 1]   <= `SD 4'd0;
      LSQ_response_stack[ 2]   <= `SD 4'd0;
      LSQ_response_stack[ 3]   <= `SD 4'd0;
      LSQ_response_stack[ 4]   <= `SD 4'd0;
      LSQ_response_stack[ 5]   <= `SD 4'd0;
      LSQ_response_stack[ 6]   <= `SD 4'd0;
      LSQ_response_stack[ 7]   <= `SD 4'd0;
      LSQ_response_stack[ 8]   <= `SD 4'd0;
      LSQ_response_stack[ 9]   <= `SD 4'd0;
      LSQ_response_stack[10]   <= `SD 4'd0;
      LSQ_response_stack[11]   <= `SD 4'd0;
      LSQ_response_stack[12]   <= `SD 4'd0;
      LSQ_response_stack[13]   <= `SD 4'd0;
      LSQ_response_stack[14]   <= `SD 4'd0;  
      LSQ_response_stack[15]   <= `SD 4'd0;

      LSQ_address_stack[ 0]    <= `SD 64'd0;
      LSQ_address_stack[ 1]    <= `SD 64'd0;
      LSQ_address_stack[ 2]    <= `SD 64'd0;
      LSQ_address_stack[ 3]    <= `SD 64'd0;
      LSQ_address_stack[ 4]    <= `SD 64'd0;
      LSQ_address_stack[ 5]    <= `SD 64'd0;
      LSQ_address_stack[ 6]    <= `SD 64'd0;
      LSQ_address_stack[ 7]    <= `SD 64'd0;
      LSQ_address_stack[ 8]    <= `SD 64'd0;
      LSQ_address_stack[ 9]    <= `SD 64'd0;
      LSQ_address_stack[10]    <= `SD 64'd0;
      LSQ_address_stack[11]    <= `SD 64'd0;
      LSQ_address_stack[12]    <= `SD 64'd0;
      LSQ_address_stack[13]    <= `SD 64'd0;
      LSQ_address_stack[14]    <= `SD 64'd0;
      LSQ_address_stack[15]    <= `SD 64'd0;

      LSQ_destination_stack[ 0]  <= `SD 6'd0;
      LSQ_destination_stack[ 1]  <= `SD 6'd0;
      LSQ_destination_stack[ 2]  <= `SD 6'd0;
      LSQ_destination_stack[ 3]  <= `SD 6'd0;
      LSQ_destination_stack[ 4]  <= `SD 6'd0;
      LSQ_destination_stack[ 5]  <= `SD 6'd0;
      LSQ_destination_stack[ 6]  <= `SD 6'd0;
      LSQ_destination_stack[ 7]  <= `SD 6'd0;
      LSQ_destination_stack[ 8]  <= `SD 6'd0;
      LSQ_destination_stack[ 9]  <= `SD 6'd0;
      LSQ_destination_stack[10]  <= `SD 6'd0;
      LSQ_destination_stack[11]  <= `SD 6'd0;
      LSQ_destination_stack[12]  <= `SD 6'd0;
      LSQ_destination_stack[13]  <= `SD 6'd0;
      LSQ_destination_stack[14]  <= `SD 6'd0;
      LSQ_destination_stack[15]  <= `SD 6'd0;

      LSQ_data_stack[ 0]    <= `SD `NO_DATA;
      LSQ_data_stack[ 1]    <= `SD `NO_DATA;
      LSQ_data_stack[ 2]    <= `SD `NO_DATA;
      LSQ_data_stack[ 3]    <= `SD `NO_DATA;
      LSQ_data_stack[ 4]    <= `SD `NO_DATA;
      LSQ_data_stack[ 5]    <= `SD `NO_DATA;
      LSQ_data_stack[ 6]    <= `SD `NO_DATA;
      LSQ_data_stack[ 7]    <= `SD `NO_DATA;
      LSQ_data_stack[ 8]    <= `SD `NO_DATA;
      LSQ_data_stack[ 9]    <= `SD `NO_DATA;
      LSQ_data_stack[10]    <= `SD `NO_DATA;
      LSQ_data_stack[11]    <= `SD `NO_DATA;
      LSQ_data_stack[12]    <= `SD `NO_DATA;
      LSQ_data_stack[13]    <= `SD `NO_DATA;
      LSQ_data_stack[14]    <= `SD `NO_DATA;
      LSQ_data_stack[15]    <= `SD `NO_DATA;

      br_marker_num_stack[ 0] <= `SD 3'b000;
      br_marker_num_stack[ 1] <= `SD 3'b001;
      br_marker_num_stack[ 2] <= `SD 3'b010;
      br_marker_num_stack[ 3] <= `SD 3'b011;

      br_marker_tail_stack[ 0] <= `SD 5'd0;
      br_marker_tail_stack[ 1] <= `SD 5'd0;
      br_marker_tail_stack[ 2] <= `SD 5'd0;
      br_marker_tail_stack[ 3] <= `SD 5'd0;

      LSQ_NPC_stack[ 0]        <= `SD 64'd0;
      LSQ_NPC_stack[ 1]        <= `SD 64'd0;
      LSQ_NPC_stack[ 2]        <= `SD 64'd0;
      LSQ_NPC_stack[ 3]        <= `SD 64'd0;
      LSQ_NPC_stack[ 4]        <= `SD 64'd0;
      LSQ_NPC_stack[ 5]        <= `SD 64'd0;
      LSQ_NPC_stack[ 6]        <= `SD 64'd0;
      LSQ_NPC_stack[ 7]        <= `SD 64'd0;
      LSQ_NPC_stack[ 8]        <= `SD 64'd0;
      LSQ_NPC_stack[ 9]        <= `SD 64'd0;
      LSQ_NPC_stack[10]        <= `SD 64'd0;
      LSQ_NPC_stack[11]        <= `SD 64'd0;
      LSQ_NPC_stack[12]        <= `SD 64'd0;
      LSQ_NPC_stack[13]        <= `SD 64'd0;
      LSQ_NPC_stack[14]        <= `SD 64'd0;
      LSQ_NPC_stack[15]        <= `SD 64'd0;

     
      tail_ptr      	             <= `SD 5'd0;
      LSQ_store_retire_accumulator   <= `SD 4'd0;

    end else begin
/////////////////////retire enable/////////////////////////////////////////////
      if(LSQ_retire_enable && ~stall && ~recovery_en)begin
        LSQ_ld_or_st_stack[tail_ptr[3:0]]     <= `SD 1'b0;  
        LSQ_ready_bit_stack[head_ptr[3:0]]    <= `SD 3'd0;
	LSQ_response_stack[head_ptr[3:0]]     <= `SD 4'd0;
	LSQ_address_stack[head_ptr[3:0]]      <= `SD 64'd0;
 	LSQ_destination_stack[head_ptr[3:0]]  <= `SD 6'd0;
	LSQ_data_stack[head_ptr[3:0]]         <= `SD `NO_DATA;
        if(LSQ_ld_or_st_stack[head_ptr[3:0]]) LSQ_store_retire_accumulator <= `SD LSQ_store_retire_accumulator_minus_one;
      end
/////////////////////PreDecoder Stage//////////////////////////////////////////
//only one store//
      if(~recovery_en && PreDe_store_port1_allocate_en && ~PreDe_store_port2_allocate_en && ~PreDe_load_port1_allocate_en && ~PreDe_load_port2_allocate_en)begin
        LSQ_ready_bit_stack[tail_ptr[3:0]]      <= `SD 3'd0;

        LSQ_ld_or_st_stack[tail_ptr[3:0]]       <= `SD 1'b1;  
        LSQ_NPC_stack[tail_ptr[3:0]]            <= `SD PreDe_store_port1_NPC;
        tail_ptr                                <= `SD tail_plus_one;   
      end
      if(~recovery_en && ~PreDe_store_port1_allocate_en && PreDe_store_port2_allocate_en && ~PreDe_load_port1_allocate_en && ~PreDe_load_port2_allocate_en)begin
        LSQ_ready_bit_stack[tail_ptr[3:0]]      <= `SD 3'd0;

        LSQ_ld_or_st_stack[tail_ptr[3:0]]       <= `SD 1'b1;  
        LSQ_NPC_stack[tail_ptr[3:0]]            <= `SD PreDe_store_port2_NPC;
        tail_ptr                                <= `SD tail_plus_one;   
      end
//only one load//
      if(~recovery_en && PreDe_load_port1_allocate_en && ~PreDe_load_port2_allocate_en && ~PreDe_store_port1_allocate_en && ~PreDe_store_port2_allocate_en)begin
        LSQ_ready_bit_stack[tail_ptr[3:0]]      <= `SD 3'd0;
        LSQ_destination_stack[tail_ptr[3:0]]    <= `SD PreDe_load_port1_destination;
        LSQ_ld_or_st_stack[tail_ptr[3:0]]       <= `SD 1'b0;
        LSQ_NPC_stack[tail_ptr[3:0]]            <= `SD PreDe_load_port1_NPC;
        tail_ptr                                <= `SD tail_plus_one;
      end      
      if(~recovery_en && ~PreDe_load_port1_allocate_en && PreDe_load_port2_allocate_en && ~PreDe_store_port1_allocate_en && ~PreDe_store_port2_allocate_en)begin
        LSQ_ready_bit_stack[tail_ptr[3:0]]      <= `SD 3'd0;
        LSQ_destination_stack[tail_ptr[3:0]]    <= `SD PreDe_load_port2_destination;
        LSQ_ld_or_st_stack[tail_ptr[3:0]]       <= `SD 1'b0;
        LSQ_NPC_stack[tail_ptr[3:0]]            <= `SD PreDe_load_port2_NPC;
        tail_ptr                                <= `SD tail_plus_one;
      end  
//two stores//
      if(~recovery_en && PreDe_store_port1_allocate_en && PreDe_store_port2_allocate_en)begin
        LSQ_ready_bit_stack[tail_ptr[3:0]]       <= `SD 3'd0;

        LSQ_ld_or_st_stack[tail_ptr[3:0]]        <= `SD 1'b1;   
        LSQ_NPC_stack[tail_ptr[3:0]]             <= `SD PreDe_store_port1_NPC;
        LSQ_ready_bit_stack[tail_plus_one[3:0]]  <= `SD 3'd0;

        LSQ_ld_or_st_stack[tail_plus_one[3:0]]   <= `SD 1'b1;  
        LSQ_NPC_stack[tail_plus_one[3:0]]        <= `SD PreDe_store_port2_NPC;
        tail_ptr                                 <= `SD tail_plus_two;   
      end
//two load//
      if(~recovery_en && PreDe_load_port1_allocate_en && PreDe_load_port2_allocate_en)begin
        LSQ_ready_bit_stack[tail_ptr[3:0]]       <= `SD 3'd0;
        LSQ_destination_stack[tail_ptr[3:0]]     <= `SD PreDe_load_port1_destination;
        LSQ_ld_or_st_stack[tail_ptr[3:0]]        <= `SD 1'b0;
        LSQ_NPC_stack[tail_ptr[3:0]]             <= `SD PreDe_load_port1_NPC;
        LSQ_ready_bit_stack[tail_plus_one[3:0]]  <= `SD 3'd0;
        LSQ_destination_stack[tail_plus_one[3:0]]<= `SD PreDe_load_port2_destination;
        LSQ_ld_or_st_stack[tail_plus_one[3:0]]   <= `SD 1'b0;
        LSQ_NPC_stack[tail_plus_one[3:0]]        <= `SD PreDe_load_port2_NPC;
        tail_ptr                                 <= `SD tail_plus_two;
      end  
//store and load//
      if(~recovery_en && PreDe_store_port1_allocate_en && PreDe_load_port2_allocate_en)begin
        LSQ_ready_bit_stack[tail_ptr[3:0]]       <= `SD 3'd0;

        LSQ_ld_or_st_stack[tail_ptr[3:0]]        <= `SD 1'b1;  
        LSQ_NPC_stack[tail_ptr[3:0]]             <= `SD PreDe_store_port1_NPC;
        LSQ_ready_bit_stack[tail_plus_one[3:0]]  <= `SD 3'd0;
        LSQ_destination_stack[tail_plus_one[3:0]]<= `SD PreDe_load_port2_destination;
        LSQ_ld_or_st_stack[tail_plus_one[3:0]]   <= `SD 1'b0;
        LSQ_NPC_stack[tail_plus_one[3:0]]        <= `SD PreDe_load_port2_NPC;
        tail_ptr                                 <= `SD tail_plus_two;
      end 
//load and store//
      if(~recovery_en && PreDe_load_port1_allocate_en && PreDe_store_port2_allocate_en)begin
        LSQ_ready_bit_stack[tail_ptr[3:0]]       <= `SD 3'd0;
        LSQ_destination_stack[tail_ptr[3:0]]     <= `SD PreDe_load_port1_destination;
        LSQ_ld_or_st_stack[tail_ptr[3:0]]        <= `SD 1'b0;
        LSQ_NPC_stack[tail_ptr[3:0]]             <= `SD PreDe_load_port1_NPC;
        LSQ_ready_bit_stack[tail_plus_one[3:0]]  <= `SD 3'd0;

        LSQ_ld_or_st_stack[tail_plus_one[3:0]]   <= `SD 1'b1;
        LSQ_NPC_stack[tail_plus_one[3:0]]        <= `SD PreDe_store_port2_NPC;
        tail_ptr                                 <= `SD tail_plus_two;
      end 


/////////////////////Execution Stage////////////////////////////////////////////
//only one store//
      if(Ex_store_port1_address_en && ~Ex_store_port2_address_en && ~Ex_load_port1_address_en && ~Ex_load_port2_address_en)begin
        LSQ_data_stack[Ex_store_port1_address_insert_position[3:0]]       <= `SD PreDe_store_port1_data;
        LSQ_address_stack[Ex_store_port1_address_insert_position[3:0]]    <= `SD Ex_store_port1_address;
        LSQ_ready_bit_stack[Ex_store_port1_address_insert_position[3:0]]  <= `SD 3'd1;
      end
      if(~Ex_store_port1_address_en && Ex_store_port2_address_en && ~Ex_load_port1_address_en && ~Ex_load_port2_address_en)begin
        LSQ_data_stack[Ex_store_port2_address_insert_position[3:0]]       <= `SD PreDe_store_port2_data;
        LSQ_address_stack[Ex_store_port2_address_insert_position[3:0]]    <= `SD Ex_store_port2_address;
        LSQ_ready_bit_stack[Ex_store_port2_address_insert_position[3:0]]  <= `SD 3'd1;
      end
//only one load//
      if(Ex_load_port1_address_en && ~Ex_load_port2_address_en && ~Ex_store_port1_address_en &&  ~Ex_store_port2_address_en)begin
        LSQ_address_stack[Ex_load_port1_address_insert_position[3:0]]     <= `SD Ex_load_port1_address;
        LSQ_ready_bit_stack[Ex_load_port1_address_insert_position[3:0]]   <= `SD 3'd1;
      end
      if(~Ex_load_port1_address_en && Ex_load_port2_address_en && ~Ex_store_port1_address_en &&  ~Ex_store_port2_address_en)begin
        LSQ_address_stack[Ex_load_port2_address_insert_position[3:0]]     <= `SD Ex_load_port2_address;
        LSQ_ready_bit_stack[Ex_load_port2_address_insert_position[3:0]]   <= `SD 3'd1;
      end
//two stores//
      if(Ex_store_port1_address_en && Ex_store_port2_address_en)begin
        LSQ_data_stack[Ex_store_port1_address_insert_position[3:0]]       <= `SD PreDe_store_port1_data;
        LSQ_address_stack[Ex_store_port1_address_insert_position[3:0]]    <= `SD Ex_store_port1_address;
        LSQ_ready_bit_stack[Ex_store_port1_address_insert_position[3:0]]  <= `SD 3'd1;
        LSQ_data_stack[Ex_store_port2_address_insert_position[3:0]]       <= `SD PreDe_store_port2_data;
        LSQ_address_stack[Ex_store_port2_address_insert_position[3:0]]    <= `SD Ex_store_port2_address;
        LSQ_ready_bit_stack[Ex_store_port2_address_insert_position[3:0]]  <= `SD 3'd1;
      end
//two loads//
      if(Ex_load_port1_address_en && Ex_load_port2_address_en)begin
        LSQ_address_stack[Ex_load_port1_address_insert_position[3:0]]     <= `SD Ex_load_port1_address;
        LSQ_ready_bit_stack[Ex_load_port1_address_insert_position[3:0]]   <= `SD 3'd1;
        LSQ_address_stack[Ex_load_port2_address_insert_position[3:0]]     <= `SD Ex_load_port2_address;
        LSQ_ready_bit_stack[Ex_load_port2_address_insert_position[3:0]]   <= `SD 3'd1;
      end
//store and load//
      if(Ex_store_port1_address_en && Ex_load_port2_address_en)begin
        LSQ_data_stack[Ex_store_port1_address_insert_position[3:0]]       <= `SD PreDe_store_port1_data;
        LSQ_address_stack[Ex_store_port1_address_insert_position[3:0]]    <= `SD Ex_store_port1_address;
        LSQ_ready_bit_stack[Ex_store_port1_address_insert_position[3:0]]  <= `SD 3'd1;
        LSQ_address_stack[Ex_load_port2_address_insert_position[3:0]]     <= `SD Ex_load_port2_address;
        LSQ_ready_bit_stack[Ex_load_port2_address_insert_position[3:0]]   <= `SD 3'd1;
      end
//load and store//
      if(Ex_load_port1_address_en && Ex_store_port2_address_en)begin
        LSQ_address_stack[Ex_load_port1_address_insert_position[3:0]]     <= `SD Ex_load_port1_address;
        LSQ_ready_bit_stack[Ex_load_port1_address_insert_position[3:0]]   <= `SD 3'd1;
        LSQ_data_stack[Ex_store_port2_address_insert_position[3:0]]       <= `SD PreDe_store_port2_data;
        LSQ_address_stack[Ex_store_port2_address_insert_position[3:0]]    <= `SD Ex_store_port2_address;
        LSQ_ready_bit_stack[Ex_store_port2_address_insert_position[3:0]]  <= `SD 3'd1;
      end


/////////////////////Rob retire signal///////////////////////////////////////////
//one store//
      if(Rob_store_port1_retire_en && ~Rob_store_port2_retire_en  ||  ~Rob_store_port1_retire_en && Rob_store_port2_retire_en)begin
        LSQ_store_retire_accumulator         <= `SD LSQ_store_retire_accumulator_plus_one;
      end
//two stores//
      if(Rob_store_port1_retire_en && Rob_store_port2_retire_en)begin
        LSQ_store_retire_accumulator         <= `SD LSQ_store_retire_accumulator_plus_two;
      end
 
/////////////////////Actions for store at the head///////////////////////////////
      if(LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_store_retire_accumulator != 4'd0 && LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd1 && Rob_store_port1_retire_en)begin
        LSQ_ready_bit_stack[head_ptr[3:0]]    <= `SD 3'd2;
      end
      if(LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_store_retire_accumulator != 4'd0 && (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd2 || LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd3) && Dcash_store_valid)begin
        LSQ_ready_bit_stack[head_ptr[3:0]]    <= `SD 3'd7;//
      end
      if(LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_store_retire_accumulator != 4'd0 && (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd2 || LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd3) && !Dcash_store_valid && Dcash_response != 4'd0)begin
        LSQ_ready_bit_stack[head_ptr[3:0]]    <= `SD 3'd4;
        LSQ_response_stack[head_ptr[3:0]]     <= `SD Dcash_response;
      end
      if(LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_store_retire_accumulator != 4'd0 && (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd2 || LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd3) && !Dcash_store_valid && Dcash_response == 4'd0)begin
        LSQ_ready_bit_stack[head_ptr[3:0]]    <= `SD 3'd3;
      end
      if(LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_store_retire_accumulator != 4'd0 && LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd4 && LSQ_response_stack[head_ptr[3:0]] == Dcash_tag)begin
        LSQ_ready_bit_stack[head_ptr[3:0]]    <= `SD 3'd7;//
      end
//      if(LSQ_ld_or_st_stack[head_ptr[3:0]]  && LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd6)begin
//        LSQ_ready_bit_stack[head_ptr[3:0]]    <= `SD 3'd7;
//      end








        
/*      if(LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_store_retire_accumulator != 4'd0 && (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd1 || LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd2) && Dcash_store_valid)begin
        LSQ_ready_bit_stack[head_ptr[3:0]]    <= `SD 3'd6;
      end
      if(LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_store_retire_accumulator != 4'd0 && (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd1 || LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd2) && !Dcash_store_valid && Dcash_response != 4'd0)begin
        LSQ_ready_bit_stack[head_ptr[3:0]]    <= `SD 3'd3;
        LSQ_response_stack[head_ptr[3:0]]     <= `SD Dcash_response;
      end
      if(LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_store_retire_accumulator != 4'd0 && (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd1 || LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd2) && !Dcash_store_valid && Dcash_response == 4'd0)begin
        LSQ_ready_bit_stack[head_ptr[3:0]]    <= `SD 3'd2;
      end
      if(LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_store_retire_accumulator != 4'd0 && LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd3 && LSQ_response_stack[head_ptr[3:0]] == Dcash_tag)begin
        LSQ_ready_bit_stack[head_ptr[3:0]]    <= `SD 3'd6;
      end

      if(LSQ_ld_or_st_stack[head_ptr[3:0]]  && LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd6 && Rob_store_port1_retire_en)begin
        LSQ_ready_bit_stack[head_ptr[3:0]]    <= `SD 3'd7;
      end
*/
/////////////////////Actions for load at the head//////////////////////////////// 
      if(~LSQ_ld_or_st_stack[head_ptr[3:0]] && (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd1 || LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd2) && Dcash_load_valid)begin
        LSQ_ready_bit_stack[head_ptr[3:0]]      <= `SD 3'd7;//
        LSQ_data_stack[head_ptr[3:0]]           <= `SD Dcash_load_valid_data;
      end 
      if(~LSQ_ld_or_st_stack[head_ptr[3:0]] && (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd1 || LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd2) && !Dcash_load_valid && Dcash_response != 4'd0)begin
        LSQ_ready_bit_stack[head_ptr[3:0]]      <= `SD 3'd3;
        LSQ_response_stack[head_ptr[3:0]]       <= `SD Dcash_response;
      end
      if(~LSQ_ld_or_st_stack[head_ptr[3:0]] && (LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd1 || LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd2) && !Dcash_load_valid && Dcash_response == 4'd0)begin
        LSQ_ready_bit_stack[head_ptr[3:0]]      <= `SD 3'd2;
      end
      if(~LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd3 && LSQ_response_stack[head_ptr[3:0]] == Dcash_tag)begin
        LSQ_ready_bit_stack[head_ptr[3:0]]      <= `SD 3'd7;//
        LSQ_data_stack[head_ptr[3:0]]           <= `SD Dcash_tag_data;
      end
     // if(~LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd4)begin
     //   LSQ_ready_bit_stack[head_ptr[3:0]]      <= `SD 3'd5;
     // end
     // if(~stall && ~recovery_en && ~LSQ_ld_or_st_stack[head_ptr[3:0]] && LSQ_ready_bit_stack[head_ptr[3:0]] == 3'd5)begin//
     //   LSQ_ready_bit_stack[head_ptr[3:0]]      <= `SD 3'd7;
     // end


///////////////////recovery process/////////////////////////////////////////////////////////
//only one br_marker//
     if(br_marker_port1_en && ~br_marker_port2_en)begin 
       if(br_marker_port1_num == 3'b000) br_marker_tail_stack[0] <= tail_ptr;
       if(br_marker_port1_num == 3'b001) br_marker_tail_stack[1] <= tail_ptr;
       if(br_marker_port1_num == 3'b010) br_marker_tail_stack[2] <= tail_ptr;
       if(br_marker_port1_num == 3'b011) br_marker_tail_stack[3] <= tail_ptr;
     end
//only one br_marker//
     if(~br_marker_port1_en && br_marker_port2_en)begin
       if(PreDe_load_port1_allocate_en || PreDe_load_port2_allocate_en || PreDe_store_port1_allocate_en || PreDe_store_port2_allocate_en)begin
         if(br_marker_port2_num == 3'b000) br_marker_tail_stack[0] <= tail_plus_one;
         if(br_marker_port2_num == 3'b001) br_marker_tail_stack[1] <= tail_plus_one;
         if(br_marker_port2_num == 3'b010) br_marker_tail_stack[2] <= tail_plus_one;
         if(br_marker_port2_num == 3'b011) br_marker_tail_stack[3] <= tail_plus_one;
       end else begin 
         if(br_marker_port2_num == 3'b000) br_marker_tail_stack[0] <= tail_ptr;
         if(br_marker_port2_num == 3'b001) br_marker_tail_stack[1] <= tail_ptr;
         if(br_marker_port2_num == 3'b010) br_marker_tail_stack[2] <= tail_ptr;
         if(br_marker_port2_num == 3'b011) br_marker_tail_stack[3] <= tail_ptr;
       end
     end
//two br_markers//
     if(br_marker_port1_en && br_marker_port2_en)begin 
       if(br_marker_port1_num == 3'b000) br_marker_tail_stack[0] <= tail_ptr;
       if(br_marker_port1_num == 3'b001) br_marker_tail_stack[1] <= tail_ptr;
       if(br_marker_port1_num == 3'b010) br_marker_tail_stack[2] <= tail_ptr;
       if(br_marker_port1_num == 3'b011) br_marker_tail_stack[3] <= tail_ptr;
       if(br_marker_port2_num == 3'b000) br_marker_tail_stack[0] <= tail_plus_one;
       if(br_marker_port2_num == 3'b001) br_marker_tail_stack[1] <= tail_plus_one;
       if(br_marker_port2_num == 3'b010) br_marker_tail_stack[2] <= tail_plus_one;
       if(br_marker_port2_num == 3'b011) br_marker_tail_stack[3] <= tail_plus_one;
     end

     if(recovery_en)begin 
       if(br_marker_num_stack[ 0] == recovery_br_marker_num) tail_ptr   <= `SD br_marker_tail_stack[ 0];
       if(br_marker_num_stack[ 1] == recovery_br_marker_num) tail_ptr   <= `SD br_marker_tail_stack[ 1];
       if(br_marker_num_stack[ 2] == recovery_br_marker_num) tail_ptr   <= `SD br_marker_tail_stack[ 2];
       if(br_marker_num_stack[ 3] == recovery_br_marker_num) tail_ptr   <= `SD br_marker_tail_stack[ 3];
     end

    end

endmodule




