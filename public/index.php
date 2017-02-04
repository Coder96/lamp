<html>
	<head>
		<script type="text/javascript" src="jscolor/jscolor.min.js"></script>
		<script language="javascript" type="text/javascript">
	function Color(cellid){
		document.getElementById(cellid).style.backgroundColor = document.getElementById('currentcolor').style.backgroundColor;
		setOutString();
  }
  function setOutString(){
  	var outStr = '';
  	for(x=1;x < 289;x++){
  		if(document.getElementById('cellid_' + x).style.backgroundColor){
 				outStr += rgb2hex(document.getElementById('cellid_' + x).style.backgroundColor) + '_00, ';
  		} else {
  			outStr += '$00_00_00_00, ';
   		}
  	}
  	document.getElementById('outScreen').value = outStr;
  }
  function rgb2hex(rgb){
 		rgb = rgb.match(/^rgba?[\s+]?\([\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?/i);
 		return (rgb && rgb.length === 4) ? "$" +
  		("0" + parseInt(rgb[1],10).toString(16)).slice(-2) + '_' +
 			("0" + parseInt(rgb[2],10).toString(16)).slice(-2) + '_' +
	  	("0" + parseInt(rgb[3],10).toString(16)).slice(-2) : '';
	}
	function moveUp(){
		for(l=1;l<=16;l++){
			document.getElementById('savecolcellid_' + l).style.backgroundColor = 
				document.getElementById(document.getElementsByName('tabcel_' + l)[0].id).style.backgroundColor;			
		}
		var lstart = 1;
		var lstop = 272;
	 	for(y=lstart;y <= lstop;y++){
	 		var cell = y + 16;
			document.getElementById(document.getElementsByName('tabcel_' + (cell - 16))[0].id).style.backgroundColor = 
				document.getElementById(document.getElementsByName('tabcel_' + cell)[0].id).style.backgroundColor;
	 	}
	 	for(l=1;l<=16;l++){
			document.getElementById(document.getElementsByName('tabcel_' + (l + 272))[0].id).style.backgroundColor =
				document.getElementById('savecolcellid_' + l).style.backgroundColor;
			document.getElementById('savecolcellid_' + l).style.backgroundColor = '';			
		}
		setOutString();
	}
	function moveDown(){
		for(l=1;l<=16;l++){
			document.getElementById('savecolcellid_' + l).style.backgroundColor = 
				document.getElementById(document.getElementsByName('tabcel_' + (l + 272))[0].id).style.backgroundColor;			
		}
		var lstart = 288;
		var lstop = 17;
	 	for(y=lstart;y >= lstop;y--){
	 		var cell = y - 16;
			document.getElementById(document.getElementsByName('tabcel_' + (cell + 16))[0].id).style.backgroundColor = 
				document.getElementById(document.getElementsByName('tabcel_' + cell)[0].id).style.backgroundColor;
	 	}
	 	for(l=1;l<=16;l++){
			document.getElementById(document.getElementsByName('tabcel_' + l)[0].id).style.backgroundColor =
				document.getElementById('savecolcellid_' + l).style.backgroundColor;
			document.getElementById('savecolcellid_' + l).style.backgroundColor = '';			
		}
		setOutString();
	}
	function moveLeft(){
		for(l=1;l<=18;l++){
			document.getElementById('saverowcellid_' + l).style.backgroundColor = 
				document.getElementById('cellid_' + l).style.backgroundColor;			
		}
		var lstart = 1;
		var lstop = 270;
	 	for(y=lstart;y <= lstop;y++){
	 		var cell = y + 18;
			document.getElementById('cellid_' + (cell - 18)).style.backgroundColor = 
				document.getElementById('cellid_' + cell).style.backgroundColor;
	 	}
	 	for(l=1;l<=18;l++){
			document.getElementById('cellid_' + (l + 270)).style.backgroundColor =
				document.getElementById('saverowcellid_' + l).style.backgroundColor;
			document.getElementById('saverowcellid_' + l).style.backgroundColor = '';			
		}
		setOutString();
	}
	function moveRight(){
		for(l=1;l<=18;l++){
			document.getElementById('saverowcellid_' + l).style.backgroundColor = 
				document.getElementById('cellid_' + (l + 270)).style.backgroundColor;			
		}
		var lstart = 288;
		var lstop = 19;
	 	for(y=lstart;y >= lstop;y--){
	 		var cell = y - 18;
			document.getElementById('cellid_' + (cell + 18)).style.backgroundColor = 
				document.getElementById('cellid_' + cell).style.backgroundColor;
		}
	 	for(l=1;l <=18;l++){
			document.getElementById('cellid_' + l).style.backgroundColor =
				document.getElementById('saverowcellid_' + l).style.backgroundColor;
			document.getElementById('saverowcellid_' + l).style.backgroundColor = '';			
		}
		setOutString();
	}
		</script>
	</head>
	<body>
  <table>
  	<tr><td>
		<table BORDER=1 CELLSPACING=0>
			<tr><th>0</th></tr>
<?PHP
	for($y=1;$y <= 18;$y++){ // collums
 		echo('<tr><th WIDTH=20px HEIGHT=40px id=saverowcellid_'. $y .' >'. $y .'</th></tr>');
 	}
?>
		</table>
		</td><td>
		<table BORDER=1 CELLSPACING=0>
			<thead>
				<tr>
<?PHP
	for($y=1;$y <= 16;$y++){ // collums
 		echo('<th id=savecolcellid_'. $y .' >'. sprintf("%003s",$y) .'</th>');
 	}
?>
				</tr>
			</thead>
			<tbody>
<?PHP
	for($x=0;$x <= 17;$x++){ // rows
		echo('<tr>');
	 	for($y=0;$y <= 15;$y++){ // collums
	 		$z = $x + ($y * 18) + 1;
	 		$w = ($x * 16) + $y + 1;
	 		echo('<td name=tabcel_' . $w .'  id=cellid_' . $z .' ALIGN=center WIDTH=20px HEIGHT=40px onclick="Color(\'cellid_'.$z.'\');">'.$z.'</td>');
	 	}
	 	echo('</tr>');
	}		
?>
			</tbody>
		</table>
		</td><td VALIGN=top>

<div hidden><p id="container"></p></div>
<div><p id="containe2"></p></div>
<script>
    for(var i = 0; i < 100; i++) {
	    
      var input = document.createElement('INPUT')
      input.setAttribute('id', 'color_' + i)
      var picker = new jscolor(input)
      picker.fromHSV(360 / 100 * i, 100, 100)
     	document.getElementById('container').appendChild(input)
     	
     	var input2 = document.createElement('INPUT')
     	input2.setAttribute('TYPE', 'button')
//     	input2.setAttribute('style','')
     	input2.setAttribute('id', 'color2_' + i)
     	input2.setAttribute('onclick', 'setCurrentColor("color2_' + i + '")')
     	document.getElementById('containe2').appendChild(input2)
     	
     	document.getElementById('color2_' + i).style.backgroundColor = document.getElementById('color_' + i).style.backgroundColor
     	document.getElementById('color2_' + i).style.width = '60px'
     	document.getElementById('color2_' + i).style.color = document.getElementById('color_' + i).style.color
     	document.getElementById('color2_' + i).value = document.getElementById('color_' + i).value
     	document.getElementById('color2_' + i).style.border = '0'
     	     	
    }
    var input2 = document.createElement('INPUT')
    input2.setAttribute('id', 'color2_101')
    input2.setAttribute('TYPE', 'button')
    input2.setAttribute('onclick', 'setCurrentColor("color2_101")')
    document.getElementById('containe2').appendChild(input2) 	
    document.getElementById('color2_101').style.backgroundColor = '#FFFFFF'
    document.getElementById('color2_101').style.color = '#000000'
    document.getElementById('color2_101').style.width = '60px'
    document.getElementById('color2_101').style.border = '0'
    document.getElementById('color2_101').value = 'FFFFFF';
    
    var input3 = document.createElement('INPUT')
    input3.setAttribute('id', 'color2_102')
    input3.setAttribute('TYPE', 'button')
    input3.setAttribute('onclick', 'setCurrentColor("color2_102")')
    document.getElementById('containe2').appendChild(input3)
    document.getElementById('color2_102').style.backgroundColor = ''
    document.getElementById('color2_102').style.color = ''
    document.getElementById('color2_102').style.width = '60px'
    document.getElementById('color2_102').style.border = '0'
    document.getElementById('color2_102').value = 'OFF'
     	
    function setCurrentColor(eleId){
    	document.getElementById("currentcolor").style.backgroundColor = document.getElementById(eleId).style.backgroundColor;
    	document.getElementById("currentcolor").style.color = document.getElementById(eleId).style.color;
    	document.getElementById("currentcolor").value = document.getElementById(eleId).value;
    }
    function clearRowCol(were){
    	var mt = [1, 19, 37, 55, 73, 91, 109, 127, 145, 163, 181, 199, 217, 235, 253, 271]
    	var mb = [18, 36, 54, 72, 90, 108, 126, 144, 162, 180, 198, 216, 234, 252, 270, 288]
    	var ml = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 15, 17, 18]
    	var mr = [271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288]

    	if(were === 'top'){
    		for(var i = 0, len = mt.length; i < len; i++){
	    		document.getElementById("cellid_" + mt[i]).style.backgroundColor = ''
				}
    	} else if(were === 'bot'){
				for(var i = 0, len = mb.length; i < len; i++){
	    		document.getElementById("cellid_" + mb[i]).style.backgroundColor = ''
				}
    	} else if(were === 'left'){
    		for(var i = 0, len = ml.length; i < len; i++){
	    		document.getElementById("cellid_" + ml[i]).style.backgroundColor = ''
				}
    	} else if(were === 'right'){
				for(var i = 0, len = mr.length; i < len; i++){
	    		document.getElementById("cellid_" + mr[i]).style.backgroundColor = ''
				}
    	}
    }
</script>
		<table BORDER=1 CELLSPACING=0 >
		<tr>
			<td>Curr Color</td>
		</tr>
		<tr>
			<td HEIGHT=20px><input id=currentcolor autocomplete="off"></td>
		</tr>
		</table>
		<table BORDER=0 CELLSPACING=0 >
			<thead>
				<tr>
					<th>Movement</th>
				</tr>
			</thead>
		</table>
		<table BORDER=1 CELLSPACING=0 >
			<tbody>
				<tr>
					<td ALIGN=center VALIGN=middle ROWSPAN=2 ><input type="button" value="Left"  onclick="moveLeft();"></td>
					<td ALIGN=center VALIGN=middle ROWSPAN=1 ><input type="button" value="Up"    onclick="moveUp();"></td>
					<td ALIGN=center VALIGN=middle ROWSPAN=2 ><input type="button" value="Right" onclick="moveRight();"></td>
				</tr>
				<tr>
					<td ALIGN=center VALIGN=middle ><input type="button" value="Down" onclick="moveDown();"></td>
				</tr>
			</tbody>
		</table>
		<table BORDER=0 CELLSPACING=0 >
			<thead>
				<tr>
					<th>Clear Columns or rows</th>
				</tr>
			</thead>
		</table>
		<table BORDER=1 CELLSPACING=0 >
			<tbody>
				<tr>
					<td ALIGN=center VALIGN=middle ROWSPAN=2 ><input type="button" value="Left"  onclick="clearRowCol('left');"></td>
					<td ALIGN=center VALIGN=middle ROWSPAN=1 ><input type="button" value="Top"    onclick="clearRowCol('top');"></td>
					<td ALIGN=center VALIGN=middle ROWSPAN=2 ><input type="button" value="Right" onclick="clearRowCol('right');"></td>
				</tr>
				<tr>
					<td ALIGN=center VALIGN=middle ><input type="button" value="Bottom" onclick="clearRowCol('bot');"></td>
				</tr>
			</tbody>
		</table>
	</td></tr>
	</table>
		<TEXTAREA id=outScreen COLS=100%></TEXTAREA>
	
	</body>
</html>
