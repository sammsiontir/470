module ps4(req, en, gnt);
  input [3:0] req;
  input en;
  output [3:0] gnt;

  reg [3:0] gnt;

  always @*
  begin
    if (en & req[3]) gnt = 4'b1000;
    else if (en & req[2]) gnt = 4'b0100;
    else if (en & req[1]) gnt = 4'b0010;
    else if (en & req[0]) gnt = 4'b0001;
    else gnt = 4'b0000;
  end

endmodule

