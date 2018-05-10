CON
{{
        74HC595 Regular Driver v1.0 April 2009
        Basic control on all outputs of up to 100 74HC595's in series    
        
        Copyright Dennis Ferron 2009
        Contact:  dennis.ferron@gmail.com
        See end of file for terms of use

Summary:
        Set outputs for up to 100 74HC595's connected in series.
        The intended use is to allow 3 Propeller pins to control many
        LED's or other outputs.

        This object was commissioned by Thomas Steiner (thanks Thomas!)
        in order to control LED's on a control board using 12 74HC595's.

Change Log:

        v1.0    Released 4/20/2009
                - Adapted from the multiPWM driver.        

Operation:
        In addition to the 3 pins, you must also pass to the start routine
        the number of 74HC595 chips that you have connected in series.        
        (If you specify a number less than you have, the output bits will not
        reach the correct chip.  If you specify a number greater than you really have,
        the only ill effect would be that the driver takes a little longer to
        shift out all the extra bits, but everything would still operate correctly.)   

        The assembly cog loops, waiting for a command.  When a command is received,
        the action specified by the command is performed, and then the
        total output states are shifted out, MSB-first.

        (Unlike the Simple_74HC595 driver, this driver uses command
        codes to set channel states, and waits for the command to be processed,
        so that you know that the state has been properly updated when the
        functions return.)

        Output states can be set one line at a time, or eight at a time
        using the 'Out' subroutine.  Unlike the other drivers in this
        collection, the Out routine in this object does not use 32-bit
        values; instead it uses an 8-bit value and requires an extra
        parameter to specify which 74HC595 chip the value should end up in.
        This is done to support more than four 74HC595's (we would be limited
        to just four bytes if we used a 32 bit value by itself as the others do.)
        Similarly, the 'What' subroutine in this object deals with 8 bits,
        instead of 32 bits, but includes a parameter allowing you to specify which chip.

        The values for "which chip" in all subroutines which take such
        a parameter start with 0 representing the 74HC595 closest
        to the Propeller, 1 representing the next, and so on.
        Remember that the shifting is done MSB first as well.
        This relationship of bit order to byte order is shown in the
        diagram below for a four-chip implementation.  If you have more
        than four chips, imagine them as being tacked onto the left side
        of the chart.  "Byte 0" means also "chip 0" which means "first chip". 

        ┌───────────────┬───────────────┬───────────────┬───────────────┐
        │    Byte 3     │    Byte 2     │    Byte 1     │    Byte 0     │   
        ├─┬─┬─┬─┬─┬─┬─┬─┼─┬─┬─┬─┬─┬─┬─┬─┼─┬─┬─┬─┬─┬─┬─┬─┼─┬─┬─┬─┬─┬─┬─┬─┤
        │7│6│5│4│3│2│1│0│7│6│5│4│3│2│1│0│7│6│5│4│3│2│1│0│7│6│5│4│3│2│1│0│   
        ├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤
        │H│G│F│E│D│C│B│A│H│G│F│E│D│C│B│A│H│G│F│E│D│C│B│A│H│G│F│E│D│C│B│A│   
        └─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘
        
        The High, Low, and SetBit routines all work in this object the same
        as they do in the other objects, but they can work on channel
        numbers 32 and above if you have that many chips.  These three
        routines don't require you to specify which 74HC595 because they
        treat all the shift registers as part of one long sequence, with
        0 being the "QA" output of the shift register nearest the Propeller,
        7 being the "QH" output of that same shift register, then 8 being the
        "QA" output of the second shift register in the chain, and so on.

        For example, "High(17)" will set the QB output of the 3rd shift
        register in the chain.  You can also use math:  "Low(11*8 + 2)"
        would clear the QC output of the 12th 74HC595 in a chain.

Wiring:
        Different vendors name the pins of the '595 differently, making things very
        confusing.  Motorola's names are the most descriptive; the rest
        are ridiculous gobbledygook.  Here's a table of equivalent pin names:

                  Pins
        Vendor    14    13   12     11     10     9

        Phillips  Ds    /OE  STcp   SHcp   /MR    Q7'

        ST        SI    /G   RCK    SCK    /SCLR  QH'
        
        Motorola  A     Out. Latch  Shift  RESET  SQH
                        En.  Clock  Clock
        
        Propeller Data       Latch  Shift
        Pin name  Pin        Pin    Pin

        I've used Motorola's pin names in the following diagram:
                
                      ┌──────┐
                  QB  ┫1•  16┣  Vcc                 
                  QC  ┫2   15┣  QA                                
                  QD  ┫3   14┣─────────────────────────────── ← A (Data in from Propeller)              
                  QE  ┫4   13┣─────────────────────• Output Enable (Ground each one)            
                  QF  ┫5   12┣───────────────┐     ← Latch Clock         
                  QG  ┫6   11┣─────────────┐ │     ← Shift Clock 
                  QH  ┫7   10┣──────────────────┐  ← RESET 
                 gnd  ┫7    9┣───────┐ QH' │ │  │
                      └──────┘       │     │ │  │    Notes:
                                     │     │ │  │    • Propeller feeds data into "A" input of first stage.
                      ┌──────┐       │     │ │  │    • QH' from first stage feeds into A of next stage
                  QB  ┫1•  16┣  Vcc  │     │ │  │    • Tie all RESET, Latch Clock and Shift Clock pins together    
                  QC  ┫2   15┣  QA   │     │ │  │    • QA - QH are data outputs: Vcc = 1, gnd = 0                  
                  QD  ┫3   14┣───────┘ A   │ │  │             
                  QE  ┫4   13┣─────────────│─│──│───•  Output Enable (Ground each output enable)               
                  QF  ┫5   12┣─────────────│─┻──│───•  Latch Clock (to LatchPin from Propeller)                 
                  QG  ┫6   11┣─────────────┻────│───•  Shift Clock (to ClockPin from Propeller)
                  QH  ┫7   10┣──────────────────┻───•  RESET (to Vcc or to Propeller's Reset pin)
                 gnd  ┫7    9┣───────┐ Qh'
                      └──────┘       │
                                    to next 74HC595 Data in (pin 14)
                                     or leave disconnected if last one

        Note 1: This object doesn't use the output enables, so I have you ground them to leave
                them always on.  If you need output enable control, tie all the output enables
                together and then set the output enable in your own code as you need it.
                
        Note 2: When you program the Propeller, whatever outputs were 1 at the time the Propeller
                halted to accept its new program, will remain on for the duration of the download
                of the new program.  This can have bad consequences on a robot if, for instance,
                that 1 that was set is controlling a motor, and the motor continues to run.
                I haven't tried it, but it should be possible to connect the reset lines from
                all the 74HC595's to the reset line of the Propeller, so that when the Propeller
                programming tool (i.e. Prop Plug) resets the Propeller, it will also clear
                the shift registers and set their outputs to 0.

}}

CON

  ' This enumeration is used to send commands to the assembly cog.
  #1, _init, _getval, _sethigh, _setlow, _setall, _setchips



VAR

  ' This block of variables is used to pass pin information to initialize
  ' the asm routine.  After initialization, Command continues to
  ' function as the place to write a value to be picked up by the
  ' asm routine, which monitors Command continuously.
  long Command
  long Arg1
  long Arg2
  long Arg3

VAR
  ' Stores the value of the cog the driver is running in.
  long Cog
  
PUB Start(clock_pin, latch_pin, data_pin, number_of_chips)
{{ Launches the shift-out asm routine. }}

  Stop

  Arg1 := clock_pin
  Arg2 := latch_pin
  Arg3 := data_pin
  Command := _init
  Cog := cognew(@init_asm, @Command) + 1

  repeat while Command

  SetNumChips(number_of_chips)
  
  return (Cog > 0)

PUB Stop
{{ Stops the shift-out asm routine. }}

  if Cog
    CogStop(Cog-1)
    Cog := 0
    
PUB SetNumChips(number_of_chips)

  Arg1 := number_of_chips
  Command := _setchips
  repeat while Command

PUB What(which_chip)
{{ Returns what the driver last output to the shift registers (8 bits at a time).
    which_chip is which 8-bit 74HC595 chip to get the value from.
}}

  Arg1 := which_chip
  Command := _getval
  repeat while Command
  return Arg2

PUB Out(value, which_chip)
{{ Sets all outputs of a chip at once (8 bits at time).
    value is a byte value to output to a shift register.
    which_chip is which 74HC595 chip to output to.
}}
  
  Arg1 := which_chip
  Arg2 := value
  Command := _setall
  repeat while Command

PUB High(channel)
{{  Sets specified channel always high.
      channel is a number from 0 to 8*num_chips
}}

  Arg1 := channel
  Command := _sethigh

  repeat while Command

PUB Low(channel)
{{  Sets specified channel always low.
      channel is a number from 0 to 8*num_chips
}}

  Arg1 := channel
  Command := _setlow

  repeat while Command

PUB SetBit(channel, state)
{{  Sets specified channel to specified state.
      channel is a number from 0 to 8*num_chips
}}

  if state
    High(channel)
  else
    Low(channel)

DAT  {{  Assembly language 74HC595_Regular driver.  Runs continously.  }}

              org       0

DAT init_asm
              ' Get pin assignments and use to create
              ' masks for setting those pins.
              call      #read_args
              
              mov       srclk, #1               ' Prepare srclk mask
              shl       srclk, arg1_            ' Move srclk mask into position

              mov       srlatch, #1             ' Prepare srlatch mask
              shl       srlatch, arg2_          ' Move srlatch bit into position 

              mov       srdata, #1              ' Prepare srdata mask
              shl       srdata, arg3_           ' Move srdata bit into position

              ' Set the direction bits for the pins.
              or        dira, srclk
              or        dira, srlatch
              or        dira, srdata

              ' Clear command code to let start routine know we've got our pins.
              mov       cmd, #0
              wrlong    cmd, par

:do_loop
              call      #do_cmd                 ' Execute a command if one is present.
              call      #shift_all
              jmp       #:do_loop               ' Do it all over again. 

              ' Never returns.

DAT read_args

              mov       arg1_, par
              add       arg1_, #(1*4)
              rdlong    arg1_, arg1_

              mov       arg2_, par
              add       arg2_, #(2*4)
              rdlong    arg2_, arg2_

              mov       arg3_, par
              add       arg3_, #(3*4)
              rdlong    arg3_, arg3_

read_args_ret ret

DAT shift_all

              ' Set Z flag so we can use muxz/muxnz to flip output bits.
              mov       t1, #0  wz

              ' Count from numchips down to zero.
              mov       count2, numchips_
:shift_byte
              mov       arg1_, count2
              sub       arg1_, #1              
              call      #load_states
              muxnz     outa, srlatch           ' Latch starts low
              call      #shift_bits
              muxz      outa, srlatch           ' Latch the data output
              djnz      count2, #:shift_byte

shift_all_ret ret

DAT shift_bits

              mov       count, #8               ' Shift 8 bits (one chip)
:shift_bit

              shl       shiftout, #1            ' Move next bit up out of shiftout 
              and       shiftout, #$100 wc,nr   ' Read MSB; store it in carry flag

              muxnz     outa, srclk             ' Make clock low
              muxc      outa, srdata            ' Output the consumed bit to the shift register
              nop                               ' Let data line settle (this nop is optional)
              muxz      outa, srclk             ' Clock high to latch bit of data
              djnz      count, #:shift_bit      ' Do next bit

shift_bits_ret ret

DAT do_cmd
              rdlong    cmd, par wz             ' Get command code if present
        if_z  jmp       #do_cmd                 ' No command code, loop until we get one

              call      #read_args              ' Got command code; now get the args.
        
              cmp       cmd, #_getval wz
        if_e  call      #report_val

              cmp       cmd, #_sethigh wz
        if_e  call      #set_high

              cmp       cmd, #_setlow wz
        if_e  call      #set_low

              cmp       cmd, #_setall wz
        if_e  call      #set_all

              cmp       cmd, #_setchips wz
        if_e  mov       numchips_, arg1_

              ' Clear command code
              mov       cmd, #0
              wrlong    cmd, par 

do_cmd_ret    ret

DAT set_high

              mov       t1, arg1_               ' t1 will hold which bit we get from byte
              and       t1, #7                  ' Limit which bit to 0 to 7
              shr       arg1_, #3               ' Divide by 8 to get which chip
              call      #load_states            ' Load states for this chip
              mov       bit, #1 wz              ' Create bit mask and clear zero flag
              shl       bit, t1                 ' Move bit mask into position
              muxnz     shiftout, bit           ' Set bit in out_states
              call      #store_states           ' Store the new states
              
set_high_ret  ret

DAT set_low

              mov       t1, arg1_               ' t1 will hold which bit we get from byte
              and       t1, #7                  ' Limit which bit to 0 to 7
              shr       arg1_, #3               ' Divide by 8 to get which chip
              call      #load_states            ' Load states for this chip
              mov       bit, #1 wz              ' Create bit mask and clear zero flag
              shl       bit, t1                 ' Move bit mask into position
              muxz      shiftout, bit           ' Clear bit in out_states
              call      #store_states           ' Store the new states
              
set_low_ret   ret

DAT set_all
              mov       shiftout, arg2_       ' Set all outputs of one chip
              call      #store_states

set_all_ret   ret


DAT report_val

              call      #load_states
              mov       t1, par
              add       t1, #(2*4)
              wrlong    shiftout, t1

report_val_ret ret

DAT store_states
              
              ' Store the new output state
              mov       t3, #out_states
              add       t3, arg1_
              movd      :d_store, t3
              nop
:d_store      mov       0, shiftout

store_states_ret ret

DAT load_states

              ' Read the output states from the table. 
              mov       t3, #out_states
              add       t3, arg1_
              movs      :s_read, t3
              nop
:s_read       mov       shiftout, 0

load_states_ret ret

DAT ' Asm Variables

' How many chips to shift out to
numchips_     long      1

' Output states table
out_states    res       100

' Command and argument values
cmd     res   1
arg1_   res   1
arg2_   res   1
arg3_   res   1

' Input parameters
srclk   res   1
srlatch res   1
srdata  res   1

shiftout res  1

' Scratch registers.
bit     res   1
t1      res   1        
t2      res   1
t3      res   1
count   res   1
count2  res   1

DAT ' License

{{

┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                   TERMS OF USE: MIT License                                                  │                                                            
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation    │ 
│files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,    │
│modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software│
│is furnished to do so, subject to the following conditions:                                                                   │
│                                                                                                                              │
│The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.│
│                                                                                                                              │
│THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE          │
│WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR         │
│COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   │
│ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                         │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘

}}