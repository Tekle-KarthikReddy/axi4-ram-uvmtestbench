# AXI4 RAM - UVM Testbench

AXI4 RAM (single outstanding write/read, 4-bit address, 32-bit data) verified with a UVM 1.2 class-based testbench.

## Layout

- `rtl/` - `ram_design.sv` (memory), `ram_axi_design.sv` (AXI wrapper)
- `tb/` - interface, sequence item, sequence, sequencer, driver, receiver (monitor), agent, scoreboard (with address coverage), environment, test, package, top
- `eda_playground/` - `design.sv` and `testbench.sv` (plus the included `.sv` files): the same code arranged so it pastes straight into EDA Playground

## Run on EDA Playground

Link: https://edaplayground.com/x/YLgM

Settings: Testbench + Design = SystemVerilog/Verilog, UVM/OVM = UVM 1.2, simulator = Synopsys VCS / Aldec Riviera-PRO / Questa (any one that supports UVM), top module = `test_top` (starts `run_test("test")`).

## Results

<img width="1656" height="845" alt="image" src="https://github.com/user-attachments/assets/0edf5471-5754-4f6e-aa78-97b6af24136e" />
<img width="1807" height="843" alt="image" src="https://github.com/user-attachments/assets/0e3acabf-54d5-4fc4-acfc-c1c3ca45c650" />
