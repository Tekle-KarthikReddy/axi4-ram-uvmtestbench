interface infc(input aclk);
	logic arst;
	logic [3:0] axi_awaddr;
	logic axi_awvalid;
	logic axi_awready;
	logic [31:0] axi_wdata;
	logic axi_wvalid;
	logic axi_wready;
	logic [1:0] axi_bresp;
	logic axi_bvalid;
	logic axi_bready;
	logic [3:0] axi_araddr;
	logic axi_arvalid;
	logic axi_arready;
	logic [31:0] axi_rdata;
	logic [1:0] axi_rresp;
	logic axi_rvalid;
	logic axi_rready;

	clocking cb @(posedge aclk);
		output  axi_awaddr;
		output axi_awvalid;
		input axi_awready;
		output  axi_wdata;
		output axi_wvalid;
		input axi_wready;
		input axi_bresp;
		input axi_bvalid;
		output axi_bready;
		output  axi_araddr;
		output axi_arvalid;
		input axi_arready;
		input  axi_rdata;
		input  axi_rresp;
		input axi_rvalid;
		output axi_rready;
	endclocking

	clocking mcb @(posedge aclk);
		input  axi_awaddr;
		input axi_awvalid;
		input axi_awready;
		input  axi_wdata;
		input axi_wvalid;
		input axi_wready;
		input axi_bresp;
		input axi_bvalid;
		input axi_bready;
		input  axi_araddr;
		input axi_arvalid;
		input axi_arready;
		input  axi_rdata;
		input  axi_rresp;
		input axi_rvalid;
		input axi_rready;
	endclocking


	modport tb(clocking cb,clocking mcb,output arst);
endinterface
