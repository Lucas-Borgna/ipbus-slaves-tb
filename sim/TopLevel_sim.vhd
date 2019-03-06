-------------------------------------------------------------------------------
--Project Information
-------------------------------------------------------------------------------
-- Project:    IPbus simulation
-- Deisgner:   Ioannis Xiotidis
-- Supervisor: Alessandro Cerri
-- Institute:  University of Sussex
-- File:       Simulation file for Vivado Sim
-- Date:
-- Comments: 
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ipbus.all;

entity TopLevel_sim is
end TopLevel_sim;

architecture testbed of TopLevel_sim is

  constant IPB_CLK_PERIOD: time := 31.25 ns;
  
  signal ipb_clk: std_logic;
  signal ipb_in: ipb_wbus;
  signal ipb_out: ipb_rbus;
  signal ipb_rst: std_logic;
  
begin

  ipb_clk_proc: process
  begin
    ipb_clk <= '1';
    wait for IPB_CLK_PERIOD / 2;
    ipb_clk <= '0';
    wait for IPB_CLK_PERIOD / 2;
  end process ipb_clk_proc;
  
  dut: entity work.TopLevel
    generic map(
      data_ram_addr_width => 2,
      ipbus_ram_addr_width => 1
      )
    port map(
      ipb_clk => ipb_clk,
      ipb_rst => ipb_rst,
      ipb_in => ipb_in,
      ipb_out => ipb_out
      );
  
  simulation: process
  begin

    ipb_rst <= '1';
    wait for 200 ns;
    ipb_rst <= '0';
    wait for 200 ns;
    ipb_in.ipb_strobe <= '1';
    ipb_in.ipb_write <= '1';
    ipb_in.ipb_addr <= x"00000000"; --Write the address from the decoder
    ipb_in.ipb_wdata <= x"00000000";
    wait for 2*IPB_CLK_PERIOD;
    ipb_in.ipb_strobe <= '0';
    wait for 2*IPB_CLK_PERIOD;
    for I in 0 to 2**2-1 loop
      ipb_in.ipb_strobe <= '1';
      ipb_in.ipb_addr <= x"00000003"; --Same
      ipb_in.ipb_wdata <= x"deadbeef";
      wait for 2*IPB_CLK_PERIOD;
      ipb_in.ipb_strobe <= '0';
      wait for 2*IPB_CLK_PERIOD;
    end loop;
    wait for 2*IPB_CLK_PERIOD;
    ipb_in.ipb_strobe <= '1';
    ipb_in.ipb_addr <= x"00000000"; --Same
    ipb_in.ipb_wdata <= x"00000004";
    wait for 2*IPB_CLK_PERIOD;
    ipb_in.ipb_strobe <= '0';
    wait for 2*IPB_CLK_PERIOD;
    ipb_in.ipb_strobe <= '1';
    ipb_in.ipb_wdata <= x"00000000";
    wait for 2*IPB_CLK_PERIOD;
    ipb_in.ipb_strobe <= '0';
    wait for 2*IPB_CLK_PERIOD;
    ipb_in.ipb_strobe <= '1';
    ipb_in.ipb_wdata <= x"00000004";
    wait for 2*IPB_CLK_PERIOD;
    ipb_in.ipb_strobe <= '0';
    wait;    
    
  end process;
    
end testbed;
