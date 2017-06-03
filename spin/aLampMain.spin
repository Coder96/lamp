con { timing }

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000                    ' use 5MHz crystal

  CLK_FREQ = (_clkmode >> 6) * _xinfreq   ' system freq as a constant
  MS_001   = CLK_FREQ / 1_000             ' ticks in 1ms
  US_001   = CLK_FREQ / 1_000_000         ' ticks in 1us

con { io pins sd card }

  sdDOpin   = 1     ' Data Out Pin
  sdCKpin   = 2     ' Clock Pin
  sdDIpin   = 3     ' Data in Pin
  sdCSpin   = 4     ' Chip Select Pin

  sdWPpin   = -1    ' Write Protect Pin -1 if unused.
  sdCDpin   = -1    ' Card Detect Pin   -1 if unused.

  sdLEDpin  = 23    ' Status LED pin number.

con { io pins RGBW strip }

  rgbWpin = 0       ' Data Ping for RGBW strip

con { io pins serial interface }

  Baudrate = 115200
  RXpin  = 31       ' programming / terminal
  TXpin  = 30

  SDA  = 29         ' eeprom / i2c
  SCL  = 28

con {  }

  rgbStripLength = 288
  
  
obj

  sd    : "SD-MMC_FATEngine.spin"       ' File System Driver
  time  : "jm_time_80.spin"             ' timing and delays
  RGBWs : "jm_rgbx_pixel"               ' unified pixel driver
  pst   : "Parallax Serial Terminal"    ' Serial Terminal

var

  long  pixels1[rgbStripLength]         ' Buffer pointer for RGB Strip
  long  pixels2[rgbStripLength]         ' Buffer for RGB Strip
  long  framePause                      ' Pause time between frames

PUB main
  start
  
  
PUB start
  
  sd.fatEngineStart(sdDOpin, sdCKpin, sdDIpin, sdCSpin, -1, -1, -1, -1, -1)
  sd.mountPartition(0) ' Mount the default partition 0. Can be 0 - 3.
  
  time.start
  
  strip.RGBWs(@pixels1, rgbStripLength, rgbWpin, 1_0, 32)
  
  pst.StartRxTx(RXpin, TXpin, 0, Baudrate)
  
  
  