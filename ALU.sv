// ALU Design
module ALU (output reg [3:0] F,
            output reg Z,
            output reg V,
            output reg C,
            input wire Xin,
            input wire [3:0] A,
            input wire [3:0] B,
            input wire [2:0] S);
  integer i;
  
  always @ (A, B, S, Xin, Z) begin
    case(S)
      3'b000 : F = A + A;
      3'b001 : F = A / 4'b0010;
      3'b010 : F = A * B;
      3'b011 : F = A + B + Xin;
      3'b100 : F = A - B + Xin;
      3'b101 : F = B - A + Xin;
      3'b110 : F = A ^ B;
      3'b111 : 
        begin
          for (i = 0; i < 4; i = i + 1) begin
            if(A[i] < B[i]) begin
              F[i] = 1;
            end
            else begin
              F[i] = 0;
            end
          end
        end
      default : F = 4'b0000;
    endcase
  end
  
  always @ (Z, V, F, C, S, A, B, Xin) begin
    Z = (F == 4'b0000);
    V = (((A + A) > 15) && S == 0)   || 
        ((A%2 == 1)     && S == 1)   || 
        (((A*B) > 15)   && S == 2)   || 
        ((A+B+Xin > 15) && S == 3)   || 
        ((A-B+Xin > 15) && (S == 4)) || 
        ((B-A+Xin > 15) && (S == 5));
    C = ((A+B+Xin > 15) && S == 3)   || 
        ((A-B+Xin > 15) && (S == 4)) || 
        ((B-A+Xin > 15) && (S == 5));
  end
  
endmodule
