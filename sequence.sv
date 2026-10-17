class my_sequence extends uvm_sequence#(seq_item);
	`uvm_object_utils(my_sequence)

	rand int unsigned num_trans;
	constraint c_num{ num_trans inside {[100:200]};}

	function new(string name ="my_sequence");
		super.new(name);
	endfunction

	task body();
		repeat(num_trans) begin
			req = seq_item::type_id::create("req");
			start_item(req);
			if(!req.randomize()) begin
				`uvm_error("body","Randomization failes")
			end
			finish_item(req);
		end
	endtask
endclass
