'' =================================================================================================
''
''   File....... jm_pwm595x2.spin
''   Purpose.... PWM modulation for 595 x 2 circuits
''   Author..... Jon "JonnyMac" McPhalen 
''               Copyright (c) 2011-13 Jon McPhalen
''               -- see below for terms of use
''   E-mail..... jon@jonmcphalen.com
''   Started.... 
''   Updated.... 17 JUN 2013
''
'' =================================================================================================


var

  long  cog

  long  pinz
  long  p_brightness
  
  byte  brightness[16]
 
    
pub start(dpin, cpin, lpin) 

'' Starts 595x2 PWM driver
'' -- dpin, cpin, lpin for x595s

  stop

  pinz := dpin | (cpin << 8) | (lpin << 16)                     ' pack pins

  p_brightness := @brightness                                   ' point to brightness array

  cog := cognew(@entry, @pinz) + 1                              ' start the cog

  return cog


pub stop

'' Stops cog (if running)

  if (cog)
    cogstop(cog - 1)
    cog := 0 
  
  set_all(0)


pub set(ch, level)

'' Sets channel to specified level

  if ((ch => 0) & (ch =< 15))
    brightness[ch] := 0 #> level <# 255

  return brightness[ch]
    

pub set_all(level)

'' Set all channels to same level

  level := 0 #> level <#255                                     ' limit to byte value
  bytefill(@brightness[0], level, 16)

  return level

  
pub inc(ch)

'' Increment channel brightness

  if ((ch => 0) & (ch =< 15))
    if (brightness[ch] < 255)
      ++brightness[ch]

  return brightness[ch]


pub dec(ch)

'' Decrement channel brightness

  if ((ch => 0) & (ch =< 15))
    if (brightness[ch] > 0)
      --brightness[ch]

  return brightness[ch]
      

pub high(ch)

'' Sets channel on

  if ((ch => 0) & (ch =< 15))
    brightness[ch] := 255


pub low(ch)

'' Sets channel off

  if ((ch => 0) & (ch =< 15))
    brightness[ch] := 0


pub toggle(ch)

'' Toggles channel
'' -- threshold for analog value is 50%

  if ((ch => 0) & (ch =< 15))
    if (brightness[ch] < 128)
      high(ch)
    else
      low(ch)    

  
pub ez_log(level)

'' Creates log-like curve for LEDs
'' -- improves apparent linearity of brightness

  level := 0 #> level <#255                                     ' limit to byte value
  
  return (level * level) >> 8                                   ' level := (level^2) / 256


pub read(ch)

'' Returns channel brightness

  if ((ch => 0) & (ch =< 15))
    return brightness[ch]
  else
    return -1


pub address

'' Returns hub address of brightness array

  return @brightness


dat

                        org     0

entry                   mov     outa, #0                        ' all off
                        mov     dira, #0
                        
                        mov     t1, par                         ' start of parameters
                        rdlong  t2, t1                          ' read pins
                        
                        mov     t3, t2                          ' copy
                        and     t3, #$1F                        ' extract dat pin
                        mov     odatmask, #1                    ' convert to mask
                        shl     odatmask, t3
                        or      dira, odatmask                  ' set to output
                        
                        mov     t3, t2 
                        shr     t3, #8                          ' remove dat
                        and     t3, #$1F                        ' extract clk pin   
                        mov     oclkmask, #1
                        shl     oclkmask, t3
                        or      dira, oclkmask
                        
                        mov     t3, t2
                        shr     t3, #16                         ' remove dat & clk
                        and     t3, #$1F                        ' extract latch pin   
                        mov     olatchmask, #1
                        shl     olatchmask, t3
                        or      dira, olatchmask

                        add     t1, #4 
                        rdlong  hubaddr, t1                     ' read hub address of brightness[0]

                        mov     cycle, #0
                        
                        
pwmmain                 mov     hub, hubaddr                    ' point to brightness array
                        mov     chcount, #16                    ' read 16 channels
                        mov     outbits, #0                     ' reset working outputs
                        mov     chmask, #1                      ' starting mask 

:loop                   rdbyte  t1, hub                 wz      ' get channel value, save 0
        if_z            jmp     #:next                          ' skip if zero
                        cmp     cycle, t1               wc, wz  ' check level
        if_be           or      outbits, chmask                 ' on if not done
        if_a            andn    outbits, chmask                 ' else kill output                   

:next                   add     hub, #1                         ' next value
                        shl     chmask, #1
                        djnz    chcount, #:loop

                        
out16                   mov     bitcount, #16                   ' shift out 16 bits
                        shl     outbits, #(32-16)               ' prep for msb first

:loop                   shl     outbits, #1             wc      ' get msb
                        muxc    outa, odatmask                  ' output the bit
                        nop                                     ' let bit settle
                        or      outa, oclkmask                  ' clock the bit
                        nop
                        andn    outa, oclkmask
                        djnz    bitcount, #:loop
                        or      outa, olatchmask                ' latch the outputs
                        nop
                        andn    outa, olatchmask

                        add     cycle, #1                       ' next cycle value
                        and     cycle, #$FF             wz      ' keep 0 to 255

                        jmp     #pwmmain 

' --------------------------------------------------------------------------------------------------

odatmask                res     1                               ' pin mask for dat
oclkmask                res     1                               ' pin mask for clk
olatchmask              res     1                               ' pin mask for latch
hubaddr                 res     1                               ' hub address of brightness array

hub                     res     1
cycle                   res     1
chcount                 res     1
outbits                 res     1                               ' bits to shift out
chmask                  res     1
bitcount                res     1                               ' bit count

t1                      res     1                               ' work vars
t2                      res     1
t3                      res     1

                        fit     496                                    

                        
dat

{{

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