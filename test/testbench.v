`timescale 1ns/10ps

`define CYCLE 30.0      // Cycle time
`define MAX 100000    // Max cycle number

`define prog_path0 "../test/prog00/main.hex"
`define gold_path0 "../test/prog00/golden.hex"

`define prog_path1 "../test/prog01/main.hex"
`define gold_path1 "../test/prog01/golden.hex"

`define prog_path2 "../test/prog02/main.hex"
`define gold_path2 "../test/prog02/golden.hex"

`define prog_path3 "../test/prog03/main.hex"
`define gold_path3 "../test/prog03/golden.hex"

`define prog_path4 "../test/prog04/main.hex"
`define gold_path4 "../test/prog04/golden.hex"

`define mem_word(addr) \
  {dm.mem[addr+3], \
  dm.mem[addr+2], \
  dm.mem[addr+1], \
  dm.mem[addr]}

`define ANSWER_START 'h9000

`ifdef SYN
	`include "Top_syn.v"
	`include "TSMC180/tsmc18.v"
`else
`include "Top.v"
`endif
`include "SRAM.v"




module top_tb();

  reg clk;
  reg rst;

  reg [31:0] GOLDEN [0:100];
  integer gf;               // pointer of golden file
  integer num;              // total golden data
  integer err;              // total number of errors compared to golden data

  integer i, handler, pointer;
  //string prog, prog_path, gold_path;


  wire [3:0]im_w_en,dm_w_en;
  wire [31:0] F_pc;
  wire [31:0] F_inst,M_alu_out,M_rs2_data,M_ld_data;

  SRAM im(
     .clk(clk),
     .w_en(im_w_en),
     .address(F_pc[15:0]),
     .write_data(32'b0),
     .read_data(F_inst)
  );
  SRAM dm(
     .clk(clk),
     .w_en(dm_w_en),
     .address(M_alu_out[15:0]),
     .write_data(M_rs2_data),
     .read_data(M_ld_data)
  );

  Top top (
    .clk(clk),
    .rst(rst),
    .im_w_en(im_w_en),
    .dm_w_en(dm_w_en),
    .F_pc(F_pc),
    .F_inst(F_inst),
    .M_alu_out(M_alu_out),
    .M_rs2_data(M_rs2_data),
    .M_ld_data(M_ld_data)
  );

  always #(`CYCLE/2) clk = ~clk;

  initial begin
    //Initial
    clk = 0; rst = 1;
   
    // Begin Running !
    #(`CYCLE) rst = 0;

    $readmemh(`prog_path0, im.mem);
    $readmemh(`prog_path0, dm.mem);

    // Load Golden Data
    gf = $fopen(`gold_path0, "r");
    num = 0;
    while (!$feof(gf)) begin
      i=$fscanf(gf, "%h\n", GOLDEN[num]);
      num = num+1;
    end
    $fclose(gf);

    // Initialize part of the memory (needed by the test program)
    `mem_word('h9078) = 32'd0;
    `mem_word('h907c) = 32'd0;
    `mem_word('h9080) = 32'd0;
    `mem_word('h9084) = 32'd0;

    // Wait until end of execution
    wait(dm.mem[16'hfffc] == 8'hff);
     $display("----------Test zero----------");
    $display("\nDone\n");

    // Compare result with Golden Data
    err = 0;
    for (i = 0; i < num; i=i+1)
    begin
      if (`mem_word(`ANSWER_START + i*4) !== GOLDEN[i])
      begin
        $display("DM['h%4h] = %h, expect = %h", `ANSWER_START + i*4, `mem_word(`ANSWER_START + i*4), GOLDEN[i]);
        err = err + 1;
      end
      else
      begin
        $display("DM['h%4h] = %h, pass", `ANSWER_START + i*4, `mem_word(`ANSWER_START + i*4));
      end
    end
	
    // Print result
        result(err, num);

    #(`CYCLE*10)
    dm.mem[16'hfffc] = 0;	
    //Initial
    rst = 1;
    
    // Begin Running !
    #(`CYCLE) rst = 0;

    $readmemh(`prog_path1, im.mem);
    $readmemh(`prog_path1, dm.mem);

    // Load Golden Data
    gf = $fopen(`gold_path1, "r");
    num = 0;
    while (!$feof(gf)) begin
      i=$fscanf(gf, "%h\n", GOLDEN[num]);
      num = num+1;
    end
    $fclose(gf);

    // Initialize part of the memory (needed by the test program)
    `mem_word('h9078) = 32'd0;
    `mem_word('h907c) = 32'd0;
    `mem_word('h9080) = 32'd0;
    `mem_word('h9084) = 32'd0;

    // Wait until end of execution
    wait(dm.mem[16'hfffc] == 8'hff);
    $display("----------Test one----------");
    $display("\nDone\n");

    // Compare result with Golden Data
    err = 0;
    for (i = 0; i < num; i=i+1)
    begin
      if (`mem_word(`ANSWER_START + i*4) !== GOLDEN[i])
      begin
        $display("DM['h%4h] = %h, expect = %h", `ANSWER_START + i*4, `mem_word(`ANSWER_START + i*4), GOLDEN[i]);
        err = err + 1;
      end
      else
      begin
        $display("DM['h%4h] = %h, pass", `ANSWER_START + i*4, `mem_word(`ANSWER_START + i*4));
      end
    end
	
    // Print result
        result(err, num);

    #(`CYCLE*10)
    dm.mem[16'hfffc] = 0;	
    //Initial
    rst = 1;
    	
    // Begin Running !
    #(`CYCLE) rst = 0;

    $readmemh(`prog_path2, im.mem);
    $readmemh(`prog_path2, dm.mem);

    // Load Golden Data
    gf = $fopen(`gold_path2, "r");
    num = 0;
    while (!$feof(gf)) begin
      i=$fscanf(gf, "%h\n", GOLDEN[num]);
      num = num+1;
    end
    $fclose(gf);

    // Initialize part of the memory (needed by the test program)
    `mem_word('h9078) = 32'd0;
    `mem_word('h907c) = 32'd0;
    `mem_word('h9080) = 32'd0;
    `mem_word('h9084) = 32'd0;

    // Wait until end of execution
    wait(dm.mem[16'hfffc] == 8'hff);
    $display("----------Test two----------");
    $display("\nDone\n");

    // Compare result with Golden Data
    err = 0;
    for (i = 0; i < num; i=i+1)
    begin
      if (`mem_word(`ANSWER_START + i*4) !== GOLDEN[i])
      begin
        $display("DM['h%4h] = %h, expect = %h", `ANSWER_START + i*4, `mem_word(`ANSWER_START + i*4), GOLDEN[i]);
        err = err + 1;
      end
      else
      begin
        $display("DM['h%4h] = %h, pass", `ANSWER_START + i*4, `mem_word(`ANSWER_START + i*4));
      end
    end
	
    // Print result
        result(err, num);

    /*#(`CYCLE*10)
    dm.mem[16'hfffc] = 0;	
    //Initial
    rst = 1;
    
    // Begin Running !
    #(`CYCLE) rst = 0;

    $readmemh(`prog_path3, im.mem);
    $readmemh(`prog_path3, dm.mem);

    // Load Golden Data
    gf = $fopen(`gold_path3, "r");
    num = 0;
    while (!$feof(gf)) begin
      i=$fscanf(gf, "%h\n", GOLDEN[num]);
      num = num+1;
    end
    $fclose(gf);

    // Initialize part of the memory (needed by the test program)
    `mem_word('h9078) = 32'd0;
    `mem_word('h907c) = 32'd0;
    `mem_word('h9080) = 32'd0;
    `mem_word('h9084) = 32'd0;

    // Wait until end of execution
    wait(dm.mem[16'hfffc] == 8'hff);
    $display("----------Test three----------");
    $display("\nDone\n");

    // Compare result with Golden Data
    err = 0;
    for (i = 0; i < num; i=i+1)
    begin
      if (`mem_word(`ANSWER_START + i*4) !== GOLDEN[i])
      begin
        $display("DM['h%4h] = %h, expect = %h", `ANSWER_START + i*4, `mem_word(`ANSWER_START + i*4), GOLDEN[i]);
        err = err + 1;
      end
      else
      begin
        $display("DM['h%4h] = %h, pass", `ANSWER_START + i*4, `mem_word(`ANSWER_START + i*4));
      end
    end
	
    // Print result
        result(err, num);

    #(`CYCLE*10)
    dm.mem[16'hfffc] = 0;	
    //Initial
    rst = 1;*/
   
    // Begin Running !
    #(`CYCLE) rst = 0;

    $readmemh(`prog_path4, im.mem);
    $readmemh(`prog_path4, dm.mem);

    // Load Golden Data
    gf = $fopen(`gold_path4, "r");
    num = 0;
    while (!$feof(gf)) begin
      i=$fscanf(gf, "%h\n", GOLDEN[num]);
      num = num+1;
    end
    $fclose(gf);

    // Initialize part of the memory (needed by the test program)
    `mem_word('h9078) = 32'd0;
    `mem_word('h907c) = 32'd0;
    `mem_word('h9080) = 32'd0;
    `mem_word('h9084) = 32'd0;

    // Wait until end of execution
    wait(dm.mem[16'hfffc] == 8'hff);
    $display("----------Test four----------");
    $display("\nDone\n");

    // Compare result with Golden Data
    err = 0;
    for (i = 0; i < num; i=i+1)
    begin
      if (`mem_word(`ANSWER_START + i*4) !== GOLDEN[i])
      begin
        $display("DM['h%4h] = %h, expect = %h", `ANSWER_START + i*4, `mem_word(`ANSWER_START + i*4), GOLDEN[i]);
        err = err + 1;
      end
      else
      begin
        $display("DM['h%4h] = %h, pass", `ANSWER_START + i*4, `mem_word(`ANSWER_START + i*4));
      end
    end
	
    // Print result
        result(err, num);
	
    $finish;	
  end



  task result;
    input integer err;
    input integer num;
    begin
      if (err === 0)
      begin
        $display("    ****************************  ");
        $display("    **                        **  ");
        $display("    **  Waku Waku !!          **⠆ ");
        $display("    **                        **  ");
        $display("    **  Simulation PASS !!    **  ");
        $display("    **                        **  ");
        $display("    ****************************  ");
        $display("                                  ");
      end
      else
      begin
        $display("                                     ");
        $display("    ****************************     ");
        $display("    **                        **     ");
        $display("    **  OOPS !!               **     ");
        $display("    **                        **     ");
        $display("    **  Simulation Failed !!  **     ");
        $display("    **                        **    ⠀");
        $display("    ****************************     ");
        $display("                                     ");
        $display("         Totally has %d errors"                     , err);
        $display("\n");
      end
      //for(pointer=36864;pointer<36864+100;pointer=pointer+1)begin
	//   $display("mem[%h]=%h\n",pointer,dm.mem[pointer]);
      //end
    end
  endtask
`ifdef SYN
	initial $sdf_annotate("Top_syn.sdf",top);
`endif
	
  initial begin
   
      $dumpfile("top.fsdb");
      $dumpvars();
    
  end

 initial begin
    #(`CYCLE*`MAX)
    $display("dm.mem[16'hfffc] == %h",dm.mem[16'hfffc]);
    $finish;
  end

endmodule
