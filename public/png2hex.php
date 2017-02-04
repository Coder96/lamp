<?php


echo '<table><tr>';
$im = new Imagick("/home/webedit/core_gradientpng.png");
$it = $im->getPixelIterator();

$count = 0;

foreach($it as $row => $pixels) {
    foreach ($pixels as $column => $pixel) {
        // Do something with $pixel
//        echo '<br>';
        $nor_color=$pixel->getColor();
//        print_r($nor_color);
				
				$bgcolor = sprintf("#%02x%02x%02x", $nor_color['r'], $nor_color['g'], $nor_color['b']);
        echo '<td bgcolor='. $bgcolor .' >_</td>';
        $count++;
				if($count == 16){
					echo '</tr><tr>';
					$count = 0;
				}
    }

    $it->syncIterator();
}
echo '</tr></table>';
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