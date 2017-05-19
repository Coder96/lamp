'' =================================================================================================
''
''   File....... jm_rgbx_pixel_demo.spin
''   Purpose.... Smart pixel control demo
''   Author..... Jon "JonnyMac" McPhalen
''               Copyright (c) 2014-2017 Jon McPhalen
''               -- see below for terms of use
''   E-mail..... jon@jonmcphalen.com
''   Started.... 
''   Updated.... 16 JAN 2017
''
'' =================================================================================================


con { timing }

  _clkmode = xtal1 + pll16x                                     
  _xinfreq = 5_000_000                                          ' use 5MHz crystal

  CLK_FREQ = (_clkmode >> 6) * _xinfreq                         ' system freq as a constant
  MS_001   = CLK_FREQ / 1_000                                   ' ticks in 1ms
  US_001   = CLK_FREQ / 1_000_000                               ' ticks in 1us
  

  TRM_BAUD = 115_200                                            ' for terminal

  
con { io pins }

  RX1  = 31                                                     ' programming / terminal
  TX1  = 30
  
  SDA  = 29                                                     ' eeprom / i2c
  SCL  = 28

  LEDS =  5                                                     ' LED signal pin


con

  STRIP_LEN = 24                                                ' Adafruit 24-pixel ring
  PIX_BITS  = 24
  

obj

' main                                                          ' * master Spin cog
  time  : "jm_time_80"                                          '   timing and delays
  io    : "jm_io_basic"                                         '   essential io
  strip : "jm_rgbx_pixel"                                       ' * Smart pixel driver
  term  : "jm_fullduplexserial"                                 ' * serial IO for terminal
                                                             
' * uses cog when loaded                                         
                                                                 

var

  long  pixbuf1[STRIP_LEN]                                      ' pixel buffers
  long  pixbuf2[STRIP_LEN]
  long  pixbuf3[STRIP_LEN]


dat

  Chakras       long    strip#RED, strip#ORANGE, strip#YELLOW 
                long    strip#GREEN, strip#BLUE, strip#INDIGO


pub main | p_pixels, pos, ch  

  setup

  longfill(@pixbuf1, $10_00_00_00, STRIP_LEN)                   ' prefill buffers
  longfill(@pixbuf2, $00_10_00_00, STRIP_LEN)
  longfill(@pixbuf3, $00_00_10_00, STRIP_LEN)

  repeat 3                                                      ' demonstrate buffer switching
    strip.use(@pixbuf1, STRIP_LEN, LEDS, PIX_BITS)
    repeat until strip.connected
    time.pause(500)
    strip.use(@pixbuf2, STRIP_LEN, LEDS, PIX_BITS) 
    time.pause(500)    
    strip.use(@pixbuf3, STRIP_LEN, LEDS, PIX_BITS) 
    time.pause(500)
                       
  repeat 3
    p_pixels := @pixbuf1                                        ' use pixbuf1
    repeat (STRIP_LEN * 2) + 1                                  ' change pointer to scroll next array
      strip.use(p_pixels, STRIP_LEN, LEDS, PIX_BITS)
      time.pause(50)
      p_pixels += 4 

  repeat 
    repeat 3
      color_wipe($10_00_00_00, 500/STRIP_LEN)
      color_wipe($00_10_00_00, 500/STRIP_LEN)      
      color_wipe($00_00_10_00, 500/STRIP_LEN)     
     
    repeat 3
      repeat pos from 0 to 255
        strip.set_all(strip.wheelx(pos, $10))
        time.pause(20)

    repeat 3
      repeat pos from 0 to 255
        repeat ch from 0 to STRIP_LEN-1
          strip.set(ch, strip.wheelx(256 / STRIP_LEN * ch + pos, $10))   
        time.pause(4)

    strip.clear
    strip.fill( 0,  7, $10_00_00_00)
    strip.fill( 8, 15, $00_10_00_00)
    strip.fill(16, 23, $00_00_10_00)
    time.pause(2000)
    strip.clear
    time.pause(250)


pub color_chase(p_colors, len, ms) | base, idx, ch

'' Performs color chase 

  repeat base from 0 to len-1                                   ' do all colors in table
    idx := base                                                 ' start at base
    repeat ch from 0 to strip.num_pixels-1                      ' loop through connected leds
      strip.set(ch, long[p_colors][idx])                        ' update channel color 
      if (++idx == len)                                         ' past end of list?
        idx := 0                                                ' yes, reset
   
    time.pause(ms)                                              ' set movement speed


pub setup                                                        
                                                                 
'' Setup IO and objects for application                          
                                                                 
  time.start                                                    ' setup timing & delays
                                                                 
  io.start(0, 0)                                                ' clear all pins (master cog)

  strip.start_2812b(@pixbuf1, STRIP_LEN, LEDS, 1_0)             ' use WS2812b pixel timing
                                                           
  term.start(RX1, TX1, %0000, TRM_BAUD)                         ' start serial for terminal

  
con

  ' Routines ported from C code by Phil Burgess (www.paintyourdragon.com)


pub color_wipe(rgb, ms) | ch

'' Sequentially fills strip with color rgb
'' -- ms is delay between pixels, in milliseconds

  repeat ch from 0 to strip.num_pixels-1 
    strip.set(ch, rgb)
    time.pause(ms)


pub rainbow(ms) | pos, ch

  repeat pos from 0 to 255
    repeat ch from 0 to strip.num_pixels-1
      strip.set(ch, strip.wheel((pos + ch) & $FF))
    time.pause(ms)
    

pub rainbow_cycle(cycles, ms) | pos, ch 

  repeat pos from 0 to 255
    repeat ch from 0 to strip.num_pixels-1
      strip.set(ch, strip.wheel(((ch * 256 / strip.num_pixels) + pos) & $FF))
    time.pause(ms)
    

dat { license }

{{

  Copyright (c) 2014-2017 Jon McPhalen  

  Terms of Use: MIT License

  Permission is hereby granted, free of charge, to any person obtaining a copy of this
  software and associated documentation files (the "Software"), to deal in the Software
  without restriction, including without limitation the rights to use, copy, modify,
  merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to the following
  conditions:

  The above copyright notice and this permission notice shall be included in all copies
  or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
  PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

}}