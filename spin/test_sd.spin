con { timing }

  _clkmode = xtal1 + pll16x                                     
  _xinfreq = 5_000_000                                          ' use 5MHz crystal

  CLK_FREQ = (_clkmode >> 6) * _xinfreq                         ' system freq as a constant
{  MS_001   = CLK_FREQ / 1_000                                   ' ticks in 1ms
  US_001   = CLK_FREQ / 1_000_000                               ' ticks in 1us

  sdDOpin   = 1     ' Data Out Pin
  sdCKpin   = 2     ' Clock Pin
  sdDIpin   = 3     ' Data in Pin
  sdCSpin   = 4     ' Chip Select Pin

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

  tl1   long  $FF_FF_FF_00
  tl2   long  $FF_FF_FF_00, $FF_FF_FF_00

}
pub main 

	outa[16] := 1
	dira[16] := 1
	outa[17] := 1
	dira[17] := 1
	outa[18] := 1
	dira[18] := 1
	outa[19] := 1
	dira[19] := 1
	outa[20] := 1
	dira[20] := 1
	outa[21] := 1
	dira[21] := 1
	outa[22] := 1
	dira[22] := 1
	outa[23] := 1
	dira[23] := 1

{  sd.fatEngineStart( sdDOpin, sdCKpin, sdDIpin, sdCSpin, sdWPpin, sdCDpin, -1, -1, -1)

	outa[17] := 1

	sd.openFile(string("test1.txt"), "W")

	outa[18] := 1

	sd.writeLong(tl1)

  blinkStatusLed(2)

	sd.closeFile
	
	sd.openFile(string("test2.txt"), "W")

  sd.writeLong(tl2[0])
	sd.writeLong(tl2[1])
	
  blinkStatusLed(2)

  sd.closeFile
  
pub blinkStatusLed(times)

  repeat times
    outa[sdLEDpin] := 1
    time.pause(1000)
    outa[sdLEDpin] := 0
    time.pause(1000)
    
    }
    