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

	$fileToload = $argv[1] ;
	
	
	$xml = simplexml_load_file($fileToload);
	if ($xml === false) {
		echo "Failed loading XML: ";
		foreach(libxml_get_errors() as $error) {
			echo "<br>", $error->message;
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
		writeToFile($Description, $hexBigSring);
	}
	/******************************************************************************************
	*
	*	This will build the build the hex string and conver it to little endian.
	*
	*
	*
	*/
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
	/******************************************************************************************
	*
	*	This will build the build the hex string and conver it to little endian.
	*
	*
	*
	*/
	function buildPauseHexString($pauseValue){
		
		$hexString = dechex(intval($pauseValue));
		$hexString = sprintf("%08s",$hexString);
		// 12345678
		// 01234567
		$hexString = substr($hexString,6,2) . substr($hexString,4,2) . substr($hexString,2,2) . substr($hexString,0,2);
		return $hexString;
	}
	/******************************************************************************************
	*
	*	
	*
	*
	*
	*/
	function writeToFile($fileName, $hexString){
		$hex = hex2bin($hexString);
		file_put_contents("tmp/$fileName.hex", $hex);
	}
	
	
	
	
	