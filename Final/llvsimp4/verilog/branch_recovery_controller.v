module branch_recovery_controller(reset, clock,
                                  wr_enable_1, wr_enable_2, cl_enable_1, cl_enable_2, cl_enable_3, cl_enable_4, cl_position_1, cl_position_2, cl_position_3, cl_position_4,
                                  next_br_marker_1, next_br_marker_2, next_bmask1, next_bmask2, bmask,
                                  str_hazard);

input reset;
input clock;

input wr_enable_1;
input wr_enable_2;

input cl_enable_1;
input cl_enable_2;
input cl_enable_3;
input cl_enable_4;
input [1:0] cl_position_1;
input [1:0] cl_position_2;
input [1:0] cl_position_3;
input [1:0] cl_position_4;

output [2:0] next_br_marker_1;
output [2:0] next_br_marker_2;
output [3:0] next_bmask1;
output [3:0] next_bmask2;
reg    [3:0] bmask1;
reg    [3:0] bmask2;

reg    [1:0] freelist [5:0];
reg    [2:0] pointer;
reg    [2:0] next_pointer;
output [1:0] str_hazard;
wire   [1:0] str_hazard;
wire   [1:0] emp_hazard;

reg [2:0] next_br_marker;
output reg [3:0] bmask;
reg [3:0] next_bmask;

assign wr_en = wr_enable_1 | wr_enable_2;
assign next_br_marker_1 = wr_enable_1 ? next_br_marker : `BR_MARKER_EMPTY;
assign next_br_marker_2 = wr_enable_2 ? next_br_marker : `BR_MARKER_EMPTY;
assign next_bmask1 = wr_enable_1 ? next_bmask : bmask;
assign next_bmask2 = wr_en? next_bmask :bmask;                     

assign str_hazard = (pointer == 5'd4)?`BRC_STR_HAZ_FULL:
                    (pointer == 5'd3)?`BRC_STR_HAZ_ONE_SLOT:
                                       `BRC_STR_HAZ_NONE;
assign emp_hazard = (pointer == 5'd0)?`BRC_EMP_HAZ_EMPTY:
                    (pointer == 5'd1)?`BRC_EMP_HAZ_ONE_SLOT:
                                      `BRC_EMP_HAZ_2orM;

reg [2:0] clear_num;
always@* begin
  clear_num = 0;
  if(cl_enable_1 | cl_enable_2 | cl_enable_3 | cl_enable_4) clear_num = 1;
  if( (cl_enable_1 & cl_enable_2) | (cl_enable_1 & cl_enable_3) | (cl_enable_1 & cl_enable_4) | (cl_enable_2 & cl_enable_3) | (cl_enable_2 & cl_enable_4) | (cl_enable_3 & cl_enable_4) ) clear_num = 2;
  if( (cl_enable_1 & cl_enable_2 & cl_enable_3) | (cl_enable_1 & cl_enable_2 & cl_enable_4) | (cl_enable_1 & cl_enable_3 & cl_enable_4) | (cl_enable_2 & cl_enable_3 & cl_enable_4) ) clear_num = 3;
  if( cl_enable_1 & cl_enable_2 & cl_enable_3 & cl_enable_4 ) clear_num = 4;
end


//NEXT_POINTER
always@* begin
  next_pointer = pointer;
  case (str_hazard)
    `BRC_STR_HAZ_FULL: begin
      if (clear_num == 1) next_pointer = pointer - 1;
      if (clear_num == 2) next_pointer = pointer - 2;
      if (clear_num == 3) next_pointer = pointer - 3;
      if (clear_num == 4) next_pointer = pointer - 4;
     end
    `BRC_STR_HAZ_ONE_SLOT: begin
      if(wr_en) begin
        if (clear_num == 0) next_pointer = pointer + 1;
        if (clear_num == 2) next_pointer = pointer - 1;
        if (clear_num == 3) next_pointer = pointer - 2;
        if (clear_num == 4) next_pointer = pointer - 3;
      end else begin
        if (clear_num == 1) next_pointer = pointer - 1;
        if (clear_num == 2) next_pointer = pointer - 2;
        if (clear_num == 3) next_pointer = pointer - 3;
      end
     end
    `BRC_STR_HAZ_NONE: begin
      case(emp_hazard)
        `BRC_EMP_HAZ_EMPTY: begin
           if(wr_en)        next_pointer = pointer + 1;
         end
        `BRC_EMP_HAZ_ONE_SLOT: begin
           if(wr_en) begin
             if (clear_num == 0) next_pointer = pointer + 1;
             if (clear_num == 2) next_pointer = pointer - 1;
           end else begin
             if (clear_num == 1) next_pointer = pointer - 1;
           end
         end
        default: begin
          if(wr_en) begin
            if (clear_num == 0) next_pointer = pointer + 1;
            if (clear_num == 2) next_pointer = pointer - 1;
            if (clear_num == 3) next_pointer = pointer - 2;
          end else begin
            if (clear_num == 1) next_pointer = pointer - 1;
            if (clear_num == 2) next_pointer = pointer - 2;
          end
        end
      endcase
    end
  endcase
end


//POINTER
always@(posedge clock) begin
  if(reset) pointer <= `SD 0;
  else begin
    pointer <= `SD next_pointer;
  end
end


//FREELIST
always@(posedge clock) begin
  if(reset) begin
    freelist[0] <= `SD 2'd0;
    freelist[1] <= `SD 2'd1;
    freelist[2] <= `SD 2'd2;
    freelist[3] <= `SD 2'd3;
    freelist[4] <= `SD 2'd0;
    freelist[5] <= `SD 2'd0;
  end
  else if(wr_en) begin
    case ( clear_num )
     2:begin
         if(cl_enable_1 & cl_enable_2) freelist[next_pointer] <= `SD cl_position_1;
         if(cl_enable_1 & cl_enable_3) freelist[next_pointer] <= `SD cl_position_1;
         if(cl_enable_1 & cl_enable_4) freelist[next_pointer] <= `SD cl_position_1;
         if(cl_enable_2 & cl_enable_3) freelist[next_pointer] <= `SD cl_position_2;
         if(cl_enable_2 & cl_enable_4) freelist[next_pointer] <= `SD cl_position_2;
         if(cl_enable_3 & cl_enable_4) freelist[next_pointer] <= `SD cl_position_3;
       end
     3:begin
         if(!cl_enable_1) begin
           freelist[next_pointer  ] <= `SD cl_position_2;
           freelist[next_pointer+1] <= `SD cl_position_3;
         end
         if(!cl_enable_2) begin
           freelist[next_pointer  ] <= `SD cl_position_1;
           freelist[next_pointer+1] <= `SD cl_position_3;
         end
         if(!cl_enable_3) begin
           freelist[next_pointer  ] <= `SD cl_position_1;
           freelist[next_pointer+1] <= `SD cl_position_2;
         end
         if(!cl_enable_4) begin
           freelist[next_pointer  ] <= `SD cl_position_1;
           freelist[next_pointer+1] <= `SD cl_position_2;
         end
       end
     4:begin
           freelist[next_pointer  ] <= `SD cl_position_1;
           freelist[next_pointer+1] <= `SD cl_position_2;
           freelist[next_pointer+2] <= `SD cl_position_3;
     end
    endcase
  end
  else begin
    case ( clear_num )
     1:begin
         if(cl_enable_1) freelist[next_pointer] <= `SD cl_position_1;
         if(cl_enable_2) freelist[next_pointer] <= `SD cl_position_2;
         if(cl_enable_3) freelist[next_pointer] <= `SD cl_position_3;
         if(cl_enable_4) freelist[next_pointer] <= `SD cl_position_4;
       end
     2:begin
         if(cl_enable_1 & cl_enable_2) begin freelist[next_pointer] <= `SD cl_position_1; freelist[next_pointer+1] <= `SD cl_position_2; end
         if(cl_enable_1 & cl_enable_3) begin freelist[next_pointer] <= `SD cl_position_1; freelist[next_pointer+1] <= `SD cl_position_3; end
         if(cl_enable_1 & cl_enable_4) begin freelist[next_pointer] <= `SD cl_position_1; freelist[next_pointer+1] <= `SD cl_position_4; end
         if(cl_enable_2 & cl_enable_3) begin freelist[next_pointer] <= `SD cl_position_2; freelist[next_pointer+1] <= `SD cl_position_3; end
         if(cl_enable_2 & cl_enable_4) begin freelist[next_pointer] <= `SD cl_position_2; freelist[next_pointer+1] <= `SD cl_position_4; end
         if(cl_enable_3 & cl_enable_4) begin freelist[next_pointer] <= `SD cl_position_3; freelist[next_pointer+1] <= `SD cl_position_4; end
       end
     3:begin
         if(!cl_enable_1) begin freelist[next_pointer] <= `SD cl_position_2; freelist[next_pointer+1] <= `SD cl_position_3; freelist[next_pointer+2] <= `SD cl_position_4; end
         if(!cl_enable_2) begin freelist[next_pointer] <= `SD cl_position_1; freelist[next_pointer+1] <= `SD cl_position_3; freelist[next_pointer+2] <= `SD cl_position_4; end
         if(!cl_enable_3) begin freelist[next_pointer] <= `SD cl_position_1; freelist[next_pointer+1] <= `SD cl_position_2; freelist[next_pointer+2] <= `SD cl_position_4; end
         if(!cl_enable_4) begin freelist[next_pointer] <= `SD cl_position_1; freelist[next_pointer+1] <= `SD cl_position_2; freelist[next_pointer+2] <= `SD cl_position_3; end
       end
     4:begin
           freelist[next_pointer  ] <= `SD cl_position_1;
           freelist[next_pointer+1] <= `SD cl_position_2;
           freelist[next_pointer+2] <= `SD cl_position_3;
           freelist[next_pointer+3] <= `SD cl_position_4;
     end
    endcase
  end
end

//NEXT_BMASK
always@* begin
  next_br_marker = `BR_MARKER_EMPTY;
  next_bmask = bmask;
  if(wr_en) begin
    case ( clear_num )
     0:begin
         next_bmask[freelist[pointer]] = 1'd1;
         next_br_marker = freelist[pointer];
       end
     1:begin
         if(cl_enable_1) next_br_marker = cl_position_1;
         if(cl_enable_2) next_br_marker = cl_position_2;
         if(cl_enable_3) next_br_marker = cl_position_3;
         if(cl_enable_4) next_br_marker = cl_position_4;
       end
     2:begin
         if(cl_enable_1 & cl_enable_2) begin
           next_bmask[cl_position_1] = 1'd0;
           next_br_marker = cl_position_2;
         end
         if(cl_enable_1 & cl_enable_3) begin
           next_bmask[cl_position_1] = 1'd0;
           next_br_marker = cl_position_3;
         end
         if(cl_enable_1 & cl_enable_4) begin
           next_bmask[cl_position_1] = 1'd0;
           next_br_marker = cl_position_4;
         end
         if(cl_enable_2 & cl_enable_3) begin
           next_bmask[cl_position_2] = 1'd0;
           next_br_marker = cl_position_3;
         end
         if(cl_enable_2 & cl_enable_4) begin
           next_bmask[cl_position_2] = 1'd0;
           next_br_marker = cl_position_4;
         end
         if(cl_enable_3 & cl_enable_4) begin
           next_bmask[cl_position_3] = 1'd0;
           next_br_marker = cl_position_4;
         end
       end
     3:begin
         if(!cl_enable_1) begin
           next_bmask[cl_position_2] = 1'd0;
           next_bmask[cl_position_3] = 1'd0;
           next_br_marker = cl_position_4;
         end
         if(!cl_enable_2) begin
           next_bmask[cl_position_1] = 1'd0;
           next_bmask[cl_position_3] = 1'd0;
           next_br_marker = cl_position_4;
         end
         if(!cl_enable_3) begin
           next_bmask[cl_position_1] = 1'd0;
           next_bmask[cl_position_2] = 1'd0;
           next_br_marker = cl_position_4;
         end
         if(!cl_enable_4) begin
           next_bmask[cl_position_1] = 1'd0;
           next_bmask[cl_position_2] = 1'd0;
           next_br_marker = cl_position_3;
         end
       end
     4:begin
         next_bmask[cl_position_1] = 1'd0;
         next_bmask[cl_position_2] = 1'd0;
         next_bmask[cl_position_3] = 1'd0;
         next_br_marker = cl_position_4;
       end
    endcase
  end else begin
    case ( clear_num )
     1:begin
         if(cl_enable_1) next_bmask[cl_position_1] = 1'd0;
         if(cl_enable_2) next_bmask[cl_position_2] = 1'd0;
         if(cl_enable_3) next_bmask[cl_position_3] = 1'd0;
         if(cl_enable_4) next_bmask[cl_position_4] = 1'd0;
       end
     2:begin
         if(cl_enable_1 & cl_enable_2) begin
           next_bmask[cl_position_1] = 1'd0;
           next_bmask[cl_position_2] = 1'd0;
         end
         if(cl_enable_1 & cl_enable_3) begin
           next_bmask[cl_position_1] = 1'd0;
           next_bmask[cl_position_3] = 1'd0;
         end
         if(cl_enable_1 & cl_enable_4) begin
           next_bmask[cl_position_1] = 1'd0;
           next_bmask[cl_position_4] = 1'd0;
         end
         if(cl_enable_2 & cl_enable_3) begin
           next_bmask[cl_position_2] = 1'd0;
           next_bmask[cl_position_3] = 1'd0;
         end
         if(cl_enable_2 & cl_enable_4) begin
           next_bmask[cl_position_2] = 1'd0;
           next_bmask[cl_position_4] = 1'd0;
         end
         if(cl_enable_3 & cl_enable_4) begin
           next_bmask[cl_position_3] = 1'd0;
           next_bmask[cl_position_4] = 1'd0;
         end
       end
     3:begin
         if(!cl_enable_1) begin next_bmask[cl_position_2] = 1'd0;  next_bmask[cl_position_3] = 1'd0;  next_bmask[cl_position_4] = 1'd0; end
         if(!cl_enable_2) begin next_bmask[cl_position_1] = 1'd0;  next_bmask[cl_position_3] = 1'd0;  next_bmask[cl_position_4] = 1'd0; end
         if(!cl_enable_3) begin next_bmask[cl_position_1] = 1'd0;  next_bmask[cl_position_2] = 1'd0;  next_bmask[cl_position_4] = 1'd0; end
         if(!cl_enable_4) begin next_bmask[cl_position_1] = 1'd0;  next_bmask[cl_position_2] = 1'd0;  next_bmask[cl_position_3] = 1'd0; end
       end
     4:begin
        next_bmask[cl_position_1] = 1'd0;
        next_bmask[cl_position_2] = 1'd0;
        next_bmask[cl_position_3] = 1'd0;
        next_bmask[cl_position_4] = 1'd0;
     end
    endcase
  end
end


//BMASK
always@(posedge clock) begin
  if(reset) bmask <= `SD 0;
  else bmask      <= `SD next_bmask;
end
  
endmodule
