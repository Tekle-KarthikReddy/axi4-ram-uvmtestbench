`include "interface.sv"
`include "axi_pkg.sv"

module test_top;
 import uvm_pkg::*;
 import axi_pkg::*;
 `include "uvm_macros.svh"
 parameter clk_simulation =100;
 bit sys_clk;

 infc top_io(sys_clk);
 virtual infc.tb tb_vif;

 ram_axi_design dut(.aclk(top_io.aclk),
	.arst(top_io.arst),
	.axi_awaddr(top_io.axi_awaddr),
	.axi_awvalid(top_io.axi_awvalid),
	.axi_awready(top_io.axi_awready),
	.axi_wdata(top_io.axi_wdata),
	.axi_wvalid(top_io.axi_wvalid),
	.axi_wready(top_io.axi_wready),
	.axi_bresp(top_io.axi_bresp),
	.axi_bvalid(top_io.axi_bvalid),
	.axi_bready(top_io.axi_bready),
	.axi_araddr(top_io.axi_araddr),
	.axi_arvalid(top_io.axi_arvalid),
	.axi_arready(top_io.axi_arready),
	.axi_rdata(top_io.axi_rdata),
	.axi_rresp(top_io.axi_rresp),
	.axi_rvalid(top_io.axi_rvalid),
	.axi_rready(top_io.axi_rready)
 );

 initial begin
	sys_clk=0;
	forever begin
		#(clk_simulation/2)
		sys_clk=~sys_clk;
	end
 end

 initial begin
	tb_vif = top_io.tb;
	uvm_config_db#(virtual infc.tb)::set(null,"*","vif",tb_vif);
	run_test("test");
 end
endmodule
