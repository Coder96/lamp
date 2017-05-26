<html>
	<head>
		<script type="text/javascript" src="jscolor/jscolor.min.js"></script>
		<script type="text/javascript" src="PapaParse-4.3.2/papaparse.min.js"></script>
		<script type="text/javascript" src="lamp.js">	</script>

		<script type="text/javascript" src="lamp2.js" defer></script>

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
 		echo('<tr><th WIDTH=20px HEIGHT=40px id=saverowcellid_'. $y .' >'. $y .'</th></tr>
');
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
 		echo('<th id=savecolcellid_'. $y .' >'. sprintf("%003s",$y) .'</th>
');
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
	 		echo('<td name=tabcel_' . $w .'  id=cellid_' . $z .' ALIGN=center WIDTH=20px HEIGHT=40px onclick="Color(\'cellid_'.$z.'\');"> </td>
');
	 	}
	 	echo('</tr>
');
	}		
?>
					</tbody>
				</table>
			</td>
			<td VALIGN=top>
				<div hidden><p id="container"></p></div>
				<div><p id="containe2"></p></div>
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
																<label>MilliSecond</label>
																<input id="frameMicroseconds" value="1000"><br>
																<INPUT type="hidden" id="FrameCounter" value="0">
																<p> Copy to frame:
																	<SELECT id="sCopyToFrame" onchange="copyToFrame(this.value);">
																		<OPTION selected disabled hidden style='display: none' value=''></OPTION>
																		<OPTION>New</OPTION>
																	</SELECT>
																</P>
																<p> Copy from frame:
																	<SELECT id="sCopyFromFrame" onchange="copyFromFrame(this.value);">
																		<OPTION selected disabled hidden style='display: none' value=''></OPTION>
																	</SELECT>
																	<div id="framesDiv"></div>
																	<div id="framesPauseDiv"></div>
																</p>
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
						<tr>
							<td COLSPAN=2>
								<LABEL>Description</LABEL>
								<input id="description" value=""><br>
								<LABEL>XML Stream</LABEL>
								<input type="button" value="ImportXML &uarr;" onclick="importXML();">
								<input type="button" value="ExportXML &darr;" onclick="exportXML();">
								<br>
								<TEXTAREA id=xmlstream COLS=100%></TEXTAREA>
							</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
	</table>

		<LABEL>Working Text</LABEL>
		<BR>
		<TEXTAREA id=outScreen COLS=100%></TEXTAREA>
		<BR>
		<LABEL>Input Text</LABEL>
		<input type="button" value="Load" onclick="loadScreen('inScreen');">
		<BR>
		<TEXTAREA id=inScreen COLS=100%></TEXTAREA>

	</body>
</html>
