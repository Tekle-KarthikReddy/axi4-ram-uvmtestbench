module ram_design #(parameter addr_width =4,data_width=32,depth=16)(
	input clk,rst,wr_en,
	input [addr_width-1:0] addr,
	input [data_width-1:0] wdata,
	output reg [data_width-1:0] rdata);

reg [data_width-1:0] mem[0:depth-1];
integer i;
initial for(i=0;i<depth;i=i+1) mem[i] =0;

always@(posedge clk) begin
	if(rst)
		rdata<=0;
	else if(wr_en)
		mem[addr] <=wdata;
	else
		rdata <= mem[addr];
end
endmodule


module ram_axi_design#(parameter addr_width=4,data_width=32,depth=16)(
	input aclk,
	input arst,

	input [addr_width-1:0] axi_awaddr,
	input axi_awvalid,
	output reg axi_awready,

	input [data_width-1:0] axi_wdata,
	input axi_wvalid,
	output reg axi_wready,

	output reg [1:0] axi_bresp,
	output reg axi_bvalid,
	input axi_bready,

	input [addr_width-1:0] axi_araddr,
	input axi_arvalid,
	output reg axi_arready,

	output reg [data_width-1:0] axi_rdata,
	output reg [1:0] axi_rresp,
	output reg  axi_rvalid,
	input axi_rready);

localparam resp_okay =2'b00;
localparam resp_slv_err =2'b10;

localparam idle = 2'b00;
localparam write = 2'b01;
localparam read = 2'b10;
localparam resp = 2'b11;

reg [1:0] write_state,read_state;
reg [addr_width-1:0] write_addr_reg,read_addr_reg;

wire wr_fire = (write_state == write) && axi_wvalid && axi_wready;
wire ram_write_en = wr_fire;
wire [addr_width-1:0] ram_addr = wr_fire ? write_addr_reg : read_addr_reg;
wire [data_width-1:0] ram_write_data = axi_wdata;
wire [data_width-1:0] ram_read_data;

ram_design #(.addr_width(addr_width),.data_width(data_width),.depth(depth))
dut (.clk(aclk),.rst(arst),.wr_en(ram_write_en),.addr(ram_addr),.wdata(ram_write_data),.rdata(ram_read_data));

always @(posedge aclk) begin
	if(arst) begin
		axi_awready <= 1'b0;
		axi_wready <= 1'b0;
		axi_bvalid <= 1'b0;
		axi_bresp <= resp_okay;
		write_addr_reg <= {addr_width{1'b0}};
		write_state <= idle;
	end
	else begin
		case(write_state)
			idle: begin
				axi_awready <= 1'b1;
				if(axi_awvalid && axi_awready) begin
					write_addr_reg  <= axi_awaddr;
					axi_awready <= 1'b0;
					axi_wready <= 1'b1;
					write_state <= write;
				end
			end
			write: begin
				if(axi_wvalid && axi_wready) begin
					axi_wready <= 1'b0;
					write_state <= resp;
				end
			end
			resp: begin
				if(!axi_bvalid) begin
					axi_bvalid <= 1'b1;
					axi_bresp <= resp_okay;
				end
				else if(axi_bready) begin
					axi_bvalid <= 1'b0;
					write_state <= idle;
				end
			end
			default: write_state <= idle;
		endcase
	end
end

always @(posedge aclk) begin
	if(arst) begin
		axi_arready <= 1'b0;
		axi_rvalid <= 1'b0;
		axi_rdata <= {data_width{1'b0}};
		axi_rresp <= resp_okay;
		read_addr_reg <= {addr_width{1'b0}};
		read_state <= idle;
	end
	else begin
		case(read_state)
			idle: begin
				axi_arready <= 1'b1;
				if(axi_arvalid && axi_arready) begin
					read_addr_reg <= axi_araddr;
					axi_arready <= 1'b0;
					read_state <= read;
				end
			end
			read: begin
				read_state <= resp;
			end
			resp: begin
				if(!axi_rvalid) begin
					axi_rvalid <= 1'b1;
					axi_rdata <= ram_read_data;
					axi_rresp <= resp_okay;
				end
				else if(axi_rready) begin
					axi_rvalid <= 1'b0;
					read_state <= idle;
				end
			end
			default: read_state <= idle;
		endcase
	end
end
endmodule
