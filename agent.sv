class agent extends uvm_agent;
	`uvm_component_utils(agent)

	my_sequencer sqr;
	driver drvr;
	receiver rcvr;

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rcvr = receiver::type_id::create("rcvr",this);
		if(get_is_active() == UVM_ACTIVE) begin
			sqr = my_sequencer::type_id::create("sqr",this);
			drvr = driver::type_id::create("drvr",this);
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		if(get_is_active() == UVM_ACTIVE)
			drvr.seq_item_port.connect(sqr.seq_item_export);
	endfunction
endclass
