-------------------------------------------------------------------------------
--Project Information
-------------------------------------------------------------------------------
-- Project:    IPbus simulation
-- Deisgner:   Ioannis Xiotidis
-- Supervisor: Alessandro Cerri
-- Institute:  University of Sussex
-- File:       Design Top Level
-- Date:
-- Comments: 
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.VComponents.all;

use work.ipbus.all;
use work.ipbus_decode_ipbus_example.all;

entity TopLevel is
  generic(
    data_ram_addr_width: positive := 2;
    ipbus_ram_addr_width: positive := 1
    );
  port(
    ipb_clk: in std_logic;
    ipb_rst: in std_logic;
    ipb_in: in ipb_wbus;
    ipb_out: out ipb_rbus
    );
end TopLevel;

architecture rtl of TopLevel is

  signal ipbw: ipb_wbus_array(N_SLAVES-1 downto 0);
  signal ipbr: ipb_rbus_array(N_SLAVES-1 downto 0);
  
begin

  fabric: entity work.ipbus_fabric_sel
    generic map(
      NSLV => N_SLAVES,
      SEL_WIDTH => IPBUS_SEL_WIDTH
      )
    port map(
      ipb_in => ipb_in,
      ipb_out => ipb_out,
      sel => ipbus_sel_ipbus_example(ipb_in.ipb_addr),
      ipb_to_slaves => ipbw,
      ipb_from_slaves => ipbr
      );

  slave0: entity work.ipbus_reg_v
    port map(
    clk       => ipb_clk,
    reset     => ipb_rst,
    ipbus_in  => ipbw(N_SLV_REG),
    ipbus_out => ipbr(N_SLV_REG),
    q         => open
    );

  slave4: entity work.ipbus_ram
    generic map(
      ADDR_WIDTH => data_ram_addr_width
      )
    port map(
      clk       => ipb_clk,
      reset     => ipb_rst,
      ipbus_in  => ipbw(N_SLV_RAM),
      ipbus_out => ipbr(N_SLV_RAM)
      );  

end rtl;
