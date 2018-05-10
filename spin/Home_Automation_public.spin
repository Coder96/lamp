CON

  _CLKMODE  = XTAL1 + PLL16X      
  _XINFREQ  = 5_000_000

'-----ADC (MCP3208)---------------

  DPin      = 13                'data in and out (tied together)          
  CPin      = 14                'clock 
  SPin      = 12                'chip select
           
'----Serial To Parallel (74HC595)-----

  SR_CLOCK = 5                  'Clock Pin
  SR_LATCH = 4                  'Latch Pin
  SR_DATA  = 3                  'Data Pin

'----Relays (single relay board 27115)------

  RelayFoyer = 16               'Pin connected to Relay 1 (Foyer Light)
  RelayPorch = 15               'Pin connected to Relay 2 (Porch Light)

'----Buttons/On-Off Switchs-------

  ButtonFoyer = 6               'Pin connected to Switch/Button 1 (Foyer Light)
  ButtonPorch = 7               'Pin connected to Switch/Button 2 (Porch Light) 

'----Phototransistor RCTIME Circuit------

  RCPIN    = 1                 'Pin going to RCtime Circuit 
  RCSTATE  = 1                 'the state to use (see RCTIME documentation)
  Capacity = 1.1e-6            '1.1 µF  -  substitute the value of your capacitor
  trigger  = 60000.0

'----Xbee Module (S2 Pro)------

  XbeeDout = 11                'Digital output pin of XBee Module
  XbeeDin  = 8                 'Digital input pin of Xbee Module
  XbeeMode = 0                 'Sets the mode per the XBee Object
  XbeeBaud = 9600              'Transmit baud rate setting per the XBee Object
     
 {
    Output a character

     $00 = clear screen
     $01 = home
     $08 = backspace
     $09 = tab (8 spaces per)
     $0A = set X position (X follows)
     $0B = set Y position (Y follows)
     $0C = set color (color follows)
     $0D = return
    }
OBJ


'------Circuit Hardware-----------

  ADC    : "MCP3208"                'This ADC is connected to LM34 Temprature sensor.
  shift  : "Simple_74HC595"         'Serial to Parallel output for 7 Segment LEDS.
  RC     : "RCTIME Plus"            'Phototransistor connect to RCTIME circuit, object gets data from the circit.

'------Floating Point Math Objects------

  Math   : "FloatMath"              'Floating Point object used to calculate Temperature
  FS     : "FloatString"            'Object to convert floating point value to a string
  flt    : "Float32Full"            'Floating point object with more math methods 
  
'------Wireless data transmit-------

  xbee   : "Xbee_Object"            'XBee wireless object, used for attached XBee module, not shown in this project
 
  
VAR
   
   long Temp                    'Holds outside temprature data
   long light                   'Holds Outside light data

   long value0                  'Holds multiplied floating point value of temp reading
   long value                   'Holds truncated floating point value of tempurature

   long  PorchStack   [35]      'Memory space to start new cogs
   long  ButtonsStack [35]      'Memory space to start new cogs
       
    
PUB Startup

   ADC.Start(DPin, CPin, SPin, 15)                       'Starts the ADC object "MCP3208" 
   shift.init(SR_CLOCK, SR_LATCH, SR_DATA)               'Starts Serial to Parallel object "Simple_74HC595"
  
   flt.start                                             'Start Floating Point object "Float32Full"
   FS.SetPrecision(3)

  'xbee.Start (XbeeDin, XbeeDout, XbeeMode, XbeeBaud)    'Used to start XBee object "not used is this project" 
  
  cognew(LightSense, @PorchStack)                        'Run LightSense method in new cog
  cognew(Buttons, @ButtonsStack)                         'Run Buttons method in new cog 
  
  waitcnt(clkfreq + cnt)                                 'wait a sec

  main                                                   'Run "main" method

     
PUB Main

  repeat                                                 'Loop indefinitely
                                                          
     GetTemperature                                      'Run "GetTemperature" method
                
     SevenSegment                                        'Run "SevenSegment" method
    
      
PUB SevenSegment | i, multiplier, x, shif, y, z, one
        
        rc.Pause1ms(20000)                                       'Wait for 20 seconds
                       
        multiplier := 100                                        'Multiplier for temperature calculation
                 
        value0 := flt.FMul(Temp, 10.0)                           'Multiply temperature by 10
         
        value := flt.FTrunc(value0)                              'Truncate the multiplied value

        shift.out($00)                                           'Reset the 7-segment LED display

       z := 0                                                    'Reset z to 0 
       x := 0                                                    'Reset x to 0
       
       repeat i from 0 to 2                                      'Repeat 3 times (since there are three digits we are displaying)

          x := (byte[@NonDecArray][(value/multiplier)//10])      'Identify the number 

          shif := i*8                                            'Update the bit placement

          z |= x <<shif                                          'Move the number into it's proper place "bitwise"

         if flt.ftrunc(Temp) <100                                'If statement to set a "period" if the value is less than 100
         '                                                       '(if the temperature is less than 100 then 7 segment will show decimal value)
        
            shift.out (z + $8000)

         else
                                 
            shift.out (z <<8 | one)   
                            
        multiplier /= 10

Pub GetTemperature

  Temp := ADC.In(0)                                    'Get raw reading from temperature sensor that is connected to ADC
  Temp := Math.FFloat(Temp)                            'Turn "Temp" reading into a floating point value so we can divide it below
  Temp := Math.FMul(Temp, 0.1203)                      '0.1203 comes from 0.001203(ADC mV per unit) multiplied by 100
  Temp := flt.FMul(Temp, 10.0)                         'Multiply by 10
  Temp := flt.FTrunc(Temp)                             'Truncate remaning digits
  Temp := flt.fdiv(temp,10.0)                          'Devide remainder by 10

           
PUB LightSense | RCValue
                                
 dira[RelayPorch]~~                                    'Set RelayPorch pin to an output
 RC.startRC(Capacity,RCPIN,RCSTATE, @RCValue)          'Start the RCTime object

       
      repeat
                                                       
         fs.FloatToMetric(RCValue,0)                   'Take the RCValue coming from RCTime circuit and convert to a floating point value
         
       
         if  RCvalue > trigger                         'Monitor the value and if the "Trigger" value is less then turn on the porch lights
             rc.Pause1ms(20000)
             outa[RelayPorch]~~
         else                                          'If the "Trigger" value is more then trun off the porch lights
             rc.Pause1ms(20000)
             outa[RelayPorch]~

   

PUB Buttons | countf, countp, state


  dira[RelayPorch]~~                                   'Set RelayPorch pin to an output
  dira[ButtonPorch]~                                   'Set ButtonPorch pin to an input

  dira[RelayFoyer]~~                                   'Set RelayFoyer pin to an output
  dira[ButtonFoyer]~                                   'Set ButtonFoyer pin to an input
  
   repeat                                              'Monitor the button state, if it's pressed then run the FoyerButton method or PorchButton method
       repeat while ina[ButtonFoyer] == false
            FoyerButton      
       
       repeat while ina[ButtonPorch] == false
            PorchButton

            
PUB PorchButton | count                              'Method to turn on and off the Porch Light
     
    count++

    if count == 1 
      outa[RelayPorch]~~
    else
      outa[RelayPorch]~
      count := 0 

   rc.Pause1ms(2000)
   
PUB FoyerButton | count                              'Method to turn on and off the Foyer Light

    count++

    if count == 1 
      outa[RelayFoyer]~~
    else
      outa[RelayFoyer]~
      count := 0 

   rc.Pause1ms(2000)
  
   
DAT

NonDecArray byte $3f, $06, $5b, $4f, $66, $6d, $7c, $07, $FF, $67      'Digits 0-9 in Hex for the 7-Segment display
     
                                                 