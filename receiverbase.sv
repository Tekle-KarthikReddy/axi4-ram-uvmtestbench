class receiverbase extends uvm_monitor;
	virtual infc.tb rtr_io;
	seq_item trans1;

	extern function new(string name,uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task recv();
endclass

function receiverbase::new(string name, uvm_component parent);
	super.new(name,parent);
endfunction

function void receiverbase::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual infc.tb)::get(this,"","vif",this.rtr_io))
		`uvm_fatal("RCV","Virtual interfacs 'vif' not set")
	this.trans1 = seq_item::type_id::create("trans1");
endfunction

task receiverbase::recv();
	do begin @(this.rtr_io.mcb); end
	while(!(this.rtr_io.mcb.axi_arvalid === 1'b1 && this.rtr_io.mcb.axi_arready === 1'b1));
	this.trans1.addr = this.rtr_io.mcb.axi_araddr;

	do begin @(this.rtr_io.mcb); end
	while (!(this.rtr_io.mcb.axi_rvalid === 1'b1 && this.rtr_io.mcb.axi_rready === 1'b1));
	this.trans1.r_data=this.rtr_io.mcb.axi_rdata;
endtask
