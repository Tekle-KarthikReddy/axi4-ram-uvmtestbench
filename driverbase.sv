class driverbase extends uvm_driver#(seq_item);
	virtual infc.tb rtr_io;
	logic [3:0] addr;
	int  w_data;
	int  r_data;

	extern function new(string name, uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task send();
	extern virtual task write();
	extern virtual task read();
endclass

function driverbase::new(string name, uvm_component parent);
	super.new(name,parent);
endfunction

function void driverbase::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual infc.tb)::get(this,"","vif",this.rtr_io))
		`uvm_fatal("DRV","virtual interface'vif' not set")
endfunction

task driverbase::send();
	this.write();
	this.read();
endtask

task driverbase::write();
	@(this.rtr_io.cb);
	this.rtr_io.cb.axi_awaddr <= this.addr;
	this.rtr_io.cb.axi_awvalid <= 1'b1;
	do begin @(this.rtr_io.cb); end while(this.rtr_io.cb.axi_awready !== 1'b1);
	this.rtr_io.cb.axi_awvalid <= 1'b0;

	this.rtr_io.cb.axi_wdata <= this.w_data;
	this.rtr_io.cb.axi_wvalid <= 1'b1;
	do begin @(this.rtr_io.cb); end while(this.rtr_io.cb.axi_wready !== 1'b1);
	this.rtr_io.cb.axi_wvalid <= 1'b0;

	this.rtr_io.cb.axi_bready <= 1'b1;
	do begin @(this.rtr_io.cb); end while(this.rtr_io.cb.axi_bvalid !== 1'b1);
	this.rtr_io.cb.axi_bready <= 1'b0;
	if(this.rtr_io.cb.axi_bresp !==2'b00)
		$display("[write] BRESP error addr=%0h resp =%0b",addr,this.rtr_io.cb.axi_bresp);
	$display("[write] addr = %0h data = %0h",addr,w_data);
endtask

task driverbase::read();
	@(this.rtr_io.cb);
	this.rtr_io.cb.axi_araddr <= this.addr;
	this.rtr_io.cb.axi_arvalid <= 1'b1;
	do begin @(this.rtr_io.cb); end while(this.rtr_io.cb.axi_arready !== 1'b1);
	this.rtr_io.cb.axi_arvalid <= 1'b0;

	this.rtr_io.cb.axi_rready <= 1'b1;
	do begin @(this.rtr_io.cb); end while(this.rtr_io.cb.axi_rvalid !== 1'b1);
	this.r_data = this.rtr_io.cb.axi_rdata;
	this.rtr_io.cb.axi_rready <= 1'b0;
	$display("[read] addr = %0h data = %0h",addr,r_data);
endtask
