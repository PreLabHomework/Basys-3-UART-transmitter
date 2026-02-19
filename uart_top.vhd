library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_top is
    Port (
        clk : in  STD_LOGIC;
        rst : in  STD_LOGIC;
        tx  : out STD_LOGIC
    );
end uart_top;

architecture Behavioral of uart_top is

    constant CLK_FREQ  : integer := 100_000_000;
    constant BAUD_RATE : integer := 9600;
    constant BAUD_TICKS : integer := CLK_FREQ / BAUD_RATE;

    type rom_type is array (0 to 3) of std_logic_vector(7 downto 0);
    constant message : rom_type := (
        x"30",
        x"31",
        x"32",
        x"33"
    );

    type state_type is (IDLE, LOAD, SHIFT);
    signal state : state_type := IDLE;

    signal rom_addr  : unsigned(1 downto 0) := (others => '0');
    signal shift_reg : std_logic_vector(9 downto 0) := (others => '1');
    signal bit_count : integer range 0 to 9 := 0;

    signal baud_counter : integer range 0 to (BAUD_TICKS/2 - 1) := 0;
    signal baud_clk     : std_logic := '0';
    signal baud_clk_d   : std_logic := '0';
    signal baud_rise    : std_logic := '0';

begin

    process(clk, rst)
    begin
        if rst = '1' then
            baud_counter <= 0;
            baud_clk     <= '0';
            baud_clk_d   <= '0';
            baud_rise    <= '0';
        elsif rising_edge(clk) then

            if baud_counter = (BAUD_TICKS/2 - 1) then
                baud_counter <= 0;
                baud_clk <= not baud_clk;
            else
                baud_counter <= baud_counter + 1;
            end if;

            baud_clk_d <= baud_clk;
            if (baud_clk_d = '0') and (baud_clk = '1') then
                baud_rise <= '1';
            else
                baud_rise <= '0';
            end if;

        end if;
    end process;

    process(clk, rst)
    begin
        if rst = '1' then
            state     <= IDLE;
            rom_addr  <= (others => '0');
            shift_reg <= (others => '1');
            bit_count <= 0;
            tx        <= '1';
        elsif rising_edge(clk) then

            case state is

                when IDLE =>
                    tx <= '1';
                    if baud_rise = '1' then
                        state <= LOAD;
                    end if;

                when LOAD =>
                    shift_reg(0) <= '0';
                    shift_reg(1) <= message(to_integer(rom_addr))(0);
                    shift_reg(2) <= message(to_integer(rom_addr))(1);
                    shift_reg(3) <= message(to_integer(rom_addr))(2);
                    shift_reg(4) <= message(to_integer(rom_addr))(3);
                    shift_reg(5) <= message(to_integer(rom_addr))(4);
                    shift_reg(6) <= message(to_integer(rom_addr))(5);
                    shift_reg(7) <= message(to_integer(rom_addr))(6);
                    shift_reg(8) <= message(to_integer(rom_addr))(7);
                    shift_reg(9) <= '1';

                    bit_count <= 0;
                    state <= SHIFT;

                when SHIFT =>
                    if baud_rise = '1' then
                        tx <= shift_reg(0);
                        shift_reg <= shift_reg(9 downto 1) & '1';

                        if bit_count = 9 then
                            if rom_addr = 3 then
                                rom_addr <= (others => '0');
                            else
                                rom_addr <= rom_addr + 1;
                            end if;
                            state <= IDLE;
                        else
                            bit_count <= bit_count + 1;
                        end if;
                    end if;

            end case;

        end if;
    end process;

end Behavioral;
