con { timing }

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000                    ' use 5MHz crystal

  CLK_FREQ = (_clkmode >> 6) * _xinfreq   ' system freq as a constant
  MS_001   = CLK_FREQ / 1_000             ' ticks in 1ms
  US_001   = CLK_FREQ / 1_000_000         ' ticks in 1us
     
  Baudrate = 9600
  RXpin  = 31       ' programming / terminal
  TXpin  = 30  
     
                                          ' 
obj
    pst   : "Parallax Serial Terminal"    ' Serial Terminal


var

  long  frameBuff1[4]      ' Buffer pointer for RGB Strip
  long  frameBuff2[4]      ' Buffer for RGB Strip

pub main
  init

  misc
  
pub init

  pst.StartRxTx(RXpin, TXpin, 0, Baudrate)
  pst.Str(String("Serail System Initialized"))
  pst.Chars(pst#NL, 2)
  
pub misc | tLong

  tLong := $12_12_12_12
  frameBuff1[0] := tLong
  
  pst.Str(string("tLong:"))
  pst.Hex(tLong,8)
  pst.Chars(pst#NL, 2)
  
  pst.Str(string("Buff1:"))
  pst.Hex(frameBuff1[0],8)
  pst.Chars(pst#NL, 2)
  