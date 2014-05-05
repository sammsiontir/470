module ISR(reset, 
           value, 
           clock, 
           result, 
           done
);
  input wire reset;
  input wire [63:0] value;
  input wire clock;
  output wire [31:0] result;
  output wire done;

  parameter RESET  = 2'd0;
  parameter CHECK  = 2'd1;
  parameter MULT   = 2'd2;
  parameter DONE   = 2'd3;

  reg [2:0]   state;
  reg [2:0]   next_state;

  reg [6:0]   counter;
  reg [6:0]   next_counter;

  reg [31:0]  guess;
  reg [31:0]  next_guess;

  reg [63:0]  target;

  reg         start;
  reg         next_start;

  wire        mult_done;
  wire [63:0] mult_product;

  wire        larger;
  wire [63:0] mcand = {32'b0,guess};

  mult #(.TBIT(64), .NSTAGE(2) ) m1(.clock(clock), 
                                    .reset(reset), 
                                    .mplier(mcand), 
                                    .mcand(mcand), 
                                    .start(start), 
                                    .product(mult_product), 
                                    .done(mult_done));
  assign done   = (state==DONE)? 1:0;
  assign result = (state==DONE)? guess:32'd0;
  assign larger = (mult_product > target)? 1:0;

  always@* begin
    case (state)
      RESET: begin
        next_state   = reset? RESET:MULT;
        next_counter = counter;
        next_guess  = 32'h8000_0000;
        next_start = 1;
      end

      CHECK: begin
        next_state = reset? RESET:
                     !counter? DONE:
                     MULT;
        next_counter = counter-1;
        next_guess = guess;
        next_guess[counter]  = (larger)? 0:1;
        next_guess[counter-1] = 1;

        next_start   = 1;
      end

      MULT: begin
        next_state = reset? RESET:
                     mult_done? CHECK:
                     MULT;
        next_counter = counter;
        next_guess = guess;
        next_start = 0;
      end

      DONE: begin
        next_state = reset? RESET:DONE;
        next_counter = counter;
        next_guess = guess;
        next_start = 0;
      end

      default: begin
        next_state = reset? RESET:DONE;
        next_counter = counter;
        next_guess = guess;
        next_start = 0;
      end
    endcase
  end

  always@ (posedge clock) begin
    if (reset) begin
      state   <= RESET;
      counter <= 7'd31;
      guess   <= 32'd0;
      start   <= 1'd0;
      target  <= value;
    end
    else begin
      state   <= next_state;
      counter <= next_counter;
      guess   <= next_guess;
      start   <= next_start;
      target  <= target;
    end
  end 
  
endmodule

