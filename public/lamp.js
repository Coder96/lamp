	/******************************************************************************************
	*
	*
	*/
	function Color(cellid){
		document.getElementById(cellid).style.backgroundColor = document.getElementById('currentcolor').style.backgroundColor;
		setOutString();
  }
  /******************************************************************************************
	*
	*
	*/
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
  /******************************************************************************************
	*
	*
	*/
  function rgb2hex(rgb){
 		rgb = rgb.match(/^rgba?[\s+]?\([\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?/i);
 		return (rgb && rgb.length === 4) ? "$" +
  		("0" + parseInt(rgb[1],10).toString(16)).slice(-2) + '_' +
 			("0" + parseInt(rgb[2],10).toString(16)).slice(-2) + '_' +
	  	("0" + parseInt(rgb[3],10).toString(16)).slice(-2) : '';
	}
	function rgb2hex2(rgb) {
    rgb = Array.apply(null, arguments).join().match(/\d+/g);
    rgb = ((rgb[0] << 16) + (rgb[1] << 8) + (+rgb[2])).toString(16);

    // for (var i = rgb.length; i++ < 6;) rgb = '0' + rgb;

    return rgb;
	};
	/******************************************************************************************
	*
	*
	*/
	function hex2rgb(hex) {
    hex = hex.replace(/ |#/g, '');
    if(hex.length === 3) hex = hex.replace(/(.)/g, '$1$1');

    // http://stackoverflow.com/a/6637537/1250044
    hex = hex.match(/../g);    
    return [parseInt(hex[0], 16), parseInt(hex[1], 16), parseInt(hex[2], 16)];
	}
	/******************************************************************************************
	*
	*
	*/
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
	/******************************************************************************************
	*
	*
	*/
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
	/******************************************************************************************
	*
	*
	*/
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
	/******************************************************************************************
	*
	*
	*/
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
	/******************************************************************************************
	*
	*
	*/
	function setCurrentColor(eleId){
		document.getElementById("currentcolor").style.backgroundColor	 = document.getElementById(eleId).style.backgroundColor;
		document.getElementById("currentcolor").style.color = document.getElementById(eleId).style.color;
		document.getElementById("currentcolor").value = document.getElementById(eleId).value;
	}
	/******************************************************************************************
	*
	*
	*/
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
	/******************************************************************************************
	*
	*
	*/
	function loadScreen(fLocation){

		var papaConfig = {
			delimiter: ",",	// auto-detect
			newline: "",	// auto-detect
			quoteChar: '"',
			header: false,
			dynamicTyping: false,
			preview: 0,
			encoding: "",
			worker: false,
			comments: false,
			step: undefined,
			complete: undefined,
			error: undefined,
			download: false,
			skipEmptyLines: true,
			chunk: undefined,
			fastMode: undefined,
			beforeFirstChunk: undefined,
			withCredentials: undefined
		};
		
		var myParsed = Papa.parse(document.getElementById(fLocation).value, papaConfig);
		
		var outStr = '';
		for(x=0;x < 288;x++){
			if(typeof myParsed.data[0][x] === 'undefined') {
				document.getElementById('cellid_' + (x + 1)).style.backgroundColor = '';
			} else {
				if(myParsed.data[0][x].replace(/ /g, '') == '$00_00_00_00'){
					myParsed.data[0][x] = '';
				}
				document.getElementById('cellid_' + (x + 1)).style.backgroundColor = 
					myParsed.data[0][x]
					.replace(/\$/g, '#')
					.replace(/_/g, '')
					.replace(/ /g, '')
					.substr(0,7);
			}
		}
		setOutString()
	}
	/******************************************************************************************
	*
	*
	*/
	function copyToFrame(selectedOption){
		
		var wName = '';
		
		if(selectedOption == "New"){
			var tf = document.getElementById("sCopyToFrame");
			var tf_option = document.createElement("option");
			
			document.getElementById('FrameCounter').value = parseInt(document.getElementById('FrameCounter').value) + 1;
			wName = "Frame " + document.getElementById('FrameCounter').value;
			tf_option.text = wName;
			tf.add(tf_option);
			
			var ff = document.getElementById("sCopyFromFrame");
			var ff_option = tf_option.cloneNode(true);
			ff.add(ff_option);
			
			document.getElementById('sCopyToFrame').value = wName;
			
			var dummy = '<INPUT type="hidden" id="' + wName.replace(/ /g, '_') + '" value="">\n';
			document.getElementById('framesDiv').innerHTML += dummy; 
		} else {
			wName = selectedOption.replace(/ /g, '_');
		}
		document.getElementById(wName.replace(/ /g, '_')).value = document.getElementById('outScreen').value;
		
	}
	/******************************************************************************************
	*
	*
	*/
	function copyFromFrame(selectedOption){
		
		loadScreen(selectedOption.replace(/ /g, '_'));

	}
	/******************************************************************************************
	*
	*
	*/
	/******************************************************************************************
	*
	*
	*/
	function movethoroughFames(direction){
			
		var numberOfFrames = parseInt(document.getElementById('FrameCounter').value);
		
		var startFrame = parseInt(document.getElementById('frameMovementBox').value);
		
		if(direction == 'back'){
			if(startFrame < 2){
				startFrame = 2;
			}
			startFrame = startFrame - 1;
			loadScreen('Frame_' + startFrame);
		} else {
			if(startFrame >= numberOfFrames){
				startFrame = numberOfFrames - 1;
			}
			startFrame = startFrame + 1;
			loadScreen('Frame_' + startFrame);
		}
		
		document.getElementById('frameMovementBox').value = startFrame;
		
	}
	