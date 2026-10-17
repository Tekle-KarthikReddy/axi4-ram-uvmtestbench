class seq_item extends uvm_sequence_item;
	rand logic  [3:0] addr;
	rand int w_data;
	int  r_data;

	`uvm_object_utils_begin(seq_item)
	`uvm_field_int(addr,UVM_ALL_ON)
	`uvm_field_int(w_data,UVM_ALL_ON)
	`uvm_field_int(r_data,UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "seq_item");
		super.new(name);
	endfunction

	constraint a{w_data inside{[0:1000]};}

	extern function bit compare_data(seq_item trans1,ref string message);

endclass

function bit seq_item::compare_data(seq_item trans1,ref string message);
	if(w_data != trans1.r_data) begin
		message=$sformatf("r_data mismatch exp =%0d rec=%0d",w_data,trans1.r_data);
		return(0);
	end
	message="successfully compared successfully";
	return(1);
endfunction
