class test extends uvm_test;
	`uvm_component_utils(test)

	environment env;
	virtual infc.tb rtr_io;

	function new(string name = "test", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = environment::type_id::create("env",this);
		if(!uvm_config_db#(virtual infc.tb)::get(this,"","vif",rtr_io))
			`uvm_fatal("TEST","virtual interface 'vif' not set")
	endfunction

	task run_phase(uvm_phase phase);
		my_sequence seq;

		phase.raise_objection(this);

		seq= my_sequence::type_id::create("seq");
		if(!seq.randomize()) begin
			$display("environment randomize failed");
			seq.num_trans = 100;
		end
		run_for_n_times= seq.num_trans;
		$display("running %0d times", run_for_n_times);

		fork
		begin
			fork
				seq.start(env.agt.sqr);
				wait(env.sb.pkts_checked >= run_for_n_times);
			join
		end
		begin
			repeat (run_for_n_times * 80 + 5000) @(rtr_io.cb);
			$display("%0t timeout waiting for scoreboard DONE",$time);
		end
		join_any
		disable fork;

		repeat(20) @(rtr_io.cb);
		phase.drop_objection(this);
	endtask
endclass
