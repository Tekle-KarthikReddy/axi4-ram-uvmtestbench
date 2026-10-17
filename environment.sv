class environment extends uvm_env;
	`uvm_component_utils(environment)

	agent agt;
	scoreboard sb;

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agt = agent::type_id::create("agt",this);
		sb = scoreboard::type_id::create("sb",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		agt.drvr.out_ap.connect(sb.drv_imp);
		agt.rcvr.out_ap.connect(sb.rcv_imp);
	endfunction
endclass
