'' =================================================================================================
''
''   File....... jm_strings.spin
''   Purpose.... Miscellaneous string methods
''   Author..... Jon "JonnyMac" McPhalen
''               Copyright (C) 2011-2016 Jon McPhalen
''               -- see below for terms of use
''   E-mail.....
''   Started....
''   Updated.... 25 AUG 2016
''
'' =================================================================================================


pub null

  ' This is not a top-level object


pub ucstr(p_str)

'' Converts z-string at p_str to upper case

  repeat strsize(p_str)
    byte[p_str] := upper(byte[p_str])
    p_str++


pub upper(c)

'' Convert c to uppercase
'' -- does not modify non-alphas

  if ((c => "a") and (c =< "z"))
    c -= 32

  return c


pub to_upper(p_char)

'' Convert character at p_char to uppercase

  byte[p_char] := upper(byte[p_char])


pub lcstr(p_str)

'' Converts z-string at p_str to lower case

  repeat strsize(p_str)
    byte[p_str] := lower(byte[p_str])
    p_str++


pub lower(c)

'' Convert c to lowercase
'' -- does not modify non-alphas

  if ((c => "A") and (c =< "Z"))
    c += 32

  return c


pub to_lower(p_char)

'' Convert character at p_char to lowercase

  byte[p_char] := lower(byte[p_char])


pub is_alpha(c)

'' Returns true if c is alpha character

  if ((c => "a") and (c =< "z"))
    return true
  elseif ((c => "A") and (c =< "Z"))
    return true
  else
    return false


pub is_digit(c)

'' Returns true if c is digit character

  if ((c => "0") and (c =< "9"))
    return true
  else
    return false


pub is_alphanum(c)

'' Returns true if c is alpha/numeric character

  return (is_alpha(c) or is_digit(c))


pub is_space(c)

'' Returns true if c a standard whitespace character

  return (lookdown(c : $20, $09, $0A, $0B, $0C, $0D) > 0)


pub is_decimal(p_str) | c

'' Returns true if string is decimal format
'' -- separator okay

  repeat strsize(p_str)
    c := byte[p_str++]
    ifnot (is_digit(c))
      ifnot ((c == "_") or (c == "."))
        return false

  return true


pub is_binary(p_str) | c

'' Returns true if string is binary format
'' -- excludes format indicator (%)
'' -- separator okay

  if (byte[p_str] == "%")                                       ' skip format indicator
    ++p_str

  repeat strsize(p_str)
    c := byte[p_str++]
    ifnot ((c => "0") and (c =< "1"))
      ifnot (c == "_")
        return false

  return true


pub is_hex(p_str) | c

'' Returns true if string is hexadecimal format
'' -- excludes format indicator ($)
'' -- separator okay

  if (byte[p_str] == "$")                                       ' skip format indicator
    ++p_str

  repeat strsize(p_str)
    c := upper(byte[p_str++])
    ifnot (is_digit(c))
      ifnot ((c => "A") and (c =< "F"))
        ifnot (c == "_")
          return false

  return true


pub is_number(p_str)

'' Returns true if string is number in known format (dec, bin, or hex)
'' -- binary and hex must be indicated

  if (is_binary(p_str))
    return true

  if (is_hex(p_str))
    return true                                  
                                                                 
  if lookdown(byte[p_str] : "+-", "0".."9")                     ' sign or digit?
    return is_decimal(p_str+1)                                   

  return false


pub nc_strcomp(p_str1, p_str2)

'' Case-insensitve comparison of two strings
'' -- for case-sensitivity use strcmp()

  if (strsize(p_str1) <> strsize(p_str2))
    return false 

  repeat strsize(p_str1)
    if (upper(byte[p_str1++]) <> upper(byte[p_str2++]))
      return false 
                                                      
  return true


pub strncmp(p_str1, p_str2, n) | match

'' Compares n characters of str2 with str1
'' -- p_str1 and p_str2 are pointers to strings (byte arrays)
'' -- 0 if str1 == str2, 1 if str1 > str2, -1 if str1 < str2

  match := 0

  if (n > 0)
    repeat n
      if (byte[p_str1] > byte[p_str2])
        ++match
        quit
      elseif (byte[p_str1] < byte[p_str2])
        --match
        quit
      else
        ++p_str1
        ++p_str2

  return match


pub instr(p_str1, p_str2) | len1, len2, pos, idx

'' Returns position of str2 in str1
'' -- p_str1 is pointer to z-string to search
'' -- p_str2 is pointer to z-string to look for in str1
'' -- if str2 not in str1 returns -1

  len1 := strsize(p_str1)
  len2 := strsize(p_str2)
  pos  := -1
  idx  := 0

  if (len1 >= len2)
    repeat (len1 - len2 + 1)
      if (byte[p_str1] == 0)
        quit
      else
        if (strncmp(p_str1++, p_str2, len2) == 0)
          pos := idx
          quit
        else
          ++idx

  return pos


pub first(c, p_str) | pos                                       ' changed from cinstr(p_str, c)
                                                                 
'' Returns first position of character c in string at p_str      
'' -- returns -1 if not found                                    
                                                                 
  pos := 0                                                       
                                                                 
  repeat strsize(p_str)                                         ' loop through string chars
    if (byte[p_str][pos] == c)                                  ' if match
      return pos                                                ' return position
    ++pos                                                        
                                                                 
  return -1                                                     ' return not found
                                                                 
                                                                 
pub last(c, p_str) | pos                                         
                                                                 
'' Returns last position of character c in string at p_str       
'' -- returns -1 if not found                                    
                                                                 
  pos := strsize(p_str)                                          
                                                                 
  repeat strsize(p_str)                                         ' loop through string chars
    if (byte[p_str][pos] == c)                                  ' if match
      return pos                                                ' return position
    pos -= 1                                                     
                                                                 
  return -1                                                     ' return not found


pub chcount(c, p_str) | n

'' Returns count of times character c appears in p_str

  n := 0
  repeat strsize(p_str)
    if (byte[p_str++] == c)
      ++n

  return n   
    
  
pub fields(p_str, sepchar) | len, fc

'' Returns number of fields in string
'' -- fields are separated by sepchar

  len := strsize(p_str)                                         ' get length of string
  if (len == 0)                                                 ' if no length
    fc := 0                                                     ' no fields
  else                                                           
    fc := 1                                                     ' at least 1 for any valid string
    repeat len                                                  ' iterate through string
      if (byte[p_str++] == sepchar)                             ' if separator found
        ++fc                                                    '  increment field count

  return fc
  
  
pub field_pntr(p_str, n, sepchar) | c

'' Returns pointer to field following nth appearance of sepchar
'' -- p_str is pointer to source string
'' -- n is the field number
'' -- sepchar is the field seperating character

  repeat while (n > 0)
    c := byte[p_str++]
    if (c == sepchar)
      n -= 1
    elseif (c == 0)                                             ' end of string
      return -1                                                 ' report sepchar not found
                                                                 
  return p_str


pub copy_field(p_dest, p_src, sepchar, cmax) | c

'' Copies field starting at p_src to p_dest
'' -- stops at sepchar or 0
'' -- cmax is maximum length of string

  repeat cmax
    c := byte[p_src++]                                          ' get character from source
    if (c == sepchar)                                           ' if separator
      c := 0                                                    '  convert to 0
    byte[p_dest++] := c                                         ' update destination
    if (c == 0)                                                  
      quit                                                       
                                                                 
  if (c <> 0)                                                   ' if field too long
    byte[p_dest] := 0                                           '  truncate


pub replace(tc, nc, p_str)                                      

'' Replaces target character (tc) in string at p_str witn new character (nc)

  repeat strsize(p_str)
    if (byte[p_str] == tc)
      byte[p_str] := nc
    ++p_str


pub get_char(p_str, n)

'' Returns nth character from str at p_str

  if (n < strsize(p_str))
    return byte[p_str][n]
  else
    return 0


pub append_char(p_str, c) | pos

'' Append c to the end of p_str

  p_str += strsize(p_str)
  byte[p_str++] := c
  byte[p_str] := 0


pub append_str(p_dest, p_src) | pos

'' Append p_src to the end of p_dest

  p_dest += strsize(p_dest)
  bytemove(p_dest, p_src, strsize(p_src)+1)
      

pub left(p_dest, p_src, n)

'' Copies left n characters from src string to dest string
'' -- p_dest and p_src are pointers to string buffers

  n <#= strsize(p_src)
  bytemove(p_dest, p_src, n)
  byte[p_dest][n] := 0                                          ' terminate new p_dest


pub right(p_dest, p_src, n) | sl

'' Copies right n characters from src string to dest string
'' -- p_dest and p_src are pointers to string buffers

  sl := strsize(p_src)                                          ' length of source
  bytemove(p_dest, p_src+(sl-n), n+1)                           ' include terminating 0


pub mid(p_dest, p_src, start, n)

'' Copies middle n characters from src string to dest string
'' -- p_dest and p_src are pointers to string buffers
'' -- start is zero indexed

  p_src += start                                                ' bump start address
  n <#= strsize(p_src)                                          ' keep size legal

  bytemove(p_dest, p_src, n)
  byte[p_dest][n] := 0                                          ' terminate updated dest string


pub ltrim(p_str) : idx

'' Trims leading whitespace(s) from string at p_str

  repeat
    ifnot (is_space(byte[p_str][idx]))
      quit
    else
      ++idx

  if (idx > 0)                                                  ' if spaces
    bytemove(p_str, p_str+idx, strsize(p_str)-idx+1)            '  move sub-string + 0 left
                                                                 
                                                                 
pub rtrim(p_str) | idx, end                                      
                                                                 
'' Trims trailing whitespaces from string at p_str               
                                                                 
  idx := end := strsize(p_str) - 1                              ' get index of last char in string
                                                                 
  repeat                                                         
    ifnot (is_space(byte[p_str][idx]))                           
      quit                                                       
    else                                                         
      --idx                                                      
                                                                 
  if (idx < end)                                                ' if spaces at end
    byte[p_str][idx+1] := 0                                     '  truncate
                                                                 
                                                                 
pub trim(p_str)                                                  
                                                                 
'' Trims leading and trailing spaces from string at p_str        
                                                                 
  rtrim(p_str)                                                   
  ltrim(p_str)                                                   
                                                                 

pub concat(p_str1, p_str2, p_buf) 

'' Concatenates strings; result to p_buf
'' -- p_buf must be large enough to accomodate result string

  if (p_str1 <> p_buf)                                          ' if not using p_str1 for result
    bytemove(p_buf, p_str1, strsize(p_str1))

  bytemove(p_buf+strsize(p_str1), p_str2, strsize(p_str2)+1)   


pub str_index(p_str, p_list, lcount) | idx

'' Returns index of string (at p_str) in list of strings (at p_list)
'' -- lcount is number of strings in list
'' -- search is case sensitive

  idx := 0

  repeat lcount
    if (strcomp(p_str, p_list))
      return idx
    else
      ++idx
      p_list += strsize(p_list) + 1

  return -1


pub nc_str_index(p_str, p_list, lcount) | idx

'' Returns index of string (at p_str) in list of strings (at p_list)
'' -- lcount is number of strings in list
'' -- search is NOT case sensitive

  idx := 0

  repeat lcount
    if (nc_strcomp(p_str, p_list))
      return idx
    else
      ++idx
      p_list += strsize(p_list) + 1

  return -1  
                                                             
                                                                 
pub str_pntr(idx, p_list)                                        
                                                                 
'' Returns to pointer to idx'th string in list (at p_list)       
'' -- string may be variable length                              
                                                                 
  repeat idx                                                     
    p_list += strsize(p_list) + 1                               ' skip current string
                                                                 
  return p_list                                                  
                                                                 
                                                                 
con                                                              

  { --------------------- }
  {  Numeric conversions  }
  { --------------------- }


pub asc2val(p_str) | c

'' Returns value of numeric string
'' -- p_str is pointer to string
'' -- binary (%) and hex ($) must be indicated

  repeat
    c := byte[p_str]
    case c
      " ":                                                      ' skip leading space(s)
        p_str++                                                  
                                                                 
      "+", "-", ".", "0".."9":                                  ' found decimal value
        return asc2dec(p_str, 11)                                
                                                                 
      "%":                                                      ' found binary value
        return bin2dec(p_str, 32)                                
                                                                 
      "$":                                                      ' found hex value
        return hex2dec(p_str, 8)                                 
                                                                 
      other:                                                    ' abort on bad character
        return 0


pub asc2dec(p_str, n) | c, value, sign

'' Returns signed value from decimal string
'' -- p_str is pointer to valid decimal string
'' -- n is maximum number of digits to process
'' -- decimal point is ignored
''    * application should note position of dpoint for appropriat scaling

  if (n < 1)                                                    ' if bogus, bail out
    return 0                                                     
                                                                 
  value := 0                                                    ' initialize value
  sign := 1                                                     ' assume positive
                                                                 
  ' trim leading chars (spaces / sign)                           
                                                                 
  repeat                                                         
    c := byte[p_str]                                             
    case c                                                       
      " ":                                                      ' skip leading space(s)
        p_str++                                                  
                                                                 
      "0".."9":                                                 ' found #s, extract value
        quit                                                     
                                                                 
      "+", "_", ".":                                             
        p_str++                                                 ' skip sign, extract value
        quit                                                     
                                                                 
      "-":                                                       
        sign := -1                                              ' value is negative
        p_str++                                                 ' skip sign, extract value
        quit                                                     
                                                                 
      other:                                                    ' abort on bad character
        return 0                                                 
                                                                 
  ' extract numeric character                                    
  ' -- can contain comma and underscore separators               
                                                                 
  n <#= 10                                                      ' limit to 10 digits
                                                                 
  repeat while (n > 0)                                           
    c := byte[p_str++]                                           
    case c                                                       
      "0".."9":                                                 ' digit?
        value := (value * 10) + (c - "0")                       '  update value
        n--                                                      
                                                                 
      "_", ".":                                                  
        { ignore }                                               
                                                                 
      other:                                                     
        quit                                                     
                                                                 
  return sign * value


pub bin2dec(p_str, n) | c, value

'' Returns value from {indicated} binary string
'' -- p_str is pointer to binary string
'' -- n is maximum number of digits to process

  if (n < 1)                                                    ' if bogus, bail out
    return 0                                                     
                                                                 
  repeat                                                         
    c := byte[p_str]                                             
    case c                                                       
      " ":                                                      ' skip leading space(s)
        p_str++                                                  
                                                                 
      "%":                                                      ' found indicator
        p_str++                                                 '  move to value
        quit                                                     
                                                                 
      "0".."1":                                                 ' found value
        quit                                                     
                                                                 
      other:                                                    ' abort on bad character
        return 0                                                 
                                                                 
  value := 0                                                     
                                                                 
  n <#= 32                                                      ' limit chars in value
                                                                 
  repeat while (n)                                               
    c := byte[p_str++]                                          ' get next character
    case c                                                       
      "0".."1":                                                 ' binary digit?
        value := (value << 1) | (c - "0")                       '  update value
        --n                                                     '  dec digits count
                                                                 
      "_":
        ' skip

      other:
        quit

  return value


pub hex2dec(p_str, n) | c, value

'' Returns value from {indicated} hex string
'' -- p_str is pointer to binary string
'' -- n is maximum number of digits to process

  if (n < 1)                                                    ' if bogus, bail out
    return 0                                                     
                                                                 
  repeat                                                         
    c := upper(byte[p_str])                                      
    case c                                                       
      " ":                                                      ' skip leading space(s)
        p_str++                                                  
                                                                 
      "$":                                                      ' found indicator
        p_str++                                                 '  move to value
        quit                                                     
                                                                 
      "0".."9", "A".."F":                                       ' found value
        quit                                                     
                                                                 
      other:                                                    ' abort on bad character
        return 0                                                 
                                                                 
  value := 0                                                     
                                                                 
  n <#= 8                                                       ' limit field width
                                                                 
  repeat while (n)                                               
    c := upper(byte[p_str++])                                    
    case c                                                       
      "0".."9":                                                 ' digit?
        value := (value << 4) | (c - "0")                       '  update value
        --n                                                     '  dec digits count
                                                                 
      "A".."F":                                                 ' hex digit?
        value := (value << 4) | (c - "A" + 10)                   
        --n                                                      
                                                                 
      "_":                                                       
        { skip }                                                 
                                                                 
      other:                                                     
        quit                                                     
                                                                 
  return value                                                   


con

  { -------------------- }
  {  String conversions  }
  { -------------------- }


pub val2dec(value, p_dest) | divisor, x  

'' Converts value to decimal formatted string
'' -- p_str is pointer to destination buffer
'' -- string is terminated

  x := (value == negx)                               
  if (value < 0)                                     
    value := ||(value+x)                             
    byte[p_dest++] := "-"                                          
                                                     
  divisor := 1_000_000_000                           
                                                     
  repeat 10                                          
    if (value => divisor)                            
      byte[p_dest++] := "0" + value / divisor + x*(divisor == 1)    
      value //= divisor                              
      result~~                                       
    elseif (result or (divisor == 1))                
      byte[p_dest++] := "0"                                         
    divisor /= 10

  byte[p_dest] := 0
    

pub val2bin(value, digits, p_dest)

'' Converts value to binary formatted string
'' -- p_dest is pointer to destination buffer
'' -- does not add indicator (%)
'' -- string is terminated

  value <<= 32 - digits
  repeat digits
    byte[p_dest++] := "0" + ((value <-= 1) & 1)

  byte[p_dest] := 0
  

pub val2hex(value, digits, p_dest)

'' Converts value to hex formatted string
'' -- p_dest is pointer to destination buffer
'' -- does not add indicator ($)
'' -- string is terminated

  value <<= (8 - digits) << 2
  repeat digits
    byte[p_dest++] := lookupz((value <-= 4) & $F : "0".."9", "A".."F")

  byte[p_dest] := 0 


dat { license }

{{

  Copyright (C) 2011-2016 Jon McPhalen   

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