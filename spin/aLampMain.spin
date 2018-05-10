con { timing }

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000                    ' use 5MHz crystal

  CLK_FREQ = (_clkmode >> 6) * _xinfreq   ' system freq as a constant
  MS_001   = CLK_FREQ / 1_000             ' ticks in 1ms
  US_001   = CLK_FREQ / 1_000_000         ' ticks in 1us

                    ' 
' io pins sd card 

  sdDOpin   = 16 '19     ' Data Out Pin
  sdCKpin   = 17 '18     ' Clock Pin
  sdDIpin   = 18 '17     ' Data in Pin
  sdCSpin   = 19 '16     ' Chip Select Pin

'  sdWPpin   = 5    ' Write Protect Pin -1 if unused.
'  sdCDpin   = 6    ' Card Detect Pin   -1 if unused.

  sdLEDpin  = 15 '14     ' Status LED pin number.

'------ stepDisp Shift Register Pins------
  sdiLHpin  = 21 '22     ' Latch Pin
  sdiCKpin  = 22 '21     ' Clock Pin
  sdiDIpin  = 23 '20     ' Data in Pin
  sdiChipNum = 2     ' Number of 595 chips

' io pins serial interface 

  Baudrate  = 9600
  RXpin     = 24    ' terminal
  TXpin     = 25
'  RXpin     = 31    ' programming
'  TXpin     = 30


  SDA       = 29    ' eeprom / i2c
  SCL       = 28


  systemErrorPin  = 16

  rgbWpin = 20     ' Data Ping for RGBW strip
 ' rgbwStripLength = 7
  rgbwStripLength = 288
  
'Binary strings that are sent to the shift register to make the desired number visible on the 7-segment display
'              01234567
  sdiZero   = %11000000            
  sdiOne    = %11111001
  sdiTwo    = %10100100
  sdiThree  = %10110000
  sdiFour   = %10011001
  sdiFive   = %10010010
  sdiSix    = %10000010
  sdiSeven  = %11111000
  sdiEight  = %10000000
  sdiNine   = %10011000
  sdiDot    = %01111111
  sdiAllOff = %11111111
  sdiAllOn  = %00000000
  
  
obj

  sd      : "fsrw"                        ' * uSD file IO
  rgbw    : "jm_rgbx_pixel"               '   unified pixel driver
  time    : "jm_time_80"                  '   delays/timing
  io      : "jm_io"                       '   basic io
  parser  : "jm_parser"                   '   text parsing
  str     : "jm_strings"                  '   strings support
  term    : "jm_fullduplexserial"         ' * serial for terminal
  stepDisp: "74HC595_Regular"             ' * Seven Segment Display

' * uses cog when loaded 

dat
  frameRecordDelimiter long  $01_01_01_01
  frameFieldDelimiter  long  $02_02_02_02
'   long  $03_03_03_03
'   long  $04_04_04_04
'   long  $05_05_05_05
'   long  $06_06_06_06
'   long  $07_07_07_07
'   long  $08_08_08_08
'   long  $09_09_09_09
  
var

  long  frameBuff1[rgbwStripLength]      ' Buffer pointer for RGB Strip
  long  frameBuff2[rgbwStripLength]      ' Buffer for RGB Strip
  long  framePauseTimer                  ' Pause time between frames
  
  byte  framefile[13]
  byte  option[3]
  byte  endOfFrameFile
  
'****************************************************************
'
'
'

pub main
  
  start             ' Misc Init Process
  
  endOfFrameFile := false
  
  if (read_configuration)
    term.str(string("Filename... "))
    term.str(@framefile)
    term.tx(13)
    term.tx(10)
  
    OpenFile(@framefile,"r")
  
  repeat 
    frameRead
    framePause
  
'  closeFile

  repeat
    waitcnt(0)

var                                                              
                                                                 
  long  sdMounted                                                  
                                                                 
  byte  linebuf[80 + 1]       ' line buffer

'****************************************************************
'
'
'
pub start | errorNumber, errorString, startStep
  
  startStep := 0
  
  ' Set all the pins low
  io.start(0, 0)

  stepDisp.Start(sdiCKpin, sdiLHpin, sdiDIpin, sdiChipNum)
  stepDisp.Out(sdiOne, 0)
  stepDisp.Out(sdiAllOff, 1)
   
  term.start(RXpin, TXpin, %0000, Baudrate)
  stepDisp.Out(sdiTwo, 0)
  stepDisp.Out(sdiAllOff, 1)
  
  term.str(string("IO Cleared "))  
  term.tx(13)
  term.tx(10)
  
  term.Str(String("Step Display Initialized"))
  term.tx(13)
   term.tx(10)
  
  term.Str(String("Terminal Initialized"))
  term.tx(13)
  term.tx(10)
  
  term.Str(String("InitializingTimer System"))
  term.tx(13)
  term.tx(10)
  time.start
  stepDisp.Out(sdiThree, 0)
  stepDisp.Out(sdiAllOff, 1)

  term.Str(String("Timer System Initialized"))
  term.tx(13)
  term.tx(10)
  
  parser.start(@CHAR_SET, @TOKEN_LIST, TOKEN_COUNT, false)      ' setup parsing engine         
  stepDisp.Out(sdiFour, 0)
  stepDisp.Out(sdiAllOff, 1)

  term.str(string("Parser System Started"))  
  term.tx(13) 
  term.tx(10)
  stepDisp.Out(sdiFive, 0)
  stepDisp.Out(sdiAllOff, 1)
  
  term.Str(String("Initializing SD Card System"))
  term.tx(13)
  term.tx(10)
  
  errorNumber := \sd.mount_explicit(sdDOpin, sdCKpin, sdDIpin, sdCSpin)
  
  sdMounted := (errorNumber == 0)   
  
  if(sdMounted) ' If we have an error spit out error and turn on error light. Might end also?
    term.Str(String("SD Card Mounted"))
    term.tx(13)
    term.tx(10)
  else
    io.high(systemErrorPin)
    term.Str(String("SD Card NOT Mounted"))  
    term.tx(13)
    term.tx(10)
    stepDisp.Out(sdiOne, 0)
    stepDisp.Out(sdiSix, 1)
    term.Str(String("SD Card Partition Mount Error: "))  
    term.dec(errorNumber)
    term.tx(13)
     term.tx(10)
    if(errorNumber == -20)
      term.Str(String("Not a fat16 or fat32 volume"))
    elseif(errorNumber == -21)
      term.Str(String("Bad bytes per sector"))
    elseif(errorNumber == -22)
      term.Str(String("Bad sectors per cluster"))
    elseif(errorNumber == -23)
      term.Str(String("Not two FATs"))
    elseif(errorNumber == -24)
      term.Str(String("Bad FAT signature"))
    
    term.tx(13)  
    term.tx(10)
    term.Str(String("***"))
    term.tx(13)  
    term.tx(10)
    term.Str(String("If you thinks the card is still good.")) 
    term.tx(13)
    term.tx(10)  
    term.Str(String("Get the files off and format to fat32."))
    term.tx(13)
    term.tx(10)
    term.Str(String("***"))
    term.tx(13)
    term.tx(10)  
    
    repeat                                                         
      waitcnt(0)
  
  term.Str(String("SD Card System Initialized"))
  term.tx(13)
  term.tx(10)
  stepDisp.Out(sdiSix, 0)
  stepDisp.Out(sdiAllOff, 1)

  term.Str(String("Initializing RGBW Strip System"))
  term.tx(13)
  term.tx(10)
  rgbw.start_6812x(@frameBuff1, rgbwStripLength, rgbWpin, 1_0, 32)
  stepDisp.Out(sdiSeven, 0)
  stepDisp.Out(sdiAllOff, 1)

  term.Str(String("RGBW Strip System Initialized"))
  term.tx(13)
  term.tx(10)
  
'****************************************************************
'
'
'
'' Attempt to open file
'' -- p_str is pointer to filename (z-string)
'' -- mode is [lower-case] single character, (e.g., "r" for read)
'' -- sd card must be mounted before open
'
pub OpenFile(p_str, mode) | errorNumber
  
  term.Str(String("Opening File: "))
  term.Str(p_str)
  term.tx(13)
  term.tx(10)
    
  if (sdMounted)                                                   
    errorNumber := \sd.popen(p_str, mode)                             ' attempt to open
    if (errorNumber == 0)                                              
      term.Str(String("File Opened"))
      term.tx(13)
      term.tx(10)
      if (mode == "r")                                           
        \sd.seek(0)                                             ' force sector read 
      return true                                                
    else
      term.Str(String("File Not Opened"))
      term.tx(13)
      term.tx(10)
      stepDisp.Out(sdiOne, 0)
      stepDisp.Out(sdiFour, 1)                                             
      return false
  else
    term.Str(String("Not mounted. How are you here?"))
    term.tx(13)
    term.tx(10)
    stepDisp.Out(sdiOne, 0)
    stepDisp.Out(sdiSix, 1)
    return false
    
'****************************************************************
'
'
'
pub closeFile

  term.Str(String("Closeing File. "))
  term.tx(13)
  term.tx(10)
  \sd.pclose
  term.Str(String("File Closed. "))
  term.tx(13)
  term.tx(10)
'****************************************************************
'
'
' 
pub frameRead : r | tLong, indexPixel

  stepDisp.Out(sdiTwo, 0)
  stepDisp.Out(sdiZero, 1)

  term.Str(String("************************* Start New frame"))
  term.tx(13)
  term.tx(10)
  term.Str(String("Reading Pixel Data"))
  term.tx(13)
  term.tx(10)
  indexPixel := 0
  repeat indexPixel from 1 to rgbwStripLength 
    tLong := \frameReadLong
    if(endOfFrameFile)
      term.Str(String("EOF Start Over"))
      term.tx(13)
      term.tx(10)
      \sd.seek(0)
      endOfFrameFile := false
      tLong := \frameReadLong
    if(tLong == frameFieldDelimiter)      ' Pixel Data Done
      term.Str(String("Found Field Delimiter:"))
      term.Hex(tLong, 8)
      term.tx(13)
      term.tx(10)
      quit                               ' Move on to next section
    else
      frameBuff2[indexPixel-1] := tLong

  term.Str(String("Done reading Pixel Data"))
  term.tx(13) 
  term.tx(10)
  
  repeat
    if(tLong <> frameFieldDelimiter)    ' Need to feild delimiter if not found during pixel data read. Picture to big?
      if(tLong == frameRecordDelimiter)
        endOfFrameFile := true
        quit
      else 
        tLong := \frameReadLong
    else
      quit          

  ifnot(endOfFrameFile)
    term.Str(String("Reading Pause Time"))
    term.tx(13)
    term.tx(10) 
    framePauseTimer := \frameReadLong
    term.Str(String("Pause Time:"))
    term.Dec(framePauseTimer)
    term.Str(String(":"))
    term.Hex(framePauseTimer, 8)
    term.tx(13)
    term.tx(10)  
    term.Str(String("Done Reading Pasue Time"))
    term.tx(13)
    term.tx(10) 
      
    term.Str(String("Reading Should Be Recrod Delimiter"))
    term.tx(13) 
    term.tx(10)
    
    tLong := \frameReadLong
    
    if(tLong == frameRecordDelimiter)
      term.Str(String("Record Delimiter Found"))
      term.tx(13)
      term.tx(10)
    else
      stepDisp.Out(sdiTwo, 0)
      stepDisp.Out(sdiFive, 1)
  
      term.Str(String("Record Delimiter NOT Found"))
      term.tx(13)
      term.tx(10)
      term.Str(String("File Corruped Or File Format Not Supported"))
      term.tx(13)
      term.tx(10)
      term.Str(String("Offending HEX: "))
      term.Hex(tLong, 8)
      term.Str(String("Offending DEC: "))
      term.dec(tLong) 
      term.tx(13)
      term.tx(10)

  
  if(endOfFrameFile)
    term.Str(String("EOF Start Over"))
    term.tx(13)
    term.tx(10)
    \sd.seek(0)
    endOfFrameFile := false
    
  term.Str(String("Sending Frame"))
  term.tx(13)
  term.tx(10)
  longmove(@frameBuff1, @frameBuff2, 4)
  term.Str(String("Frame Sent"))
  term.tx(13)
  term.tx(10)
  stepDisp.Out(sdiTwo, 0)
  stepDisp.Out(sdiNine, 1)

'****************************************************************
'
'
'
var
  byte  frameReadLongBuff[4]
  long  frameReadLongmBuff2

pub frameReadLong | ctr, char1

  repeat ctr from 0 to 3 
    char1 := \sd.pgetc
    if(char1 == -1)
      endOfFrameFile := true
    frameReadLongBuff[ctr] := char1
  Bytemove(@frameReadLongmBuff2, @frameReadLongBuff,4)
   
  return frameReadLongmBuff2
        
'****************************************************************
'
'
'
pub framePause
  term.Str(String("Lets Pasue for: "))
  term.Dec(framePauseTimer)
  term.Str(String(" ms"))
  term.tx(13)
  term.tx(10)
  time.pause(framePauseTimer)
  term.Str(String("Lets Move On"))
  term.tx(13)
  term.tx(10)
  
'****************************************************************
'
'
'
'pub frameNext
'****************************************************************
'
'
'
pub has_file(p_str) | check

'' Returns true if file is on SD card

  check := \sd.popen(p_str, "r")
  if (check == 0)
    return true
  else
    return false

pub open_file(p_str, mode) | check

'' Attempt to open file
'' -- p_str is pointer to filename (z-string)
'' -- mode is [lower-case] single character, (e.g., "r" for read)
'' -- sd card must be mounted before open

  if (sdMounted)                                                   
    check := \sd.popen(p_str, mode)                             ' attempt to open
    if (check == 0)                                              
      if (mode == "r")                                           
        \sd.seek(0)                                             ' force sector read 
      return true                                                
    else                                                         
      return false
  else
    return false
pub close_file

'' Closes open file

  \sd.pclose


pub rd_line(p_str, n) | c, len

'' Reads line of text from open text file
'' -- terminated by LF or EOF
'' -- p_str is address of string buffer
'' -- n is maximum number of characters to read from line

  len := 0                                                      ' index into string
                                                                 
  repeat n                                                       
    c := \sd.pgetc                                              ' get a character
    if (c < 0)                                                  ' end of file
      if (len == 0)                                             ' if nothing
        return -1                                               ' return empty
      else                                                       
        quit                                                     
                                                                 
    if (c <> 10)                                                ' if not LF char
      byte[p_str++] := c                                        '  add to buffer
      len++                                                      
    else                                                        ' if LF
      quit                                                      '  we're done
                                                                 
  byte[p_str] := 0                                              ' terminate end of line
                                                                 
  return len
    
dat

  CfgFile               byte    "STARTUP.TXT", 0


pub read_configuration | check

  ifnot (has_file(@CfgFile))
    term.str(string("Error: Cannot open STARTUP.TXT", 13))
    return false

  term.str(string("Opened STARTUP.TXT", 13))
  open_file(@CfgFile, "r")

  repeat
    bytefill(@linebuf, 0, 80+1)                                 ' clear for full line
    check := rd_line(@linebuf, 80)                              ' read line from file
    if (check =< 0)                                             ' if end of file
      quit
    else
      str.replace(39, 0, @linebuf)                              ' remove comments (single quote)   
      str.replace(13, 0, @linebuf)                              ' remove extra CRs
      str.trim(@linebuf)                                        ' clean-up
      if (strsize(@linebuf))                                    ' if we have a line
        check := parser.enqueue_str(@linebuf)                   ' send to parser    
        if (check)                                              ' have valid tokens?
          process_cmd                                          
          parser.reset                                          ' reset parser for next command     
                                                               
  close_file

  return true                                                   ' found and read file                                       


dat { configure parser characters and tokens }

  CHAR_SET              byte    "$%+-_"
                        byte    ".0123456789"
                        byte    "ABCDEFGHIJKLMNOPQRSTUVWXYZ", 0   
  
  TOKEN_LIST            byte    "FRAMEFILE", 0                   ' FILENAME string
                        byte    "OPTION", 0                     ' OPTION # value

                        
con { enumerated token indexes }

  #0, T_FRAMEFILE, T_OPTION, TOKEN_COUNT 
  

pub process_cmd | tidx

  tidx := parser.get_token_id(parser.token_addr(0))              ' get index of command token
     
  case tidx
    T_FRAMEFILE : cmd_framefile
    T_OPTION   : cmd_option


pub cmd_framefile | tc, p_name
  
  tc := parser.token_count
  if (tc <> 2)                                                  ' syntax = FILENAME string
    return

  p_name := parser.token_addr(1)                                ' get address of name
  bytefill(@framefile, 0, 13)                                    ' reset
  bytemove(@framefile, p_name, strsize(p_name) <# 12)            ' copy token to filename - 12 chars max  

    
pub cmd_option | tc, idx, value

  tc := parser.token_count
  if (tc <> 3)                                                  ' syntax = OPTION # byte_value
    return

  idx := parser.token_value(1)

  if ((idx < 0) or (idx > 2))                                   ' valid option # 
    return

  option[idx] := 0 #> parser.token_value(2) <# 255              ' set option


  
