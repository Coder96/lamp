con { timing }

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000                                          ' use 5MHz crystal

  CLK_FREQ = (_clkmode >> 6) * _xinfreq                         ' system freq as a constant
  MS_001   = CLK_FREQ / 1_000                                   ' ticks in 1ms
  US_001   = CLK_FREQ / 1_000_000                               ' ticks in 1us


con { io pins }

  RX1  = 31                                                     ' programming / terminal
  TX1  = 30

  SDA  = 29                                                     ' eeprom / i2c
  SCL  = 28

  LEDS =  20                                                     ' LED strip


con

  STRIP_LEN = 288


obj

' main                                                          ' * master Spin cog
  time  : "jm_time_80"                                             '   timing and delays
  strip : "jm_rgbx_pixel"                                       ' * unified pixel driver

var

  long  pixels1[STRIP_LEN]


pub main

  setup

  longfill(@pixels1, $00_20_00_00, STRIP_LEN)                   ' dim green

  repeat
    waitcnt(0)



pub setup

'' Setup IO and objects for application

  time.start                                                    ' setup timing & delays

  strip.start_6812x(@pixels1, STRIP_LEN, LEDS, 1_0, 32)         ' for SK6812RGBW pixels