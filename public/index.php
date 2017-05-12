<html>
	<head>
		<script type="text/javascript" src="jscolor/jscolor.min.js"></script>
		<script type="text/javascript" src="PapaParse-4.3.2/papaparse.min.js"></script>
		<script type="text/javascript" src="lamp.js">	</script>
		<style>
			table { border-collapse:collapse }
		</style>
	</head>
	<body>
  <table name="nTop Level">
  	<tr>
			<td>
				<table BORDER=1 CELLSPACING=0>
					<tr>
						<th>0</th>
					</tr>
<?PHP
	for($y=1;$y <= 18;$y++){ // collums
 		echo('<tr><th WIDTH=20px HEIGHT=40px id=saverowcellid_'. $y .' >'. $y .'</th></tr>');
 	}
?>
				</table>
			</td>
			<td>
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
	 		echo('<td name=tabcel_' . $w .'  id=cellid_' . $z .' ALIGN=center WIDTH=20px HEIGHT=40px onclick="Color(\'cellid_'.$z.'\');"> </td>');
	 	}
	 	echo('</tr>');
	}		
?>
					</tbody>
				</table>
			</td>
			<td VALIGN=top>
				<div hidden><p id="container"></p></div>
				<div><p id="containe2"></p></div>
<script>
	for(var i = 0; i < 300; i++) {
		
		var input = document.createElement('INPUT')
		input.setAttribute('id', 'color_' + i)
		var picker = new jscolor(input)
		picker.fromHSV(360 / 300 * i, 100, 100)
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
	input2.setAttribute('id', 'color2_801')
	input2.setAttribute('TYPE', 'button')
	input2.setAttribute('onclick', 'setCurrentColor("color2_801")')
	document.getElementById('containe2').appendChild(input2)
	document.getElementById('color2_801').style.backgroundColor = '#FFFFFF'
	document.getElementById('color2_801').style.color = '#000000'
	document.getElementById('color2_801').style.width = '60px'
	document.getElementById('color2_801').style.border = '0'
	document.getElementById('color2_801').value = 'FFFFFF';
	
	var input3 = document.createElement('INPUT')
	input3.setAttribute('id', 'color2_802')
	input3.setAttribute('TYPE', 'button')
	input3.setAttribute('onclick', 'setCurrentColor("color2_802")')
	document.getElementById('containe2').appendChild(input3)
	document.getElementById('color2_802').style.backgroundColor = ''
	document.getElementById('color2_802').style.color = ''
	document.getElementById('color2_802').style.width = '60px'
	document.getElementById('color2_802').style.border = '0'
	document.getElementById('color2_802').value = 'OFF'
	
</script>

	<table name="nControls">
		<tbody>
			<tr>
				<td>
					<table name="nCurrent Color" BORDER=1 CELLSPACING=0 >
						<thead>
							<tr>
								<th>Curr Color</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td HEIGHT=20px><input id=currentcolor autocomplete="off"></td>
							</tr>
						</tobdy>
					</table>
					<table name="nMovement" BORDER=1 CELLSPACING=0 >
						<thead>
							<tr>
								<th>Movement</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>
									<table BORDER=0 CELLSPACING=0 >
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
								</td>
							</tr>
						</tbody>
					</table>
					<table name="nClear" BORDER=1 CELLSPACING=0 >
						<thead>
							<tr>
								<th>Clear Columns or rows</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>
									<table BORDER=0 CELLSPACING=0 >
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
								</td>
							</tr>
						<tbody>
					</table>
				</td>
				<td>
					<table name ="nFrameControls" BORDER=0 CELLSPACING=0>
						<tbody>
							<tr>
								<td>
									<table BORDER=1 CELLSPACING=0 >
										<thead>
											<tr>
												<th>Save Frames</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>
													<INPUT type="hidden" id="FrameCounter" value="0">
													<P> Copy to frame:
														<SELECT id="sCopyToFrame" onchange="copyToFrame(this.value);">
															<OPTION selected disabled hidden style='display: none' value=''></OPTION>
															<OPTION>New</OPTION>
														</SELECT>
													</P>
													<P> Copy from frame:
														<SELECT id="sCopyFromFrame" onchange="copyFromFrame(this.value);">
															<OPTION selected disabled hidden style='display: none' value=''></OPTION>
														</SELECT>
														<div id="framesDiv"></div>
													</P>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<table BORDER=1 CELLSPACING=0 >
										<thead>
											<tr>
												<th>Show Frame</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>
													<input id="frameMovementBox" value="1"><br>
													<input type="button" value="Frame Back" onclick="movethoroughFames('back');">
													<input type="button" value="Frame Forward" onclick="movethoroughFames('forward');">
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
		</tbody>
	</table>

			</td>
		</tr>
	</table>

		<LABEL>Output Text</LABEL>
		<BR>
		<TEXTAREA id=outScreen COLS=100%></TEXTAREA>
		<BR>
		<LABEL>Input Text</LABEL>
		<input type="button" value="Load" onclick="loadScreen('inScreen');">
		<BR>
		<TEXTAREA id=inScreen COLS=100%></TEXTAREA>

	</body>
</html>
