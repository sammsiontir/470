module rps4(clock, reset, req, en, gnt, count);
  input clock, reset;
  input [3:0] req;
  input en;
  output [3:0] gnt;
  output [1:0] count;

  wire [1:0] tmp_en;
  wire [1:0] tmp_req;
  reg [1:0] count;

  always @(posedge clock)
  begin
    if (reset) count <= 2'b00;
    else count <= count+1;
  end


  rps2 left(.req(req[3:2]), .en(tmp_en[1]), .gnt(gnt[3:2]), .req_up(tmp_req[1]), .sel(count[0]) );
  rps2 right(.req(req[1:0]), .en(tmp_en[0]), .gnt(gnt[1:0]), .req_up(tmp_req[0]), .sel(count[0]) );
  rps2 top(.req(tmp_req), .en(en), .gnt(tmp_en), .req_up(), .sel(count[1]) );


endmodule

module rps2(req, en, gnt, req_up, sel);
  input [1:0] req;
  input en, sel;
  output req_up;
  output [1:0] gnt;

  reg [1:0] gnt;
  reg req_up;

  always @*
  begin
    if (sel)
    begin
      if (en & req[1]) gnt = 2'b10;
      else if (en & req[0]) gnt = 2'b01;
      else gnt = 2'b00;
    end
    else 
    begin
      if (en & req[0]) gnt = 2'b01;
      else if (en & req[1]) gnt = 2'b10;
      else gnt = 2'b00;
    end
    req_up = req[0] | req[1];
  end

endmodule

