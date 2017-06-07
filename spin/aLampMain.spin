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

'  sdWPpin   = -1    ' Write Protect Pin -1 if unused.
'  sdCDpin   = -1    ' Card Detect Pin   -1 if unused.

  sdLEDpin  = 17    ' Status LED pin number.

con { io pins RGBW strip }

  rgbWpin = 0       ' Data Ping for RGBW strip

con { io pins serial interface }

  Baudrate = 9600
  RXpin  = 31       ' programming / terminal
  TXpin  = 30

  SDA  = 29         ' eeprom / i2c
  SCL  = 28

con {  }
  systemStatusPin = 15
  systemErrorPin  = 16
  rgbwStripLength = 5
'  rgbwStripLength = 288
  
obj

  sd    : "SD-MMC_FATEngine.spin"       ' File System Driver
  time  : "jm_time_80.spin"             ' timing and delays
  rgbw  : "jm_rgbx_pixel"               ' unified pixel driver
  pst   : "Parallax Serial Terminal"    ' Serial Terminal
  str   : "STRINGS2"                    ' String lib

dat
    frameRecordDelimiter long  $01_01_01_01
    frameFieldDelimiter  long  $02_02_02_02

var

  long  frameBuff1[rgbwStripLength]      ' Buffer pointer for RGB Strip
  long  frameBuff2[rgbwStripLength]      ' Buffer for RGB Strip
  long  framePauseTimer                 ' Pause time between frames
  
  byte  frameFileName[13]                 '
'****************************************************************
'
'
'
pub main
  start             ' Misc Init Process
  
  readStartFile
  OpenFile(@frameFileName)
  frameRead
'  closeFile
  
  'longfill(@frameBuff1, $20_20_00_00, rgbwStripLength)
  repeat
  
'****************************************************************
'
'
'
pub start | errorNumber, errorString
  
  systemStatusPinOn
  
  pst.StartRxTx(RXpin, TXpin, 0, Baudrate)
  pst.Str(String("Serail System Initialized"))
  pst.Chars(pst#NL, 2)
  
  pst.Str(String("Initializing SD Card System"))
  pst.Chars(pst#NL, 2)
  sd.fatEngineStart(sdDOpin, sdCKpin, sdDIpin, sdCSpin, -1, -1, -1, -1, -1)
  pst.Str(String("SD Card System Initialized"))
  pst.Chars(pst#NL, 2)
  
  pst.Str(String("Mounting SD Card"))
  pst.Chars(pst#NL, 2)
  errorString := \sd.mountPartition(0) ' Mount the default partition 0. Can be 0 - 3.
  errorNumber := sd.partitionError
  if(errorNumber) ' If we have an error spit out error and turn on error light. Might end also?
    pst.Str(String("SD Card Partition 0 "))  
    pst.Chars(pst#NL, 2)    
    pst.Str(String("SD Card Partition Mount Error: "))  
    pst.Str(errorString)
    pst.Chars(pst#NL, 2)    
    systemErrorPinOn
    ' infinate loop?
  else
    pst.Str(String("SD Card Partition 0 Mounted"))
    pst.Chars(pst#NL, 2)    


  pst.Str(String("InitializingTimer System"))
  pst.Chars(pst#NL, 2)
  time.start
  pst.Str(String("Timer System Initialized"))
  pst.Chars(pst#NL, 2)
 
  pst.Str(String("Initializing RGBW Strip System"))
  pst.Chars(pst#NL, 2)
  rgbw.start_6812x(@frameBuff1, rgbwStripLength, rgbWpin, 1_0, 32)
  pst.Str(String("RGBW Strip System Initialized"))
  pst.Chars(pst#NL, 2)
  
 '****************************************************************
 '
 '
 '
pub OpenFile(fileName) | errorString, errorNumber
  
  pst.Str(String("Opening File: "))
  pst.Str(fileName)
  pst.Chars(pst#NL, 2)
  errorString := \sd.openFile(fileName, "R")
  errorNumber := sd.partitionError
  if(errorNumber) 
    pst.Str(String("Error Opening File"))
    pst.Chars(pst#NL, 2)
    systemErrorPinOn      ' Turn on error light.
    ' infinate loop?
  else
    pst.Str(String("File Opened"))
    pst.Chars(pst#NL, 2)
'****************************************************************
'
'
'
pub closeFile

  pst.Str(String("Closeing File. "))
  pst.Chars(pst#NL, 2)
  sd.closeFile
  pst.Str(String("File Closed. "))
  pst.Chars(pst#NL, 2)
'****************************************************************
'
'
' 
pub frameRead | tLong, indexPixel
  
  pst.Str(String("Reading Pixel Data"))
  pst.Chars(pst#NL, 2) 
  repeat indexPixel from 1 to rgbwStripLength 
    tLong := sd.readLong
    if(tLong == frameFieldDelimiter)     ' Pixel Data Done
      quit                          ' Move on to next section
    else
      frameBuff2[indexPixel] := tLong
       pst.Hex(tLong, 8)
       pst.Chars(pst#NL, 2) 
       
  pst.Str(String("fb:"))
  pst.Hex(@frameBuff2, 8)
  pst.Chars(pst#NL, 2) 
  pst.Str(String("Done reading Pixel Data"))
  pst.Chars(pst#NL, 2) 

  pst.Str(String("Reading Pasue Time"))
  pst.Chars(pst#NL, 2) 
  framePauseTimer := sd.readLong
  pst.Str(String("Pasue Time:"))
  pst.Dec(framePauseTimer)
  pst.Str(String(":"))
  pst.Hex(framePauseTimer, 8)
  pst.Chars(pst#NL, 2)  
  pst.Str(String("Done Reading Pasue Time"))
  pst.Chars(pst#NL, 2) 
    
  pst.Str(String("Reading Should Be Recrod Delimiter"))
  pst.Chars(pst#NL, 2) 

  tLong := sd.readLong
  
  if(tLong == frameRecordDelimiter)
    pst.Str(String("Recrod Delimiter Found"))
    pst.Chars(pst#NL, 2)
  else
    systemErrorPinOn
    pst.Str(String("Recrod Delimiter NOT Found"))
    pst.Chars(pst#NL, 2)
    pst.Str(String("File Corruped Or File Format Not Supported"))
    pst.Chars(pst#NL, 2)
    pst.Str(String("Offending HEX: "))
    pst.Hex(tLong, 8)
    pst.Str(String("Offending DEC: "))
    pst.dec(tLong) 
    pst.Chars(pst#NL, 2)
    
    longmove(@frameBuff2, @frameBuff1, 4)
    
'****************************************************************
'
'
'
pub framePause
'****************************************************************
'
'
' 
pub frameNext
'****************************************************************
'
'
'
pub systemStatusPinOn
  outa[systemStatusPin] := 1
  dira[systemStatusPin] := 1
'****************************************************************
'
'
'
pub systemStatusPinOff
  outa[systemStatusPin] := 1
  dira[systemStatusPin] := 0
'****************************************************************
'
'
'
pub systemErrorPinOn
  outa[systemErrorPin] := 1
  dira[systemErrorPin] := 1
'****************************************************************
'
'
'
pub systemErrorPinOff
  outa[systemErrorPin] := 1
  dira[systemErrorPin] := 0
'****************************************************************
'
'
'
pub sdLEDpinOn
  outa[sdLEDpin] := 1
  dira[sdLEDpin] := 1
'****************************************************************
'
'
'
pub sdLEDpinOff
  outa[sdLEDpin] := 1
  dira[sdLEDpin] := 0
'****************************************************************
'
'
'
pub readStartFile 
  openFile(string("startup.txt"))
  sd.readString(@frameFileName, 13)
  pst.Str(string("File to start with: "))
  pst.Str(@frameFileName)
  
'  pst.Char(frameFileName[0])
'  pst.Char(frameFileName[1])
'  pst.Char(frameFileName[2])
'  pst.Char(frameFileName[3])
'  pst.Char(frameFileName[4])
'  pst.Char(frameFileName[5])
'  pst.Char(frameFileName[6])
'  pst.Char(frameFileName[7])
'  pst.Char(frameFileName[8])
'  pst.Char(frameFileName[9])
'  pst.Char(frameFileName[10])
'  pst.Char(frameFileName[11])
'  pst.Char(frameFileName[12])
  'pst.Char(frameFileName[13])

  pst.Chars(pst#NL, 2)

  closeFile
