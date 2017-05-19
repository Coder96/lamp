<script> 

	function search(){
		var parser = new DOMParser();
		var xmlDoc = parser.parseFromString(document.getElementById('xmlbox').value, "text/xml");
		
		console.log(xmlDoc.evaluate(document.getElementById('path').value, xmlDoc, null, 2, null));
		
	}
</script>


<TEXTAREA id=xmlbox COLS=100%>
<?xml version="1.0" encoding="UTF-8"?>
<animation>
	<frameCounter>2</frameCounter>
	<frames>
		<frame1> <!-- This block will repeat for each frame -->
			<picture> <!-- This is each pixel $00_00_00_00, ... -->
				<![CDATA[ $11_00_00_00, 
				]]>
			</picture>
			<pause>1000</pause> <!-- microseconds -->
		</frame1>
		<frame2> <!-- This block will repeat for each frame -->
			<picture> <!-- This is each pixel $00_00_00_00, ... -->
				<![CDATA[ $00_00_00_00, 
				]]>
			</picture>
			<pause>1000</pause> <!-- microseconds -->
		</frame2>
	</frames>
</animation>
</TEXTAREA>
<br>


<input id="path" value=""><br>
<input type="button" value="run" onclick="search();">