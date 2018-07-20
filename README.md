# lamp
Code for RGBW led lamp 

#Writeup
[Writeup on hackster.io](https://www.hackster.io/jason11/rgb-lamp-746ed7)

## Operation

### Running Modes

Single file where one file is repeated.

Mulit file where it motates thought a list of files.

Each mode can be on repeat or just once.

When running the annimations onece the display can be cleard.

## Current Step Display Codes

01	-	IO Cleard  
02	-	Step Display  
03	-	Serial Initialized  
04	-	Timer Initialized  
05	-	Option Parser Initialized  
06	-	SD Card Rader Initialized  
07	-	RGBW Display Initialized  
08	-	  
09	-	  

14	-	File Failed to open. 
16	-	SD Card NOT Mounted  

20	-	Start New Frame  
29	-	Frame Sent to Display  

## Frame File Format

file is made of records. Records have feilds. Everything is 4 bytes long.

frameRecordDelimiter long  $01_01_01_01  
frameFieldDelimiter  long  $02_02_02_02

Feild 1 is pixel data.  
Then  frameFieldDelimiter. 
Feild 2 is Pause time between frames  
Then frameRecordDelimiter  


## STARTUP.TXT

The system looks at this file to know what to do. File name must be upper case.

STARTUPTYPE will have the values SINGLE or MULTI

STARTUPTYPE SINGLE  
In SINGLE mode.  
It will just look for the option FRAMEFILE with the file name as an option.

FRAMEFILE TEST4300.HEX

In MULTI mode. 
You can have up to 10 files in rotation. Blank filenames will be skipped.


FRAMESFILE 0 TEST4300.HEX  
FRAMESFILE 1 AMPTEST1.HEX  
FRAMESFILE 2 AMPTEST2.HEX  
FRAMESFILE 3 AMPTEST3.HEX  
FRAMESFILE 4 testan.hex  
FRAMESFILE 5 wc.hex  
FRAMESFILE 6 ms.hex  
FRAMESFILE 7 testplus.hex  
'FRAMESFILE 8   
'FRAMESFILE 9   

The files names need to conform to the dos file name convention.

## Utilities

public Folder.
	index.php	-	will give you an interface to create frames manualy. Import xml.  

Util Folder
	png2xml.php	-	Allows to make an animation from a png file. Outputs XML.  
	xml2hex.php	-	Will convert your xml files to hex.  

### XML Format  

	<?xml version="1.0" encoding="UTF-8"?>
	<animation>
	  <description>Some Decription here.</description>
	  <frameCounter>1</frameCounter> <!-- This is tolal number of frames -->  
		<frames>
			<frame_1> <!-- This block will repeat for each frame -->
				<picture> <!-- This is each pixel $00_00_00_00, $00_00_00_00, $00_00_00_00, ... -->
					<![CDATA[ 
					]]>
				</picture>
				<pause>1000</pause> <!-- microseconds -->
			</frame_1>
		</frames>
	</animation>

## Future Plans

Clean Up code.

+ Add wifi interface  
    - Send files to SD card.  
    - Edit the STARTUP.TXT  
    - Control What file is being diaplyed.  
    - Stream To the didplay directly.  
	
	
	
	
	
	
	
