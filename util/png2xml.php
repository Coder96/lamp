#!/usr/bin/php
<?php

	$GLOBALS['myapp']['startPixelRow'] = '';
	$GLOBALS['myapp']['startPixelCollum'] = '';
	$GLOBALS['myapp']['skipPixelRow'] = '';
	$GLOBALS['myapp']['skipPixelCollum'] = '';
	$GLOBALS['myapp']['scrollDirection'] = '';
	$GLOBALS['myapp']['outputPixelWidth'] = '';
	$GLOBALS['myapp']['outputPixelHeigth'] = '';
	$GLOBALS['myapp']['inFileName'] = '';
	$GLOBALS['myapp']['inFileHandel'] = '';
	$GLOBALS['myapp']['outFilename'] = '';
	$GLOBALS['myapp']['outFileHandel'] = '';
	
	$GLOBALS['myapp']['matrix']['rowCount'] = 0;
	$GLOBALS['myapp']['matrix']['colCount'] = 0;
	$GLOBALS['myapp']['matrix']['picture'] = array();
	$GLOBALS['myapp']['matrix']['frames'] = array();
	
	$GLOBALS['myapp']['debug'] = true;
	
	cliParms();
	
	$GLOBALS['myapp']['outFileHandel'] = fopen($GLOBALS['myapp']['outFilename'],'w');
	if(!$GLOBALS['myapp']['outFileHandel']){
		writeErr('Failed to open outFilename:'.$GLOBALS['myapp']['outFilename']);
		exit();
	}
	
	$im = new Imagick($GLOBALS['myapp']['inFileName']);
	$it = $im->getPixelIterator();
	
	//
	// Build a matrix for the entire picture.
	//
	// The counts start at 1 
	// The picture array will start at 0
	//
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
		
	$curFrame['StopRead'] = false;

	$curFrame = calcStartPixelPoints($curFrame);
//	writeErr(print_r($curFrame,true));
	
	while($curFrame['StopRead'] == false){
		$GLOBALS['myapp']['matrix']['frames'][] = getPixelBlock($curFrame);
		$curFrame = getNextPoints($curFrame);
//		writeErr(print_r($curFrame,true));

	}	
	
	xmlOut();
	
	exit();

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
			<pause>1000</pause> <!-- microseconds -->
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

	$GLOBALS['myapp']['outFileHandel'] = fopen($GLOBALS['myapp']['outFilename'],"w");
	if(!$GLOBALS['myapp']['outFileHandel']){
		writeErr('Failed to open outfile:'. $GLOBALS['myapp']['outFilename']);
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
		'startPixelRow::',
		'startPixelCollum::',
		'skipPixelCollum::',
		'skipPixelRow::',
		'scrollDirection::',
		'outputWidth::',
		'outputHeigth::',
		'inFileName:',
		'outFilename::',
           
		);
	$options = getopt($shortopts, $longopts);
//	var_dump($options);


	if(isset($options['outputPixelWidth'])){
		$GLOBALS['myapp']['outputPixelWidth'] = intval($options['outputPixelWidth']);
	} else {
		$GLOBALS['myapp']['outputPixelWidth'] = 16;
	}
	
	if(isset($options['outputPixelHeigth'])){
		$GLOBALS['myapp']['outputPixelHeigth'] = intval($options['outputPixelHeigth']);
	} else {
		$GLOBALS['myapp']['outputPixelHeigth'] = 18;
	}
	
	
	if(isset($options['startPixelRow'])){
		$GLOBALS['myapp']['startPixelRow'] = intval($options['startPixelRow']);
	} else {
		$GLOBALS['myapp']['startPixelRow'] = 0;
	}

	if(isset($options['startPixelCollum'])){
		$GLOBALS['myapp']['startPixelCollum'] = intval($options['startPixelCollum']);
	} else {
		$GLOBALS['myapp']['startPixelCollum'] = 0;
	}
	
	if(isset($options['skipPixelRow'])){
		$GLOBALS['myapp']['skipPixelRow'] = intval($options['skipPixelRow']);
	} else {
		$GLOBALS['myapp']['skipPixelRow'] = 0;
	}
	
	if(isset($options['skipPixelCollum'])){
		$GLOBALS['myapp']['skipPixelCollum'] = intval($options['skipPixelCollum']);
	} else {
		$GLOBALS['myapp']['skipPixelCollum'] = 0;
	}


	$allowedDirections = array('lr','rl','tb','bt');
	if(isset($options['scrollDirection'])){
		$options['scrollDirection'] = strtolower($options['scrollDirection']);
		if(in_array($options['scrollDirection'],$allowedDirections)){
			$GLOBALS['myapp']['scrollDirection'] = $options['scrollDirection'];
		} else {
			$error = true;
			writeErr('Unknown Direction: '. $options['scrollDirection']);
		}
	} else {
		$GLOBALS['myapp']['scrollDirection'] = "lr";
	}
	
	if(isset($options['inFileName'])){
		if(is_file($options['inFileName'])){
			$GLOBALS['myapp']['inFileName'] = $options['inFileName'];
		} else {
			$error = true;
			writeErr('--inFileName file not found:'.$options['inFileName']);	
		}
	} else {
		$error = true;
		writeErr('--inFileName required');
	}

	if(isset($options['outFilename'])){
		if($options['outFilename'] == 'STDOUT'){
			$GLOBALS['myapp']['outFilename'] = 'php://STDOUT';
		} else {
			$GLOBALS['myapp']['outFilename'] = $options['outFilename'];
		}
	} else {
		$GLOBALS['myapp']['outFilename'] = 'php://STDOUT';
	}
	
	if($GLOBALS['myapp']['debug'] == true){
	writeErr(
		'--startPixelRow     '. $GLOBALS['myapp']['startPixelRow']     ."\n".
		'--startPixelCollum  '. $GLOBALS['myapp']['startPixelCollum']  ."\n".
		'--skipPixelRow      '. $GLOBALS['myapp']['skipPixelRow']      ."\n".
		'--skipPixelCollum   '. $GLOBALS['myapp']['skipPixelCollum']   ."\n".
		'--scrollDirection   '. $GLOBALS['myapp']['scrollDirection']   ."\n".
		'--outputPixelWidth  '. $GLOBALS['myapp']['outputPixelWidth']  ."\n".
		'--outputPixelHeigth '. $GLOBALS['myapp']['outputPixelHeigth'] ."\n".
		'--inFileName        '. $GLOBALS['myapp']['inFileName']        ."\n".
//		''. $GLOBALS['myapp']['inFileHandel'] = '';
		'--outFilename       '. $GLOBALS['myapp']['outFilename']       ."\n"
//		''. $GLOBALS['myapp']['outFileHandel'] = '';
		
//		'rowCount'. $GLOBALS['myapp']['matrix']['rowCount'] ."\n".
//		'ColCount'. $GLOBALS['myapp']['matrix']['colCount'] ."\n"
//		$GLOBALS['myapp']['matrix']['picture'] = array();."\n".
//		$GLOBALS['myapp']['matrix']['frames'] = array();."\n".
		);
	}

	if(isset($options['h']) or isset($options['help']) or $error){
		if($error){
			writeErr("Error exiting.");
		}
		
		echo('

 Options:

   --inFileName        Full Path or STDIN.
   
   --outFilename       Full Path.  Default STDOUT.
   
   --startPixelRow     Start Row. This is absolute poxition.    Default 0
   --startPixelCollum  Start Collum. This is absolute poxition. Default 0

   --skipPixelRow      Pixels to skip between frames. Default 0
   --skipPixelCollum   Pixels to skip between frames. Default 0

   --scrollDirection   Direction for the frame to move. Default lr
     lr  Left to Right. Start Pixel Upper Left.
     rl  Right to Left. Start Pixel Upper Right.
     tb  Top to Bottom. Start Pixel Upper Left.
     bt  Bottom to Top. Start Pixel Lower Left.

   --outputPixelWidth  Default 16
   --outputPixelHeigth Default 18
   
   -h      Help Screen.
   --help  Help Screen.


');

		exit();
	
	}
}
//*****************************************
function writeErr($line){
	fwrite(STDERR,"$line\n");
}



















