 /*
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
*/
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
