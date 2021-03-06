//Module Written By: Josh Smith

module pa2_fsm(
  input  wire       clock,
  input  wire       reset,
  input  wire       valid,
  input  wire [3:0] num,
  input  wire [3:0] seq,
  output reg  [1:0] state,
  output reg  [1:0] n_state, 
  output reg  [3:0] cnt,
  output wire [3:0] n_cnt,
  output wire       hit
  
  );

  parameter WAIT=2'h0, WATCH=2'h1, ASSERT=2'h2;

  wire       cnt_inc, cnt_dec;

  // Control/output logic
  assign cnt_inc = (state == WATCH) && (seq==num); //bug
  assign cnt_dec = (state == ASSERT);
  assign n_cnt   = cnt_inc ? cnt + 4'h1 :
                   cnt_dec ? cnt - 4'h1 : cnt;

  assign hit = (state == ASSERT);

  // Next-state logic
  always @* begin 
    case(state)
      WAIT:
        if (valid) n_state = WATCH;
        else       n_state = WAIT;

      WATCH:
        if (!valid) n_state = (n_cnt==0) ? WAIT : ASSERT;
        else        n_state = WATCH;

      ASSERT:
        // check >1, because if we decrement to 0 we'll assert
        // hit one time too many
        if (cnt>4'h1) n_state = ASSERT;
        else          n_state = WAIT;
    
      default: n_state = WAIT;
    endcase
  end

  always @(posedge clock) begin
    if (reset) begin
      state <= #1 WAIT;
      cnt   <= #1 4'h0;
    end else begin
      state <= #1 n_state;
      cnt   <= #1 n_cnt;
    end
  end

endmodule
