module GCD (
	input wire CLK,
	input wire RST_N,
	input wire [7:0] A,
	input wire [7:0] B,
	input wire START,
	output reg [7:0] Y,
	output reg [7:0] L,
	output reg [7:0] R,
	output reg DONE,
	output reg ERROR,
	output reg [15:0] LCM
);

wire found, err, swap, relatively_prime;
reg [7:0] reg_a, reg_b, data_a, data_b;
reg [7:0] diff;
reg error_next;
reg [1:0] state, state_next;
parameter [1:0] IDLE = 2'b00;
parameter [1:0] CALC = 2'b01;
parameter [1:0] FINISH = 2'b10;

// [lab] define the signal found here
assign found = (reg_a == reg_b || A == B || reg_a == 1 || reg_b == 1) ? 1'b1:0;
// [lab] define the signal swap here
assign swap = (reg_b > reg_a) ? 1'b1:0;

assign relatively_prime = (reg_a == 1 || reg_b == 1) ? 1'b1:0;

// SWAP
always @* begin
	if (swap) begin
		data_a = reg_b;
		// [lab] define the signal data_b here
		data_b = reg_a;
		// my flag
		L = reg_a;
		R = reg_b;
	end else begin
		// [lab] finish this block
 		data_a = reg_a;
 		data_b = reg_b;
 		// my flag
 		L = reg_a;
 		R = reg_b;
	end
end

// Diff
always @* begin
	diff = data_a - data_b;
end

// calc LCM
always @* begin
	LCM = (A * B) / Y;
end

// D flip flop
// Control value of Y
always @(posedge CLK or negedge RST_N)
begin
	if (!RST_N) begin
		Y = 0;
	end else if (found && relatively_prime) begin
		Y = 1'b1;
	end else if (ERROR) begin
		Y = 0;
		data_a = 0;
	end else begin
		Y = data_a;
	end
end

// D flip flop with MUX
// Pass A & B to reg_a & reg_b
always @(posedge CLK or negedge RST_N)
begin
	if (!RST_N) begin
		reg_a = 0;
		reg_b = 0;
	end else if (START) begin
		reg_a = A;
		reg_b = B;
	end else begin
// [lab] finish this block
		reg_a = diff;
		reg_b = data_b;
	end
end

// FSM: State register
// D-FF with clk, so using 'Nonblocking'
always @(posedge CLK or negedge RST_N) begin
	if (RST_N == 0) begin
		state <= IDLE;
		ERROR <= 0;
	end else begin
		state <= state_next;
		ERROR <= error_next;
	end
end

// FSM: Next State Logic
// combinational so using 'blocking'
always @* begin
	case (state)
		IDLE: begin
			DONE = 0;
			if (START) begin
				state_next = CALC;
				error_next = (A == 0 || B == 0) ? 1'b1 : 0;
			end else begin
				state_next = IDLE;
				error_next = 0;
			end
		end

		CALC: begin
		// [lab] finish this block
			if (found || ERROR) begin
				state_next = FINISH;
			end else begin
				state_next = CALC;
				error_next = 0;
			end
		end

		FINISH: begin
		// [lab] finish this block
		 	DONE = 1'b1;
			state_next = IDLE;
			error_next = 0;
		end

		default: begin
			DONE = 0;
			state_next = IDLE;
			error_next = 0;
		end
	endcase
end
endmodule

