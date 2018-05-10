$fn = 60;

blankX = 51;
blankY = 72.5;
blankZ = 2 ;

blankMonutHoleSize = 3.55;
blankHoleOffsetX = 3.3;
blankHoleOffsetY = 3.3;

blankHoleSpacing = 18.52;

//translate([0,0,-3]) boardBlank();

cover();

translate([0,15,6])
	color("Orange") 
	sign();

module sign(){
	

	difference(){
		union(){
			plate4Point(40,25,2,6);											//
			translate([0,6,0])
			rotate([0,0,90])
				plate2Point(40,52,2,8);										//
		}
		translate([22,6,0])
			cylinder(d=4, h=10, center=true);
		translate([-22,6,0])
			cylinder(d=4, h=10, center=true);
	}
	
	translate([0, 6, -1])  letter("9600");
	translate([0, -6, -1])  letter("8N1");

		
}

module cover(){

	coverHeight = 7;

	difference(){
		union(){
			for(a =[[1,1],[-1,1],[1,-1],[-1,-1]]){														// Support Tubes
				
				translate([																											// Corner Hole
					a[0]*((blankX/2)-(blankMonutHoleSize/2)-blankHoleOffsetX),
					a[1]*((blankY/2)-(blankMonutHoleSize/2)-blankHoleOffsetY),
					0])
					tube(blankMonutHoleSize+4,blankMonutHoleSize,coverHeight);
					
				translate([																											// Inside Hole
					a[0]*((blankX/2)-(blankMonutHoleSize/2)-blankHoleOffsetX),
					a[1]*((blankY/2)-(blankMonutHoleSize/2)-blankHoleOffsetY - blankHoleSpacing),
					0])
					tube(6,2.9,coverHeight);
			}
			
			difference(){
				plate4Point(blankX+4,blankY+4,coverHeight,6);						// Body
				translate([0,0,-5])
					boardBlank();																					// Ports Cutout
				translate([0,0,-3])
					plate4Point(blankX,blankY,coverHeight+2,6);							// Cutout
			}
		}
		for(a =[[1,1],[-1,1],[1,-1],[-1,-1]]){												// Through Holes
			translate([																											// Corner Hole
			a[0]*((blankX/2)-(blankMonutHoleSize/2)-blankHoleOffsetX),
			a[1]*((blankY/2)-(blankMonutHoleSize/2)-blankHoleOffsetY),
			6])
			screwCutOut(6,4);
				
//			translate([																											// Inside Hole
//				a[0]*((blankX/2)-(blankMonutHoleSize/2)-blankHoleOffsetX),
//				a[1]*((blankY/2)-(blankMonutHoleSize/2)-blankHoleOffsetY - blankHoleSpacing),
//				-4])
//				cylinder(h=6, d=2.85, center=true);
		}
		
		translate([22,21,0])
			cylinder(d=2.9, h=10,center=true);
		translate([-22,21,0])
			cylinder(d=2.9, h=10,center=true);
		
	}
}

module tube(od, id, heigth){
	
	difference(){
		cylinder(h=heigth, d=od, center=true);
		cylinder(h=heigth+2, d=id, center=true);
	}
}

module plate2Point(x,y,z,d){
	hull(){
		color("green") translate([0 ,(y/2) -(d/2),0]) cylinder(h=z, d=d, center=true);
		color("blue")  translate([0 ,-(y/2)+(d/2),0]) cylinder(h=z, d=d, center=true);
	}
}

module plate4Point(x,y,z,d){
	hull(){
		color("green") translate([(x/2)-(d/2) ,(y/2) -(d/2),0]) cylinder(h=z, d=d, center=true);
		color("blue")  translate([(x/2)-(d/2) ,-(y/2)+(d/2),0]) cylinder(h=z, d=d, center=true);
		color("red")   translate([-(x/2)+(d/2),(y/2) -(d/2),0]) cylinder(h=z, d=d, center=true);
		color("grey")  translate([-(x/2)+(d/2),-(y/2)+(d/2),0]) cylinder(h=z, d=d, center=true);
	}
}
module screwCutOut(headDiamitor, shaftDiamitor){

	cylinder(h=10, d=headDiamitor, center=true);
	translate([0,0,-9])
		cylinder(h=10, d=shaftDiamitor, center=true);

}
module screwSlot(headDiamitor, shaftDiamitor, slotWidth){

	plate2Point(0,slotWidth,10,headDiamitor);
	translate([0,0,-9])
		plate2Point(0,slotWidth-shaftDiamitor,10,shaftDiamitor);

}

module boardBlank(){
	
	
	
	difference(){
		cube([blankX,blankY,blankZ],center=true); 												// Circuit Board Blank
		
		for(a =[[1,1],[-1,1],[1,-1],[-1,-1]]){
			
			translate([																											// Corner Hole
				a[0]*((blankX/2)-(blankMonutHoleSize/2)-blankHoleOffsetX),
				a[1]*((blankY/2)-(blankMonutHoleSize/2)-blankHoleOffsetY),
				0])
				cylinder(h=10, d=4, center=true);
				
			translate([																											// Inside Hole
				a[0]*((blankX/2)-(blankMonutHoleSize/2)-blankHoleOffsetX),
				a[1]*((blankY/2)-(blankMonutHoleSize/2)-blankHoleOffsetY - blankHoleSpacing),
				0])
				cylinder(h=10, d=4, center=true);
			
		}
	}
	
	translate([0,(-20.5)+2,7.5]) 																				// db9 Blank
		difference(){
			cube([32,32,13],center=true);
			cube([35,5,15],center=true);
		}
	
}

module triangle(o_len, a_len, depth){
    linear_extrude(height=depth)
    {
        polygon(points=[[0,0],[a_len,0],[0,o_len]], paths=[[0,1,2]]);
    }
}

module letter(l) {
	// Use linear_extrude() to make the letters 3D objects as they
	// are only 2D shapes when only using text()
	letter_height = 4;
	letter_size = 10;
	font = "Bitstream Vera Sans:style=Bold" ;
	linear_extrude(height = letter_height) {
		text(l, size = letter_size, font = font, halign = "center", valign = "center", $fn = 16);
	}
}