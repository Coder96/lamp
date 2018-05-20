CON
  _clkmode = xtal1 + pll16x             'Standard clock mode * crystal frequency = 80 MHz
  _xinfreq = 5_000_000

  CLK_FREQ = (_clkmode >> 6) * _xinfreq   ' system freq as a constant
  MS_001   = CLK_FREQ / 1_000             ' ticks in 1ms
  US_001   = CLK_FREQ / 1_000_000         ' ticks in 1us
                                          ' 
'------Shift Register Pins------
  Latch_Pin         = 21 '22
  Clock_Pin         = 22 '21
  Data_Pin          = 23 '20
  Chip_Num          = 2

  Baudrate  = 9600
  RXpin     = 24    ' programming / terminal
  TXpin     = 25
  
OBJ

  stepDisp : "74HC595_Regular"
  term     : "jm_fullduplexserial"         ' * serial for terminal
  str      : "jm_strings"                  '   strings support
      
PUB Main | mystep

  term.start(RXpin, TXpin, %0000, Baudrate)
  
  stepDisp.Start(Clock_Pin, Latch_Pin, Data_Pin, Chip_Num)
  waitcnt(clkfreq*2+cnt)
  
 repeat
    myTermStrNL(string("Send 00"))
    stepDisp.Out(sdZero, 0)
    stepDisp.Out(sdZero, 1)
    waitcnt(clkfreq*2+cnt)
    myTermStrNL(string("Send 22"))
    stepDisp.Out(sdTwo, 0)
    stepDisp.Out(sdTwo, 1)
    waitcnt(clkfreq*2+cnt)
    myTermStrNL(string("Send 44"))
    stepDisp.Out(sdFour, 0)
    stepDisp.Out(sdFour, 1)
    waitcnt(clkfreq*2+cnt)
    myTermStrNL(string("Send 66"))
    stepDisp.Out(sdSix, 0)
    stepDisp.Out(sdSix, 1)
    waitcnt(clkfreq*2+cnt)
    myTermStrNL(string("Send 88"))
    stepDisp.Out(sdEight, 0)
    stepDisp.Out(sdEight, 1)
    waitcnt(clkfreq*2+cnt)


  waitcnt(clkfreq*2+cnt)

'  repeat mystep from 0 to 20
'    term.Str(String("Step: "))  
'    term.dec(mystep)
'    term.tx(13)  
'    currentStep(mystep)
'    waitcnt(clkfreq*2+cnt)

con
'Binary strings that are sent to the shift register to make the desired number visible on the 7-segment display
'             01234567
  sdZero   = %11000000            
  sdOne    = %11111001
  sdTwo    = %10100100
  sdThree  = %10110000
  sdFour   = %10011001
  sdFive   = %10010010
  sdSix    = %10000010
  sdSeven  = %11111000
  sdEight  = %10000000
  sdNine   = %10011000
  sdDot    = %01111111
  sdAllOff = %11111111
  sdAllOn  = %00000000
  
pub currentStep(iCurrStep) | myLeng, myStr

'  if iCurrStep < 10
'    str.val2bin(iCurrStep, 1, @myStr)
'  elseif iCurrStep < 100
'    str.val2bin(iCurrStep, 2, @myStr)
'  elseif iCurrStep < 1000
'    str.val2bin(iCurrStep, 3, @myStr)
'  elseif iCurrStep < 10000
'    str.val2bin(iCurrStep, 4, @myStr)

  'bin2dec(myStr, iCurrStep)

  myLeng := strsize(myStr) 
  term.Str(String("Str: "))  
  term.str(myStr)
  term.Str(String("Step: "))  
  term.dec(iCurrStep)
  term.Str(String(" Length: "))  
  term.dec(myLeng)
  term.tx(13)
  
'  stepDisp.Out(%00000000, 0)
  
  
  
  
{{  
con
'          01234567
  Zero  = %11000000            'Binary strings that are sent to the shift register to make the desired number visible on the 7-segment display
  One   = %11111001
  Two   = %10100100
  Three = %10110000
  Four  = %10011001
  Five  = %10010010
  Six   = %10000010
  Seven = %11111000
  Eight = %10000000
  Nine  = %10011000
  Dot   = %01111111
'      01234567
  I = %11111001
  L = %11000111
  O = %11000000
  V = %11000001
  E = %10000110
  Y = %10011001
  Oo = %11000000
  U = %11000001
  Blank = %11111111
  hyphen = %10111111

  Time = 1
'  data.Out(%00000000, 0)
'  data.Out(%00000000, 1)
'  waitcnt(clkfreq*4+cnt)
  data.Out(%11111111, 0)
  data.Out(%11111111, 1)

  bNumbersA
  
  repeat
    Message

PUB bNumbersA

  waitcnt(clkfreq*Time+cnt)
  data.Out(data.Blank, 0)
  data.Out(hyphen, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(hyphen, 0)
  data.Out(Blank, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(Blank, 0)
  data.Out(Zero, 1)
  waitcnt(clkfreq*1+cnt)
  data.Out(Zero, 0)
  data.Out(One, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(One, 0)
  data.Out(Two, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(Two, 0)
  data.Out(Three, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(Three, 0)
  data.Out(Four, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(Four, 0)
  data.Out(Five, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(Five, 0)
  data.Out(Six, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(Six, 0)
  data.Out(Seven, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(Seven, 0)
  data.Out(Eight, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(Eight, 0)
  data.Out(Nine, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(Nine, 0)
  data.Out(Dot, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(Dot, 0)
  data.Out(Blank, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(Blank, 0)
  data.Out(hyphen, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(hyphen, 0)
  data.Out(Blank, 1)

PUB Message

  waitcnt(clkfreq*Time+cnt)
  data.Out(Blank, 0)
  data.Out(I, 1)
  waitcnt(clkfreq*1+cnt)
  data.Out(I, 0)
  data.Out(Blank, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(Blank, 0)
  data.Out(L, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(L, 0)
  data.Out(O, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(O, 0)
  data.Out(V, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(V, 0)
  data.Out(E, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(E, 0)
  data.Out(Blank, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(Blank, 0)
  data.Out(Y, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(Y, 0)
  data.Out(Oo, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(Oo, 0)
  data.Out(U, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(U, 0)
  data.Out(Blank, 1)
  waitcnt(clkfreq*Time+cnt)
  data.Out(Blank, 0)
  data.Out(hyphen, 1)



'  waitcnt(clkfreq*4+cnt)
'  data.Out(%01111111, 0)
'  waitcnt(clkfreq*2+cnt)
'  data.Out(%10111111, 0)
'  waitcnt(clkfreq*2+cnt)
'  data.Out(%11011111, 0)
'  waitcnt(clkfreq*2+cnt)
'  data.Out(%11101111, 0)
'  waitcnt(clkfreq*2+cnt)
'  data.Out(%11110111, 0)
'  waitcnt(clkfreq*2+cnt)
'  data.Out(%11111011, 0)
'  waitcnt(clkfreq*2+cnt)
'  data.Out(%11111101, 0)
'  waitcnt(clkfreq*2+cnt)
'  data.Out(%11111110, 0)

PUB wow
    
  waitcnt(clkfreq + cnt)                                  'Waits 1 second before starting test

  Data.Out(%00000000, 0)                                  'Makes sure all segments of the 7-Segment are off
  Data.Out(%00000000, 1)                                  'Makes sure all segments of the 7-Segment are off
  waitcnt(clkfreq*2+cnt)
  Data.Out(%11111111, 0)
  Data.Out(%11111111, 1)
  waitcnt(clkfreq*2+cnt)


  outa[Signal_Bad]~~                                      'Turns on the Red LED
  waitcnt(clkfreq*2+cnt)                                  'Waits 3 seconds
  outa[Signal_Bad]~                                       'Turns off the Red LED
  waitcnt(clkfreq*2+cnt)                                  'Waits 3 seconds

  outa[Signal_Good]~~                                     'Turns on the Green LED
  waitcnt(clkfreq*2+cnt)                                  'Waits 3 seconds
  outa[Signal_Good]~                                      'Turns off the Green LED
  waitcnt(clkfreq*2+cnt)                                  'Waits 3 seconds
      
  Seven_Segment_Test                                      
  
  waitcnt(clkfreq+cnt)

  Data.Out(%00000000, 0)                                  'Turns all segments of the 7-Segment off and ends the test1
  Data.Out(%00000000, 1)

PUB Seven_Segment_Test | value
    
  repeat value from 0 to 10
    waitcnt(clkfreq+cnt)   

    If value == 0
      Data.Out(Zero, 0)
    elseif value == 1
      Data.Out(One, 0)
    elseif value == 2
      Data.out(Two, 0)
    elseif value == 3
      Data.Out(Three, 0)
    elseif value == 4
      Data.Out(Four, 0)
    elseif value == 5
      Data.Out(Five, 0)
    elseif value == 6
      Data.Out(Six, 0)
    elseif value == 7
      Data.Out(Seven, 0)
    elseif value == 8
      Data.Out(Eight, 0)
    elseif value == 9
      Data.Out(Nine, 0)
    else
      Data.Out(Ten, 0)                                                         
}}

pub myTermStrNL(iString)

  term.str(iString)
  term.tx(13)
  term.tx(10)
  
pub myTermDecNL(iDec)

  term.dec(iDec)
  term.tx(13)
  term.tx(10)