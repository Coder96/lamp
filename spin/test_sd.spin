con { timing }

  _clkmode = xtal1 + pll16x                                     
  _xinfreq = 5_000_000                                          ' use 5MHz crystal

  CLK_FREQ = (_clkmode >> 6) * _xinfreq                         ' system freq as a constant
  MS_001   = CLK_FREQ / 1_000                                   ' ticks in 1ms
  US_001   = CLK_FREQ / 1_000_000                               ' ticks in 1us

  sdDOpin   = 0     ' Data Out Pin
  sdCKpin   = 1     ' Clock Pin
  sdDIpin   = 2     ' Data in Pin
  sdCSpin   = 3     ' Chip Select Pin

  sdWPpin   = -1    ' Write Protect Pin -1 if unused.
  sdCDpin   = -1    ' Card Detect Pin   -1 if unused.

  sdLEDpin  = 23    ' Status LED pin number.

con { io pins }

  RX1  = 31                                                     ' programming / terminal
  TX1  = 30
  
  SDA  = 29                                                     ' eeprom / i2c
  SCL  = 28

obj

  sd    : "SD-MMC_FATEngine.spin"
  time  : "jm_time_80.spin" 
  
dat

  long  tl1   $10_10_10_10


pub main 

  sd.fatEngineStart( sdDOpin, sdCKpin, sdDIpin, sdCSpin, sdWPpin, sdCDpin, -1, -1, -1)

  sd.writeLong(tl1)

  blinkStatusLed(times)

pub blinkStatusLed(times)

  repeat times
    outa[sdLEDpin] := 1
    time.pause(1000)
    outa[sdLEDpin] := 0
    time.pause(1000)