#!/usr/bin/php

<?PHP
/*
* Contol Hex. These are essentially black so we can use then as control
*
*	010101 - Deliniter between animation(record) block.
* 020202 - Delimiter with in animation(field) block.
* 030303 - 
* 040404 - 
* 050505 - 
* 060606 - 
* 070707 - 
* 080808 - 
* 090909 - 
*/
	$controlCodes = array(
		'recordDelimiter' => '01010101',
		'fieldDelimiter'	=> '02020202',
		'3' => '03030303',
		'4' => '04040404',
		'5' => '05050505',
		'6' => '06060606',
		'7' => '07070707',
		'8' => '08080808',
		'9' => '09090909'
	);
	$GLOBALS['myapp']['debug'] 					= false;
	$GLOBALS['myapp']['inFileName']     = '';
	$GLOBALS['myapp']['outFileName']    = '';
	
	
	cliParms();
	
	$xml = simplexml_load_file($GLOBALS['myapp']['inFileName']);
	if ($xml === false) {
		writeErr("Failed loading XML: ");
		foreach(libxml_get_errors() as $error) {
			writeErr($error->message);
		}
	} else {
		$hexBigSring = '';
		$Description = trim($xml->description);
		for($x=1;$x<=$xml->frameCounter;$x++){
			$hexPicString = buildPictureHexString(trim($xml->xpath('/animation/frames/frame_' .$x. '/picture')[0][0]));
			$hexPasString = buildPauseHexString($xml->xpath('/animation/frames/frame_' .$x. '/pause')[0][0]);
			$hexBigSring = $hexBigSring . 
				$hexPicString . 
				$controlCodes['fieldDelimiter'] . 
				$hexPasString . 
				$controlCodes['recordDelimiter'];
		}
		
		writeToFile($GLOBALS['myapp']['outFileName'], $hexBigSring);
	}
//*********************************************************************
//
// This will build the build the hex string and conver it to little endian.
//
//
//
//*********************************************************************
function buildPictureHexString($csvString){
	//$h1 = '$78_56_34_12';
	//       012345678901
	$hexString = '';
	$list = str_getcsv($csvString);
	foreach($list as $item){
		$h1 = trim($item);
		$hexString = $hexString . substr($h1,10,2) . substr($h1,7,2) . substr($h1,4,2) . substr($h1,1,2);
	}
	return($hexString);
}
//*********************************************************************
//
//	This will build the build the hex string and conver it to little endian.
//
//
//
//*********************************************************************
function buildPauseHexString($pauseValue){
	
	$hexString = dechex(intval($pauseValue));
	$hexString = sprintf("%08s",$hexString);
	// 12345678
	// 01234567
	$hexString = substr($hexString,6,2) . substr($hexString,4,2) . substr($hexString,2,2) . substr($hexString,0,2);
	return $hexString;
}
//*********************************************************************
//
//
//
//*********************************************************************
function writeToFile($iFileName, $hexString){
	$hex = hex2bin($hexString);
	file_put_contents($iFileName, $hex);
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
		'debugOn',
		'inFileName:',
		'outFileName::',
           
		);
	$options = getopt($shortopts, $longopts);	
	
	if(isset($options['debugOn'])){
		debugSet(true);
	} else {
		debugSet(false);
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
	
	if(isset($options['h']) or isset($options['help']) or $error or isset($options['scriptFileHelp'])){

		if($error){
			writeErr("Error exiting.");
		}
		
		if(isset($options['h']) or isset($options['help']) ){
			writeErr('

 Options:

   --inFileName         Default STDIN.
   --outFileName        Default STDOUT.

   $'.__FILE__.' --inFileName=test.xml --outFileName=test.hex

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
	
	
	
	
	
	
	
	
	
