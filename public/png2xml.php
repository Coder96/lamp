<?php


	$matrix = array();

	$im = new Imagick("tmp/core_gradientpng.png");
	$it = $im->getPixelIterator();

	$diasplayHeigth = 18;
	$displayWidth = 16;
	
	$rowCount = 0;
	$collumCount = 0;

	$picTable = '<table><tr>';
	
	foreach($it as $row => $pixels) {
    foreach ($pixels as $column => $pixel) {
//      Do something with $pixel
//      echo '<br>';
			$nor_color=$pixel->getColor();
//      print_r($nor_color);
//			exit;

//	Array ( [r] => 4 [g] => 116 [b] => 127 [a] => 1 )


			$bgcolor1 = sprintf("#%02x%02x%02x", $nor_color['r'], $nor_color['g'], $nor_color['b']);
			$bgcolor = sprintf("$%02x_%02x_%02x_00", $nor_color['r'], $nor_color['g'], $nor_color['b']);
			$picTable = $picTable . '<td bgcolor='. $bgcolor1 .' >_</td>';
			$matrix[$rowCount][$collumCount] = $bgcolor;
			
			$collumCount++;
			if($collumCount == 16){
				$picTable = $picTable . '</tr><tr>';
				$collumCount = 0;
			}
		}
		$rowCount++;
//		if($rowCount == 18){
//			$rowCount = 0;
//		}
    $it->syncIterator();
	}
	$picTable = $picTable . '</tr></table>';
	echo $picTable;
	
	echo('<pre><code>');
//	var_dump($matrix[0]);
	var_dump(sizeof($matrix));
	$frameCounter = 0;
	$screenString = '';
	for($frameCounter = 0; $frameCounter <= (sizeof($matrix)-$diasplayHeigth); $frameCounter++){
		for($w = 0; $w <= ($displayWidth-1); $w++){							//	Total of 16 times. Width of display.
			for($h = $frameCounter; $h <= ($diasplayHeigth-1+$frameCounter); $h++){					//	Total of 18 times. Heigth of display.
//				$screenString = $screenString . " $h:$w ". $matrix[$h][$w] . ', ';
				$screenString = $screenString . $matrix[$h][$w] . ', ';
			}
		}
		$screenString = substr($screenString, 0, -2);	
		echo("$frameCounter:$screenString<br>");
		$screenString = '';
	}
/*
$filename = "/home/webedit/core_gradientpng.png";
$handle = fopen($filename, "rb");
$binContents = fread($handle, filesize($filename));
fclose($handle);

$hexContents = bin2hex($binContents);

echo '89:' . substr($hexContents, 0,2).'<br>';
echo '504e47:' . substr($hexContents, 2,6).'<br>';
echo '0d0a:' . substr($hexContents, 8,4).'<br>';
echo '1a0a:' . substr($hexContents, 12,4).'<br>';

echo '<br>';

echo 'pic:' . substr($hexContents, 16,200).'<br>';


//echo $hexContents;
*/