#!/usr/bin/php
<?php

	$GLOBALS['myapp']['default']['outputPixelWidth']  = 16;
	$GLOBALS['myapp']['default']['outputPixelHeigth'] = 18;
	$GLOBALS['myapp']['default']['delayMilliSeconds'] = 1000;
//	$GLOBALS['myapp']['default'][''] = '';
//	$GLOBALS['myapp']['default'][''] = '';
	
	$GLOBALS['myapp']['startPixelRow']			= '';
	$GLOBALS['myapp']['startPixelCollum']		= '';
	$GLOBALS['myapp']['skipPixelRow'] 			= '';
	$GLOBALS['myapp']['skipPixelCollum'] 		= '';
	$GLOBALS['myapp']['scrollDirection'] 		= '';
	$GLOBALS['myapp']['outputPixelWidth']		= '';
	$GLOBALS['myapp']['outputPixelHeigth'] 	= '';
	$GLOBALS['myapp']['maxFramesToGet'] 		= PHP_INT_MAX;
	$GLOBALS['myapp']['inFileName']     		= '';
	$GLOBALS['myapp']['inFileHandel']   		= '';
	$GLOBALS['myapp']['outFileName']      	= '';
	$GLOBALS['myapp']['outFileHandel']    	= '';
	$GLOBALS['myapp']['scriptFileName']   	= '';
	$GLOBALS['myapp']['scriptFileHandel'] 	= '';
	$GLOBALS['myapp']['scriptFileFound']  	= false;
	$GLOBALS['myapp']['scriptCommands']   	= '';
	
	$GLOBALS['myapp']['script'] = array();
	
	$GLOBALS['myapp']['matrix']['rowCount'] = 0;
	$GLOBALS['myapp']['matrix']['colCount'] = 0;
	$GLOBALS['myapp']['matrix']['picture'] = array();
	$GLOBALS['myapp']['matrix']['frames'] = array();
	
	$GLOBALS['myapp']['debug'] = false;

//*********************************************************************
//
//
//
//*********************************************************************

	cliParms();

	if($GLOBALS['myapp']['scriptFileFound']){
		followScript();
	} else {
		
		readPNG();
			
		readDirection();
			
		$GLOBALS['myapp']['outFileHandel'] = fopen($GLOBALS['myapp']['outFileName'],'w');
		if(!$GLOBALS['myapp']['outFileHandel']){
			writeErr('Failed to open outFileName:'.$GLOBALS['myapp']['outFileName']);
			exit();
		}

		xmlOut();
	}
	exit();
//*********************************************************************
//
//
//
//*********************************************************************
function readDirection(){

	$curFrame['StopRead'] = false;

	$curFrame = calcStartPixelPoints($curFrame);

	$curFrame['fameCtr'] = 0;

	while($curFrame['StopRead'] == false and $curFrame['fameCtr'] < $GLOBALS['myapp']['maxFramesToGet']){
	
		readFrame($curFrame);
		
		$curFrame = getNextPoints($curFrame);
		
		$curFrame['fameCtr']++;
	}
}
//*********************************************************************
//
//
//
//*********************************************************************
function followScript(){
//print("sdssdsdss\n");
	readScript();
	processScript();
}
//*********************************************************************
//
//
//
//*********************************************************************
function processScript(){
	foreach($GLOBALS['myapp']['script']['cmd'] as $cmd){
//		print_r($cmd);
		switch($cmd[0]){
			case 'debugOn':
				debugSet(true);
				break;
			case 'debugOff':
				debugSet(false);
				break;
			case 'inFileName':
				if(inFileName($cmd[1])){
					$GLOBALS['myapp']['matrix']['rowCount'] = 0;
					$GLOBALS['myapp']['matrix']['colCount'] = 0;
					$GLOBALS['myapp']['matrix']['picture'] = array();
					readPNG();
				} else {
					writeErr('Script Stoped.  Err:'.$cmd[0].' '.$cmd[1]);
					exit();
				}
				break;
			case 'outFileName':
				outFileName($cmd[1]);
				break;
			case 'startPixelRow':
				startPixelRow($cmd[1]);
				break;
			case 'startPixelCollum':
				startPixelCollum($cmd[1]);
				break;
			case 'skipPixelRow':
				skipPixelRow($cmd[1]);
				break;
			case 'skipPixelCollum':
				skipPixelCollum($cmd[1]);
				break;
			case 'scrollDirection':
				if(scrollDirection($cmd[1])){
					readDirection();
				} else {
					writeErr('Script Stoped.  Err:'.$cmd[0].' '.$cmd[1]);
					exit();
				}
				break;
			case 'outputWidth':
				outputWidth($cmd[1]);
				break;
			case 'outputHeigth':
				outputHeigth($cmd[1]);
				break;
			case 'maxFramesToGet':
				if(maxFramesToGet($cmd[1])){
					writeErr('Script Stoped.  Err:'.$cmd[0].' '.$cmd[1]);
					exit();
				}
				break;
			case 'delayMilliSeconds':
				delayMilliSeconds($cmd[1]);
				break;
			case 'readPNG':
				readPNG();
				break;
			case 'writeXML':
				xmlOut();
				$GLOBALS['myapp']['matrix']['frames'] = array();
				break;
			case 'getFrame':
				$curFrame = array();
				$curFrame['wrkRowTL'] = $GLOBALS['myapp']['startPixelRow'];
				$curFrame['wrkColTL'] = $GLOBALS['myapp']['startPixelCollum'];
				readFrame($curFrame);
				break;
			default:
				writeErr('Script Stoped. Unknown Command.'.$cmd[0]);
				exit();
				break;
		}
		
	}
}
//*********************************************************************
//
//
//
//*********************************************************************
function readScript(){

	$data = file($GLOBALS['myapp']['scriptFileName']);
	if(!$data){
		writeErr('Failed to open scriptFileName:'.$GLOBALS['myapp']['scriptFileName']);
		exit();
	}
	
	foreach($data as $line){
		if(empty(trim($line)) or substr(trim($line),0,1) == ';'){
			$GLOBALS['myapp']['script']['Comment'][] = $line;
		} else {
			$GLOBALS['myapp']['script']['cmd'][] = explode('=',trim($line));
		}
	
	}
	
}
//*********************************************************************
//
//
//
//*********************************************************************
function readFrame($curFrame){
	
	$GLOBALS['myapp']['matrix']['frames'][] = getPixelBlock($curFrame);
}
//*********************************************************************
//
//
//
//
// Build a matrix for the entire picture.
//
// The counts start at 1 
// The picture array will start at 0
//
//*********************************************************************
function readPNG(){

	$im = new Imagick($GLOBALS['myapp']['inFileName']);
	$it = $im->getPixelIterator();	
	
	$GLOBALS['myapp']['matrix']['picture'] = array();

	$GLOBALS['myapp']['matrix']['rowCount'] = 0;
	foreach($it as $row => $pixels) {
		$GLOBALS['myapp']['matrix']['colCount'] = 0;
    foreach ($pixels as $column => $pixel) {
//			$GLOBALS['myapp']['matrix']['picture'][$GLOBALS['myapp']['matrix']['rowCount']][$GLOBALS['myapp']['matrix']['colCount']] = rgbToRgbwx($pixel->getColor());
			$GLOBALS['myapp']['matrix']['picture'][$GLOBALS['myapp']['matrix']['rowCount']][$GLOBALS['myapp']['matrix']['colCount']] = rgb2Sring($pixel->getColor());
			$GLOBALS['myapp']['matrix']['colCount']++;
		}
		$GLOBALS['myapp']['matrix']['rowCount']++;
	}

}
//*********************************************************************
//
//
//
//*********************************************************************
function calcStartPixelPoints($curFrame){
	
	$curFrame['wrkRowTL'] = 0;
	$curFrame['wrkColTL'] = 0;
	$curFrame['wrkRowBR'] = $GLOBALS['myapp']['outputPixelHeigth'];
	$curFrame['wrkColBR'] = $GLOBALS['myapp']['outputPixelWidth'];
	switch($GLOBALS['myapp']['scrollDirection']){
		case 'lr':
			$curFrame['wrkRowTL'] = $GLOBALS['myapp']['startPixelRow'];
			$curFrame['wrkColTL'] = $GLOBALS['myapp']['startPixelCollum'];
			break;
		case 'rl':
			// Top Left Row
			if($GLOBALS['myapp']['startPixelRow'] != 0){
				$curFrame['wrkRowTL'] = $GLOBALS['myapp']['startPixelRow'];
			} else {
				$curFrame['wrkRowTL'] = 0;
			}
			// Top Left Collum
			if($GLOBALS['myapp']['startPixelCollum'] != 0){
				$curFrame['wrkColTL'] = $GLOBALS['myapp']['startPixelCollum'];
			} else {
				$curFrame['wrkColTL'] = $GLOBALS['myapp']['matrix']['colCount'] - $GLOBALS['myapp']['outputPixelWidth'];
			}
			break;
		case 'tb':
			// Top Left Row
			if($GLOBALS['myapp']['startPixelRow'] != 0){
				$curFrame['wrkRowTL'] = $GLOBALS['myapp']['startPixelRow'];
			} else {
				$curFrame['wrkRowTL'] = 0;
			}
			// Top Left Collum
			if($GLOBALS['myapp']['startPixelCollum'] != 0){
				$curFrame['wrkColTL'] = $GLOBALS['myapp']['startPixelCollum'];
			} else {
				$curFrame['wrkColTL'] = 0;
			}
			break;
		case 'bt':
			// Top Left Row
			if($GLOBALS['myapp']['startPixelRow'] != 0){
				$curFrame['wrkRowTL'] = $GLOBALS['myapp']['startPixelRow'];
			} else {
				$curFrame['wrkRowTL'] = $GLOBALS['myapp']['matrix']['colCount'] - $GLOBALS['myapp']['outputPixelHeigth'];
			}
			// Top Left Collum
			if($GLOBALS['myapp']['startPixelCollum'] != 0){
				$curFrame['wrkColTL'] = $GLOBALS['myapp']['startPixelCollum'];
			} else {
				$curFrame['wrkColTL'] = 0;
			}			break;
	}
	// Bottom Right Row
	$curFrame['wrkRowBR'] = $curFrame['wrkRowTL'] + $GLOBALS['myapp']['outputPixelHeigth'] - 1;
	// Bottom Right Collum
	$curFrame['wrkColBR'] = $curFrame['wrkColTL'] + $GLOBALS['myapp']['outputPixelWidth'] - 1;
	return $curFrame;
}
//*********************************************************************
//
//
//
//*********************************************************************
function getPixelBlock($curFrame){

	$matrix = array();
	
	for($colCtr=$curFrame['wrkColTL'];$colCtr<$GLOBALS['myapp']['outputPixelWidth']+$curFrame['wrkColTL'];$colCtr++){	
		for($rowCtr=$curFrame['wrkRowTL'];$rowCtr<$GLOBALS['myapp']['outputPixelHeigth']+$curFrame['wrkRowTL'];$rowCtr++){
//			writeErr("col: $colCtr row:$rowCtr");
			$matrix[] = $GLOBALS['myapp']['matrix']['picture'][$rowCtr][$colCtr];
		}
	}
	
	return $matrix;
}

//*********************************************************************
//
//
//
//*********************************************************************
function getNextPoints($curFrame){
	
	$pixelRowMovemnt = 1;
	$pixelColMovemnt = 1;
	
	if($GLOBALS['myapp']['skipPixelRow'] > 0){
		$pixelRowMovemnt = 0;
	}
	if($GLOBALS['myapp']['skipPixelCollum'] > 0){
		$pixelColMovemnt = 0;
	}
	
	switch($GLOBALS['myapp']['scrollDirection']){
		case 'lr':
//			$curFrame['wrkRowTL'] = $curFrame['wrkRowTL'] + $pixelRowMovemnt + $GLOBALS['myapp']['skipPixelRow'];
			$curFrame['wrkColTL'] = $curFrame['wrkColTL'] + $pixelColMovemnt + $GLOBALS['myapp']['skipPixelCollum'];
//			$curFrame['wrkRowBR'] = $curFrame['wrkRowBR'] + $pixelRowMovemnt + $GLOBALS['myapp']['skipPixelRow'];
			$curFrame['wrkColBR'] = $curFrame['wrkColBR'] + $pixelColMovemnt + $GLOBALS['myapp']['skipPixelCollum'];
			if($curFrame['wrkColBR'] > $GLOBALS['myapp']['matrix']['colCount']){
				$curFrame['StopRead'] = true;
			}
			break;
		case 'rl':
//			$curFrame['wrkRowTL'] = $curFrame['wrkRowTL'] - $pixelRowMovemnt - $GLOBALS['myapp']['skipPixelRow'];
			$curFrame['wrkColTL'] = $curFrame['wrkColTL'] - $pixelColMovemnt - $GLOBALS['myapp']['skipPixelCollum'];
//			$curFrame['wrkRowBR'] = $curFrame['wrkRowBR'] - $pixelRowMovemnt - $GLOBALS['myapp']['skipPixelRow'];
			$curFrame['wrkColBR'] = $curFrame['wrkColBR'] - $pixelColMovemnt - $GLOBALS['myapp']['skipPixelCollum'];
			if($curFrame['wrkColTL'] < 0){
				$curFrame['StopRead'] = true;
			}
			break;
		case 'tb':
			$curFrame['wrkRowTL'] = $curFrame['wrkRowTL'] + $pixelRowMovemnt + $GLOBALS['myapp']['skipPixelRow'];
//			$curFrame['wrkColTL'] = $curFrame['wrkColTL'] + $pixelColMovemnt + $GLOBALS['myapp']['skipPixelCollum'];
			$curFrame['wrkRowBR'] = $curFrame['wrkRowBR'] + $pixelRowMovemnt + $GLOBALS['myapp']['skipPixelRow'];
//			$curFrame['wrkColBR'] = $curFrame['wrkColBR'] + $pixelColMovemnt + $GLOBALS['myapp']['skipPixelCollum'] ;
			if($curFrame['wrkRowBR'] > $GLOBALS['myapp']['matrix']['rowCount']-1){
				$curFrame['StopRead'] = true;
			}
			break;
		case 'bt':
			$curFrame['wrkRowTL'] = $curFrame['wrkRowTL'] - $pixelRowMovemnt - $GLOBALS['myapp']['skipPixelRow'];
//			$curFrame['wrkColTL'] = $curFrame['wrkColTL'] - $pixelColMovemnt - $GLOBALS['myapp']['skipPixelCollum'];
			$curFrame['wrkRowBR'] = $curFrame['wrkRowBR'] - $pixelRowMovemnt - $GLOBALS['myapp']['skipPixelRow'];
//			$curFrame['wrkColBR'] = $curFrame['wrkColBR'] - $pixelColMovemnt - $GLOBALS['myapp']['skipPixelCollum'];
			if($curFrame['wrkRowTL'] < 0){
				$curFrame['StopRead'] = true;
			}
			break;
	}	
	return $curFrame;
}

//*********************************************************************
//
//
//
//*********************************************************************
function xmlOut(){

	$frameCounter = 0;
	$xmlString = '';
	$xmlString2 = '';
	$frameHexString = '';


	foreach($GLOBALS['myapp']['matrix']['frames'] as $frame){
		$frameCounter++;
		foreach($frame as $pixel){
			$frameHexString .= "$pixel, ";
		}
		$frameHexString = substr($frameHexString, 0, -2);
		$xmlString2 .= '	<frame_' . $frameCounter . '> <!-- This block will repeat for each frame -->
			<picture> <!-- This is each pixel $00_00_00_00, $00_00_00_00, $00_00_00_00, ... -->
				<![CDATA[ '. $frameHexString . '
				]]>
			</picture>
			<pause>'. $GLOBALS['myapp']['delayMilliSeconds'] .'</pause> <!-- microseconds -->
		</frame_' . $frameCounter . '>
	';
		$frameHexString = '';
	}
	
	$xmlString = '<?xml version="1.0" encoding="UTF-8"?>
<animation>
  <description>Some Decription here.</description>
  <frameCounter>' . $frameCounter . '</frameCounter> <!-- This is tolal number of frames -->
	<frames>
	 '. $xmlString2 . '
	</frames>
</animation>';

	$GLOBALS['myapp']['outFileHandel'] = fopen($GLOBALS['myapp']['outFileName'],"w");
	if(!$GLOBALS['myapp']['outFileHandel']){
		writeErr('Failed to open outfile:'. $GLOBALS['myapp']['outFileName']);
	} else {
		fwrite($GLOBALS['myapp']['outFileHandel'], $xmlString);
		fclose($GLOBALS['myapp']['outFileHandel']);
	}
}
//*********************************************************************
//
//
//
//*********************************************************************
function rgb2Sring($iColor){
	
	$Ri = $iColor['r'];
	$Gi = $iColor['g'];
	$Bi = $iColor['b'];
	
	return sprintf("$%02x_%02x_%02x_00", $iColor['r'], $iColor['g'], $iColor['b']);
	
}
//*********************************************************************
//
//
//
//*********************************************************************
function rgbToRgbwx($iColor){

	$Ri = $iColor['r'];
	$Gi = $iColor['g'];
	$Bi = $iColor['b'];
	
	//Get the maximum between R, G, and B
	$tM = max($Ri, max($Gi, $Bi));

	//If the maximum value is 0, immediately return pure black.
	if($tM == 0){ 
		return sprintf("$%02x_%02x_%02x_%02x", 0, 0, 0, 0);
	}

	//This section serves to figure out what the color with 100% hue is
	$multiplier = 255 / $tM;
	$hR = $Ri * $multiplier;
	$hG = $Gi * $multiplier;
	$hB = $Bi * $multiplier;  

	//This calculates the Whiteness (not strictly speaking Luminance) of the color
	$M = max($hR, max($hG, $hB));
	$m = min($hR, min($hG, $hB));
	$Luminance = (($M + $m) / 2.0 - 127.5) * (255.0/127.5) / $multiplier;

	//Calculate the output values
	$Wo = intval($Luminance);
	$Bo = intval($Bi - $Luminance);
	$Ro = intval($Ri - $Luminance);
	$Go = intval($Gi - $Luminance);

	//Trim them so that they are all between 0 and 255
	if ($Ro < 0) $Ro = 0;
	if ($Go < 0) $Go = 0;
	if ($Bo < 0) $Bo = 0;
	if ($Wo < 10) $Wo = 0;
	if ($Ro > 255) $Ro = 255;
	if ($Go > 255) $Go = 255;
	if ($Bo > 255) $Bo = 255;
	if ($Wo > 255) $Wo = 255;

	return sprintf("$%02x_%02x_%02x_%02x", $Ro, $Go, $Bo, $Wo);
}
//*********************************************************************
//
//
//
//*********************************************************************

function cliParms(){

	$error = false;
	$errorMessage = '';
	
	$shortopts  = "h";

	$longopts  = array(
		'help',
		'scriptFileHelp',
		'debugOn',
		'startPixelRow::',
		'startPixelCollum::',
		'skipPixelCollum::',
		'delayMilliSeconds::',
		'skipPixelRow::',
		'scrollDirection::',
		'outputPixelWidth::',
		'outputPixelHeigth::',
		'maxFramesToGet::',
		'inFileName:',
		'outFileName::',
		'scriptFileName::',
           
		);
	$options = getopt($shortopts, $longopts);
//	var_dump($options);

	if(isset($options['debugOn'])){
		debugSet(true);
	} else {
		debugSet(false);
	}

	if(isset($options['outputPixelWidth'])){
		outputWidth($options['outputPixelWidth']);
	} else {
		outputWidth($GLOBALS['myapp']['default']['outputPixelWidth']);
	}
	
	if(isset($options['outputPixelHeigth'])){
		outputHeigth($options['outputPixelHeigth']);
	} else {
		outputHeigth($GLOBALS['myapp']['default']['outputPixelHeigth']);
	}
	
	if(isset($options['maxFramesToGet'])){
		maxFramesToGet($options['maxFramesToGet']);
	} else {
		maxFramesToGet(PHP_INT_MAX);
	}
			
	if(isset($options['startPixelRow'])){
		startPixelRow($options['startPixelRow']);
	} else {
		startPixelRow(0);
	}

	if(isset($options['startPixelCollum'])){
		startPixelCollum($options['startPixelCollum']);
	} else {
		startPixelCollum(0);
	}
	
	if(isset($options['skipPixelRow'])){
		skipPixelRow(intval($options['skipPixelRow']));
	} else {
		skipPixelRow(0);
	}
	
	if(isset($options['skipPixelCollum'])){
		skipPixelCollum($options['skipPixelCollum']);
	} else {
		skipPixelCollum(0);
	}

	if(isset($options['delayMilliSeconds'])){
		delayMilliSeconds($options['delayMilliSeconds']);
	} else {
		delayMilliSeconds($GLOBALS['myapp']['default']['delayMilliSeconds']);
	}
	

	if(isset($options['scrollDirection'])){
		scrollDirection($options['scrollDirection']);
	} else {
		scrollDirection('lr');
	}
	
	if(isset($options['inFileName'])){
		if(!inFileName($options['inFileName'])){
			$error = true;
			writeErr('--inFileName file not found:'.$options['inFileName']);	
		}
	} else {
		$GLOBALS['myapp']['inFileName'] = 'php://STDIN';
	}

	if(isset($options['outFileName'])){
		if($options['outFileName'] == 'STDOUT'){
			outFileName('php://STDOUT');
		} else {
			outFileName($options['outFileName']);
		}
	} else {
		outFileName('php://STDOUT');
	}
	
	if(isset($options['scriptFileName'])){
		if(is_file($options['scriptFileName'])){
			$GLOBALS['myapp']['scriptFileName'] = $options['scriptFileName'];
			$GLOBALS['myapp']['scriptFileFound'] = true;
		} else {
			$GLOBALS['myapp']['scriptFileName'] = '';
			$error = false;
			writeErr('--scriptFileName file not found:'.$options['scriptFileName']);	
		}
	} else {
		$GLOBALS['myapp']['scriptFileName'] = '';
	}
	
	if($GLOBALS['myapp']['debug'] == true){
	writeErr(
		'--startPixelRow     '. $GLOBALS['myapp']['startPixelRow']     ."\n".
		'--startPixelCollum  '. $GLOBALS['myapp']['startPixelCollum']  ."\n".
		'--skipPixelRow      '. $GLOBALS['myapp']['skipPixelRow']      ."\n".
		'--skipPixelCollum   '. $GLOBALS['myapp']['skipPixelCollum']   ."\n".
		'--delayMilliSeconds '. $GLOBALS['myapp']['delayMilliSeconds'] ."\n".
		'--scrollDirection   '. $GLOBALS['myapp']['scrollDirection']   ."\n".
		'--outputPixelWidth  '. $GLOBALS['myapp']['outputPixelWidth']  ."\n".
		'--outputPixelHeigth '. $GLOBALS['myapp']['outputPixelHeigth'] ."\n".
		'--maxFramesToGet    '.	$GLOBALS['myapp']['maxFramesToGet']    ."\n".
		'--inFileName        '. $GLOBALS['myapp']['inFileName']        ."\n".
//		''. $GLOBALS['myapp']['inFileHandel'] = '';
		'--outFileName       '. $GLOBALS['myapp']['outFileName']       ."\n".
		'--scriptFileName    '. $GLOBALS['myapp']['scriptFileName']    ."\n".
		'  scriptFileFound   '. $GLOBALS['myapp']['scriptFileFound']   ."\n"
//		''. $GLOBALS['myapp']['outFileHandel'] = '';
		
//		'rowCount'. $GLOBALS['myapp']['matrix']['rowCount'] ."\n".
//		'ColCount'. $GLOBALS['myapp']['matrix']['colCount'] ."\n"
//		$GLOBALS['myapp']['matrix']['picture'] = array();."\n".
//		$GLOBALS['myapp']['matrix']['frames'] = array();."\n".
		);
	}

	if(isset($options['h']) or isset($options['help']) or $error or isset($options['scriptFileHelp'])){

		if($error){
			writeErr("Error exiting.");
		}
		
		if(isset($options['h']) or isset($options['help']) ){
			writeErr('

 Options:

   --inFileName         Default STDIN.
   --outFileName        Default STDOUT.
   
   --startPixelRow      Start Row. This is absolute poxition.    Default 0
   --startPixelCollum   Start Collum. This is absolute poxition. Default 0

   --skipPixelRow       Pixels to skip between frames. Default 0
   --skipPixelCollum    Pixels to skip between frames. Default 0
   
   --delayMilliSeconds  Delay in milli Seconds. Default '.$GLOBALS['myapp']['default']['delayMilliSeconds'].'	

   --scrollDirection    Direction for the frame to move. Default lr
     lr  Left to Right. Start Pixel Upper Left.
     rl  Right to Left. Start Pixel Upper Right.
     tb  Top to Bottom. Start Pixel Upper Left.
     bt  Bottom to Top. Start Pixel Lower Left.

   --outputPixelWidth  Default '.$GLOBALS['myapp']['default']['outputPixelWidth'].'
   --outputPixelHeigth Default '.$GLOBALS['myapp']['default']['outputPixelHeigth'].'
   
   --maxFramesToGet    Set this to only grab cirtan number of frames. Default 1 to '. number_format(PHP_INT_MAX, 0) .'. The max is depentand on you architecture.
   
   -h      Help Screen.
   --help  Help Screen.
   
   --scriptFileName   
   --scriptFileHelp   Scripting details.

   $'.__FILE__.' --delayMilliSeconds=2000

');
		}
		if(isset($options['scriptFileHelp'])){
			writeErr('

debugOn						To start debug messages
debugOff					To Stop debug messages

inFileName        File name for the PNG
outFileName				File name for the XML data. Data will be cleard after written.

startPixelRow
startPixelCollum
									These will act as normal when used with scrollDirection
skipPixelCollum
skipPixelRow


scrollDirection 	Must give a direction.  

delayMilliSeconds Delay in milli Seconds.

outputWidth		
outputHeigth

maxFramesToGet   This is for the scrollDirection

getFrame         This will use the startPixelRow and startPixelCollum values.

readPNG          This will read what is in inFileName. removes what is currently in memory.
writeXML         This will write the xml to what is in outFileName. Clear data in memory.


');
		}
		exit();
	
	}
}
//*********************************************************************
//
//
//
//*********************************************************************
function writeErr($line){
	fwrite(STDERR,"$line\n");
}
//*********************************************************************
//
//
//
//*********************************************************************
function debugSet($set){

		$GLOBALS['myapp']['debug'] = $set;
}
//*********************************************************************
//
//
//
//*********************************************************************
function inFileName($iFile){

		if(is_file($iFile)){
			$GLOBALS['myapp']['inFileName'] = $iFile;
		} else {
			writeErr('inFileName file not found:'.$iFile);	
			return false;
		}
	return true;
}
//*********************************************************************
//
//
//
//*********************************************************************
function outFileName($iFile){
	$GLOBALS['myapp']['outFileName'] = $iFile;
}
//*********************************************************************
//
//
//
//*********************************************************************
function startPixelRow($iRow){
	$GLOBALS['myapp']['startPixelRow'] = intval($iRow);
}
//*********************************************************************
//
//
//
//*********************************************************************
function startPixelCollum($iCollum){
	$GLOBALS['myapp']['startPixelCollum'] = intval($iCollum);
}
//*********************************************************************
//
//
//
//*********************************************************************
function skipPixelRow($iRow){
	$GLOBALS['myapp']['skipPixelRow']  = intval($iRow);
}
//*********************************************************************
//
//
//
//*********************************************************************
function skipPixelCollum($iCollum){
	$GLOBALS['myapp']['skipPixelCollum'] = intval($iCollum);
}
//*********************************************************************
//
//
//
//*********************************************************************
function scrollDirection($iDirection){
	$allowedDirections = array('lr','rl','tb','bt');
	$iDirection = strtolower($iDirection);
	if(in_array($iDirection,$allowedDirections)){
		$GLOBALS['myapp']['scrollDirection'] = $iDirection;
	} else {
		$GLOBALS['myapp']['scrollDirection'] = 'lr';
		writeErr('Bad scrollDirection.');
		return false;
	}
	return true;
}
//*********************************************************************
//
//
//
//*********************************************************************
function outputWidth($iWidth){
	$GLOBALS['myapp']['outputPixelWidth'] = intval($iWidth);
}
//*********************************************************************
//
//
//
//*********************************************************************
function outputHeigth($iHeigth){
	$GLOBALS['myapp']['outputPixelHeigth'] = intval($iHeigth);
}
//*********************************************************************
//
//
//
//*********************************************************************
function maxFramesToGet($iFrames){
	if(intval($iFrames) < 1){
		$GLOBALS['myapp']['maxFramesToGet'] = PHP_INT_MAX;
		return false;
	} else {
		$GLOBALS['myapp']['maxFramesToGet'] = intval($iFrames);
	}
	return true;		
}
//*********************************************************************
//
//
//
//*********************************************************************
function delayMilliSeconds($iDealy){
	$GLOBALS['myapp']['delayMilliSeconds'] = intval($iDealy);
}











