`uvm_analysis_imp_decl(_drv)
`uvm_analysis_imp_decl(_rcv)

class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	uvm_analysis_imp_drv#(seq_item,scoreboard) drv_imp;
	uvm_analysis_imp_rcv#(seq_item, scoreboard) rcv_imp;
	event DONE;
	seq_item refpkt[$];
	seq_item trans1;
	logic [3:0] addr;
	int pkts_checked = 0;
	int pass_count = 0;
	int fail_count = 0;
	real coverage_result;

	covergroup cg;
		coverpoint addr;
	endgroup

	extern function new(string name, uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void write_drv(seq_item pkt);
	extern virtual function void write_rcv(seq_item pkt);
	extern virtual function void check_packet();
	extern virtual function void report_phase(uvm_phase phase);
endclass

function scoreboard::new(string name, uvm_component parent);
	super.new(name,parent);
	cg = new();
endfunction
function void scoreboard::build_phase(uvm_phase phase);
	super.build_phase(phase);
	drv_imp = new("drv_imp",this);
	rcv_imp = new("rcv_imp",this);
endfunction

function void scoreboard::write_drv(seq_item pkt);
	refpkt.push_back(pkt);
endfunction

function void scoreboard::write_rcv(seq_item pkt);
	this.trans1 = pkt;
	check_packet();
endfunction

function void scoreboard::check_packet();
	string message ="";
	int idx=-1;
	foreach(refpkt[i]) begin
		if(refpkt[i].addr==trans1.addr) begin
			idx=i;
			break;
		end
	end
	if(idx==-1) begin
		message = " no matching reference packet";
		`uvm_error("SB",$sformatf("%s for addr=%0h",message,trans1.addr));
		fail_count++;
	end
	else begin
		if(!refpkt[idx].compare_data(trans1,message)) begin
			`uvm_error("SB",$sformatf(" error comparing: %s",message));
			fail_count++;
		end
		else
			pass_count++;
		this.addr=refpkt[idx].addr;
		cg.sample();
		refpkt.delete(idx);
	end

	pkts_checked++;
	coverage_result=cg.get_coverage();
	`uvm_info("SB",$sformatf(" packets %0d  addr=%0h %s coverage=%3.2f",pkts_checked,trans1.addr,message,coverage_result),UVM_LOW);
	if(pkts_checked>=run_for_n_times)
		->DONE;
endfunction

function void scoreboard::report_phase(uvm_phase phase);
	super.report_phase(phase);
	`uvm_info("SB",$sformatf("test completed: PASS=%0d FAIL=%0d", pass_count, fail_count),UVM_LOW);
	if(fail_count ==0 && pass_count>0)
		`uvm_info("SB","*** TEST PASSED ***",UVM_LOW)
	else
		`uvm_error("SB", "TEST FAILED");
endfunction
