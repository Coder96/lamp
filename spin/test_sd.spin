con { timing }

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000                                          ' use 5MHz crystal

  CLK_FREQ = (_clkmode >> 6) * _xinfreq                         ' system freq as a constant
  MS_001   = CLK_FREQ / 1_000                                   ' ticks in 1ms
  US_001   = CLK_FREQ / 1_000_000                               ' ticks in 1us


con { io pins }

  sdDOpin   = 1     ' Data Out Pin
  sdCKpin   = 2     ' Clock Pin
  sdDIpin   = 3     ' Data in Pin
  sdCSpin   = 4     ' Chip Select Pin

  sdWPpin   = -1    ' Write Protect Pin -1 if unused.
  sdCDpin   = -1    ' Card Detect Pin   -1 if unused.

  sdLEDpin  = 23    ' Status LED pin number.

  RX1  = 31         ' programming / terminal
  TX1  = 30

  SDA  = 29         ' eeprom / i2c
  SCL  = 28
  
con { settings  }

  maxled = 288

obj

  sd    : "SD-MMC_FATEngine.spin"
  time  : "jm_time_80.spin" 
  pst   : "Parallax Serial Terminal"
  
dat

  tl1   long  $FF_FF_FF_00
  tl2   long  $FF_FF_FF_00, $10_FF_FF_00
  sle   long  $00_00_17_70
  recordDelimiter long  $01_01_01_01
  fieldDelimiter  long  $02_02_02_02

pub main | errorNumber, errorString, tLong

  pst.Start(115200)
  pst.Str(String("Starting "))
  

  pst.dec(sle)
  pst.Chars(pst#NL, 2)
  readFile

  repeat ' Wait until reset or power down.  
          
PRI readFile | errorNumber, errorString, tLong
  
  sd.fatEngineStart( sdDOpin, sdCKpin, sdDIpin, sdCSpin, sdWPpin, sdCDpin, -1, -1, -1)

  errorString := \code ' Returns the address of the error string or null.
  errorNumber := sd.partitionError ' Returns the error number or zero.

  pst.Str(errorString)

  if(errorNumber) ' Light a LED if an error occurs.
    outa := constant(|<sdLEDpin)
    dira := constant(|<sdLEDpin)
    
  errorString := \sd.openFile(String("TEST4.bin"), "R")
  
  errorNumber := sd.partitionError
  pst.Str(errorString)
  pst.Chars(pst#NL, 2)
  repeat 7
    tLong := sd.readLong
    if(tLong == fieldDelimiter)
      quit
    pst.Hex(tLong, 8)
    pst.Str(String(" "))
    pst.dec(tLong) 
    pst.Chars(pst#NL, 2)
  
  sd.closeFile
  

  
PRI mwriteFile
 
  sd.openFile(sd.newFile(String("test2.txt")), "W")
    
  sd.writeLong(tl2[0])
  sd.writeLong(tl2[1])
  sd.closeFile
  blinkStatusLed(2)       

PRI code ' Put the file system calls in a separate method to trap aborts.
  sd.mountPartition(0) ' Mount the default partition 0. Can be 0 - 3.



'  if(sd.partitionMounted)
'    sd.unmountPartition



'	High(17)

'	

'	High(18)

'	sd.writeLong(tl1)

'  blinkStatusLed(2)

'	sd.closeFile

'	sd.openFile(string("test2.txt"), "W")

'  sd.writeLong(tl2[0])
'	sd.writeLong(tl2[1])

'  blinkStatusLed(2)

'  sd.closeFile

'  repeat

pub blinkStatusLed(times)

  repeat times
    High(sdLEDpin)
    time.pause(1000)
    Low(sdLEDpin)
    time.pause(1000)
    
PUB High(pin)
  outa[pin] := 1
  dira[pin] := 1
  
PUB Low(pin)
  outa[pin] := 1
  dira[pin] := 0
  
PRI statusLED(frequency) | buffer, counter ' Configure the status LED.

  ' Frequency must be between 0 and (clkfreq / 2). Otherwise output is always 1.

  buffer := ((0 < frequency) and (frequency =< (clkfreq >> 1)))

  outa[sdLEDpin] := (not(buffer))
  ctra := (buffer & constant((%00100 << 26) + sdLEDpin))
  dira[sdLEDpin] := true

  counter := 1
  repeat 32 ' Preform (((frequency << 32) / clkfreq) + 1)

    frequency <<= 1
    counter <-= 1
    if(frequency => clkfreq)
      frequency -= clkfreq
      counter += 1

  frqa := (buffer & counter) ' Output is always 0 if frequency is 0.