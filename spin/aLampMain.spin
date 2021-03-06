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

  sdLEDpin  = 26 '14     ' Status LED pin number.

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


  systemErrorPin  = 27

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
  byte  startUpType[10]
  byte  repeatMode[2]
  byte  turnoffatend[2]
  
con
  framesfilesNum = 10
var
  byte  framesfiles[13*framesfilesNum]
  byte  framesFilesSize[framesfilesNum]
  
'****************************************************************
pub main | index
  
  repeatMode := string("Y")
  
  myTermStrNL(string("*********************** System Starting."))
  start 'Init Process
  
  endOfFrameFile := false
  
  if (read_configuration)
  
    myTermStrNL(string("***Starting Config***"))
    term.str(string("STARTUPTYPE  : "))
    myTermStrNL(@startUpType)
    term.str(string("REPEATMODE   : "))
    myTermStrNL(@repeatMode)
    term.str(string("TURNOFFATEND : "))
    myTermStrNL(@turnoffatend)
    
    if(strcomp(@startUpType, string("SINGLE")))
      singleFileMode
    if(strcomp(@startUpType, string("MULTI")))
      multiFileMode
      
  myTermStrNL(string("*********************** System Stoping."))
  stepDisp.Out(sdiZero, 0)
  stepDisp.Out(sdiZero, 1)
  
  repeat
    waitcnt(0)
'*********************************************************************
pub singleFileMode

  myTermStrNL(string("Starting Single File Mode."))
  term.str(string("Frame File :"))
  myTermStrNL(@framefile)
  term.str(string("Repeat File:"))
  myTermStrNL(@repeatMode)
  
  if(OpenFile(@framefile,"r"))

    repeat 
      frameRead
      ifnot(endOfFrameFile)
        framePause
      else
        sd.seek(0)
        endOfFrameFile := false
        if(strcomp(@repeatMode, string("N")))
          return
'*********************************************************************       
pub multiFileMode | x, index


  myTermStrNL(string("Starting Multi File Mode."))
  repeat 
    repeat index from 0 to 9
      myTermStrNL(string("***New File"))
      term.str(string("File :"))
      bytemove(@framefile, @framesfiles[index*13] ,12)
      myTermStrNL(@framefile)
      term.str(string("Index:"))
      myTermDecNL(index)
      
      bytefill(@framefile, 0, 12)
      bytemove(@framefile, @framesfiles[index*13] ,framesFilesSize[0])
      if(\OpenFile(@framefile,"r"))
        longfill(@frameBuff2, $00_00_00_00, rgbwStripLength)
        longmove(@frameBuff1, @frameBuff2, rgbwStripLength)
        x := 0
        repeat until x == 1
          frameRead
            ifnot(endOfFrameFile)
              framePause
            else
              closeFile(@framefile)
              x := 1
    ifnot(strcomp(@repeatMode, string("Y")))
      return  
var                                                              
                                                                 
  long  sdMounted                                                  
                                                                 
  byte  linebuf[80 + 1]       ' line buffer

'****************************************************************
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
  
  myTermStrNL(string(" "))
  myTermStrNL(string(" "))
  myTermStrNL(string(" "))
  
  myTermStrNL(string("IO Cleared "))  
  
  myTermStrNL(String("Step Display Initialized"))
  
  myTermStrNL(String("Terminal Initialized"))
  
  myTermStrNL(string("InitializingTimer System"))
  time.start
  stepDisp.Out(sdiThree, 0)
  stepDisp.Out(sdiAllOff, 1)

  myTermStrNL(String("Timer System Initialized"))
  
  parser.start(@CHAR_SET, @TOKEN_LIST, TOKEN_COUNT, false)      ' setup parsing engine         
  stepDisp.Out(sdiFour, 0)
  stepDisp.Out(sdiAllOff, 1)

  myTermStrNL(string("Parser System Started"))  
  stepDisp.Out(sdiFive, 0)
  stepDisp.Out(sdiAllOff, 1)
  
  myTermStrNL(String("Initializing SD Card System"))
  
  errorNumber := \sd.mount_explicit(sdDOpin, sdCKpin, sdDIpin, sdCSpin)
  
  sdMounted := (errorNumber == 0)   
  
  if(sdMounted) ' If we have an error spit out error and turn on error light. Might end also?
    myTermStrNL(String("SD Card Mounted"))
  else
    io.high(systemErrorPin)
    myTermStrNL(String("SD Card NOT Mounted"))  
    stepDisp.Out(sdiOne, 0)
    stepDisp.Out(sdiSix, 1)
    term.str(String("SD Card Partition Mount Error: "))  
    myTermDecNL(errorNumber)
    if(errorNumber == -20)
      myTermStrNL(String("Not a fat16 or fat32 volume"))
    elseif(errorNumber == -21)
      myTermStrNL(String("Bad bytes per sector"))
    elseif(errorNumber == -22)
      myTermStrNL(String("Bad sectors per cluster"))
    elseif(errorNumber == -23)
      myTermStrNL(String("Not two FATs"))
    elseif(errorNumber == -24)
      myTermStrNL(String("Bad FAT signature"))
    
    myTermStrNL(String("***"))
    myTermStrNL(String("If you thinks the card is still good.")) 
    myTermStrNL(String("Get the files off and format to fat32."))
    myTermStrNL(String("***"))
    
    repeat                                                         
      waitcnt(0)
  
  myTermStrNL(String("SD Card System Initialized"))
  stepDisp.Out(sdiSix, 0)
  stepDisp.Out(sdiAllOff, 1)

  myTermStrNL(String("Initializing RGBW Strip System"))
  longfill(@frameBuff1, $00_00_00_00, rgbwStripLength)
  rgbw.start_6812x(@frameBuff1, rgbwStripLength, rgbWpin, 1_0, 32)
  longfill(@frameBuff1, $00_00_00_00, rgbwStripLength)
  stepDisp.Out(sdiSeven, 0)
  stepDisp.Out(sdiAllOff, 1)

  myTermStrNL(String("RGBW Strip System Initialized"))
  
'****************************************************************
'
'
'
'' Attempt to open file
'' -- p_str is pointer to filename (z-string)
'' -- mode is [lower-case] single character, (e.g., "r" for read)
'' -- sd card must be mounted before open
'
pub OpenFile(p_str, mode) : r | errorNumber
  
  term.Str(String("Opening File: "))
  myTermStrNL(p_str)
    
  if (sdMounted)                                                   
    errorNumber := \sd.popen(p_str, mode)                             ' attempt to open
    if (errorNumber == 0)                                              
      myTermStrNL(String("File Opened"))
      if (mode == "r")                                           
        \sd.seek(0)                                             ' force sector read 
      return true                                                
    else
      myTermStrNL(String("File Not Opened"))
      term.Str(String("Error Code:"))
      term.dec(errorNumber)
      myTermStrNL(String(" "))
      stepDisp.Out(sdiOne, 0)
      stepDisp.Out(sdiFour, 1)                                             
      return false
  else
    myTermStrNL(String("Not mounted. How are you here?"))
    stepDisp.Out(sdiOne, 0)
    stepDisp.Out(sdiSix, 1)
    return false
    
  return true
    
'****************************************************************
'
'
'
pub closeFile(p_str)

  term.Str(String("Closeing File:"))
  myTermStrNL(p_str)
  \sd.pclose
  endOfFrameFile := false
  myTermStrNL(String("File Closed. "))
'****************************************************************
'
'
'
pub frameRead : r | tLong, ctrPixel, curItem


' 1  Pixel Data
' 10 Pause Time
' 90 End of Frame or End of File

  curItem := 1
  ctrPixel := 0
  framePauseTimer := 0
  
  stepDisp.Out(sdiTwo, 0)
  stepDisp.Out(sdiZero, 1)
  
  myTermStrNL(String("************************* Start New frame"))
  myTermStrNL(String("Reading Frame Data"))
  
  repeat
    tLong := \frameReadLong
    if(curItem > 1)
      term.str(string("Next Item:"))
      term.Hex(tLong, 8)
      myTermStrNL(String(" "))
    
    if(tLong == frameFieldDelimiter)
      myTermStrNL(String("Found Field Delimiter"))
      term.Str(String("Frame Length:"))
      term.dec(ctrPixel)
      myTermStrNL(String(" "))
      if(curItem == 1)        ' Expecting Last Section to be Pixel Data
        framePauseTimer := \frameReadLong
        mytermStrNL(String("Reading Pause Time"))
        term.Str(String("Pause Time Dec:"))
        term.Dec(framePauseTimer)
        term.Str(String(" Hex:"))
        term.Hex(framePauseTimer, 8)
        mytermStrNL(String(" "))
        curItem := 10
    elseif(tLong == frameRecordDelimiter)
      myTermStrNL(String("Found Record Delimiter"))
      quit
    elseif(endOfFrameFile)
      myTermStrNL(String("End Of file"))
      return 
    else
      if(ctrPixel < rgbwStripLength)
        frameBuff2[ctrPixel] := tLong
        ctrPixel++
  
  myTermStrNL(String("Done Reading Frame Data"))

  if(framePauseTimer == 0)
    myTermStrNL(String("Pause Data Missing"))
    myTermStrNL(String("Setting to 10 Seconds"))
    framePauseTimer := 10000

  if(framePauseTimer < 0)
    myTermStrNL(String("Pause Data Less Than 0 Seconds"))
    myTermStrNL(String("Setting to 10 Seconds"))
    framePauseTimer := 10000

  if(framePauseTimer > 100000)
    myTermStrNL(String("Pause Data To Big"))
    myTermStrNL(String("Setting to 10 Seconds"))
    framePauseTimer := 10000

  if(ctrPixel < rgbwStripLength)
    myTermStrNL(String("Pixel Data Short"))
    term.str(String("Strip Length:"))
    myTermDecNL(ctrPixel)

  longmove(@frameBuff1, @frameBuff2, rgbwStripLength)
  myTermStrNL(String("Frame Sent"))
    
  stepDisp.Out(sdiTwo, 0)
  stepDisp.Out(sdiNine, 1)
  
  return
  
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
pub framePause
  term.Str(String("Lets Pasue for: "))
  term.Dec(framePauseTimer)
  myTermStrNL(String(" ms"))
  time.pause(framePauseTimer)
  myTermStrNL(String("Done Pausing"))
  
'****************************************************************
'
'
'

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

'********************************************************************
'
'
pub read_configuration | check

  ifnot (has_file(@CfgFile))
    myTermStrNL(string("Error: Cannot open STARTUP.TXT"))
    return false

  myTermStrNL(string("Opened STARTUP.TXT"))
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
  
  TOKEN_LIST            byte    "STARTUPTYPE", 0                 ' STARTUPTYPE string
                        byte    "FRAMEFILE", 0                   ' FILENAME string
                        byte    "FRAMESFILE", 0                  ' FILENAME string
                        byte    "OPTION", 0                      ' OPTION # value
                        byte    "REPEATMODE", 0                  ' REPEATMODE # value
                        byte    "TURNOFFATEND", 0                ' TURNOFFATEND # value

                        
con { enumerated token indexes }

  #0, T_STARTUPTYPE, T_FRAMEFILE, T_FRAMESFILE, T_OPTION, T_REPEATMODE, T_TURNOFFATEND, TOKEN_COUNT 
  

pub process_cmd | tidx

  tidx := parser.get_token_id(parser.token_addr(0))              ' get index of command token
     
  case tidx
    T_STARTUPTYPE  : cmd_startuptype
    T_FRAMEFILE    : cmd_framefile
    T_FRAMESFILE   : cmd_framesfile
    T_OPTION       : cmd_option
    T_REPEATMODE   : cmd_repeatmode
    T_TURNOFFATEND : cmd_turnoffatend
'********************************************************************    
pub cmd_startuptype | tc, p_name
  
  tc := parser.token_count
  if (tc <> 2)                                                  
    return

  p_name := parser.token_addr(1)                             
  bytefill(@startUpType, 0, 10)                                 
  bytemove(@startUpType, p_name, strsize(p_name) <# 9)          
'********************************************************************
pub cmd_repeatmode | tc, p_name
  
  tc := parser.token_count
  if (tc <> 2)                                                  
    return
  p_name := parser.token_addr(1)                                
  bytemove(@repeatMode, p_name, strsize(p_name) <# 1)
  '********************************************************************
pub cmd_turnoffatend | tc, p_name
  
  tc := parser.token_count
  if (tc <> 2)                                                  
    return
  p_name := parser.token_addr(1)                                
  bytemove(@turnoffatend, p_name, strsize(p_name) <# 1)   
'********************************************************************                                          
pub cmd_framefile | tc, p_name
  
  tc := parser.token_count
  if (tc <> 2)                                                  ' syntax = FILENAME string
    return

  p_name := parser.token_addr(1)                                ' get address of name
  bytefill(@framefile, 0, 13)                                    ' reset
  bytemove(@framefile, p_name, strsize(p_name) <# 12)            ' copy token to filename - 12 chars max  
'********************************************************************
pub cmd_framesfile | tc, idx, value, p_name

  tc := parser.token_count
  if (tc <> 3)                                                  ' syntax = FRAMESFILE # string
    return

  idx := parser.token_value(1)

  if ((idx < 0) or (idx > 9))                                   ' valid option # 
    return
    
'framesfiles[13*framesfilesNum]
  p_name := parser.token_addr(2)
'  term.str(string("token :"))
'  myTermStrNL(p_name)
'  term.str(string("Length:"))
'  myTermDecNL(strsize(p_name))
'  term.str(string("Index :"))
'  myTermDecNL(idx)
'  term.str(string("Before:"))
'  term.dec(strsize(@framesfiles))
'  term.str(string(" "))
'  myTermStrNL(@framesfiles)
  framesFilesSize[idx] := strsize(p_name)
  idx := idx*13
  bytefill(@framesfiles[idx], string(" "), 13)
  bytemove(@framesfiles[idx], p_name, strsize(p_name) <# 12)
'  term.str(string("After :"))
'  term.dec(strsize(@framesfiles))
'  term.str(string(" "))
'  myTermStrNL(@framesfiles)
'  myTermStrNL(string("***"))
'********************************************************************  
pub cmd_option | tc, idx, value

  tc := parser.token_count
  if (tc <> 3)                                                  ' syntax = OPTION # byte_value
    return

  idx := parser.token_value(1)

  if ((idx < 0) or (idx > 2))                                   ' valid option # 
    return

  option[idx] := 0 #> parser.token_value(2) <# 255              ' set option


'********************************************************************  
pub myTermStrNL(iString)

  term.str(iString)
  term.tx(13)
  term.tx(10)
'********************************************************************  
pub myTermDecNL(iDec)

  term.dec(iDec)
  term.tx(13)
  term.tx(10)
