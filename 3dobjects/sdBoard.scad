$fn = 60;

blankX = 43.3; // 73
blankY = 48.3;
blankZ = 2 ;

blankHoleOffsetX = 2.1;
blankHoleOffsetY = 2.1;

blankMonutHoleSize = 3.65;

holderBlockX = 28.72;
holderBlockY = 29.45;
holderBlockZ = 3.1;

switchBlockX = 3.8;
switchBlockY = 9;
switchBlockZ = 9;


//color("LightGray",.5) boardBlank();
color("LightGray",.5)	boardCover();
	
translate([0,0,10])
	marquee();
	
module marquee(){
	
	difference(){
		translate([0,12,0,])
			rotate([0,0,90])
			plate2Point(8,blankX,2,8); // Screw holder
		
		for(a = [1,-1]){
			translate([a*18,12,0])
				cylinder(d=3.5, h=10, center=true);
		}
	}
	
 	plate4Point(blankY-16,blankY-14,2,6); // Main Block
	
	translate([
		-4,
		10,
		1])
		color("Chartreuse")
		letter("FAT32",4,1);
	
	translate([
		-4,
		5,
		1])
		color("Chartreuse")
		letter("<2GIG",4,1);
	
	
	
	translate([
		(blankX/2 - switchBlockX/2) - 8,
		3.7,
		1])
		color("Chartreuse")
		letter("5V",3.5,1);
	
	translate([
		(blankX/2 - switchBlockX/2) - 10,
		-1.7,
		1])
		color("Chartreuse")
		letter("3.3V",3.5,1);
		
	translate([
		(blankX/2 - switchBlockX/2) - 8.5,
		1,
		1])
		color("Chartreuse")
		rotate([0,0,90])
		plate2Point(1,8,2,1);
		

	
}
	
module boardCover(){
	difference(){
		union(){
			difference(){
				translate([0,0,1.5])
					plate4Point(blankX+2,blankY+2,holderBlockZ+4,6);
				translate([0,0,-1])
					plate4Point(blankX-1,blankY-1,holderBlockZ+4,6);
				translate([0,0,-3.1])
					boardBlank();
			}
			for(a = [[1,1],[-1,1],[1,-1],[-1,-1]]){
				translate([																											// Corner Hole
					a[0]*((blankX/2)-(blankMonutHoleSize/2)-blankHoleOffsetX),
					a[1]*((blankY/2)-(blankMonutHoleSize/2)-blankHoleOffsetY),
					1])
					tube(5,3.5,holderBlockZ+3);
			}
		}
		for(a = [[1,1],[-1,1],[1,-1],[-1,-1]]){
			translate([																											// Corner Hole
				a[0]*((blankX/2)-(blankMonutHoleSize/2)-blankHoleOffsetX),
				a[1]*((blankY/2)-(blankMonutHoleSize/2)-blankHoleOffsetY),
				7])
				screwCutOut(3.5,3.5);
		}
		for(a = [1,-1]){
			translate([a*18,12,2])
				cylinder(d=2.9, h=10, center=true);
		}
		
	}
}

module boardBlank(){
	
		swPosX = (blankX/2 - switchBlockX/2)-1;
		swPosY = 1;
		swPosZ = switchBlockZ/2;
	
	
	difference(){
	
		plate4Point(blankX,blankY,blankZ,6);
		
		for(a = [[1,1],[-1,1],[1,-1],[-1,-1]]){
			translate([																											// Corner Hole
				a[0]*((blankX/2)-(blankMonutHoleSize/2)-blankHoleOffsetX),
				a[1]*((blankY/2)-(blankMonutHoleSize/2)-blankHoleOffsetY),
				0])
				cylinder(h=10, d=4, center=true);
		}
	}
	
	translate([
		0,
		-((blankX/2)-(holderBlockX/2))-3,
		(holderBlockZ/2)+(blankZ/2)-.5]
	)
		cube([holderBlockX,holderBlockY+2,holderBlockZ+1],center=true);
	
	
	translate([swPosX,swPosY,swPosZ])
		cube([switchBlockX,switchBlockY,switchBlockZ],center=true);				// switch blcok
		
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

module triangle(o_len, a_len, depth){
    linear_extrude(height=depth)
    {
        polygon(points=[[0,0],[a_len,0],[0,o_len]], paths=[[0,1,2]]);
    }
}

module letter(l, letter_size = 10, letter_height = 4) {
	// Use linear_extrude() to make the letters 3D objects as they
	// are only 2D shapes when only using text()
	//	letter_height = 4;
	//	letter_size = 10;

	font = "Arial Black:style=Bold" ;
	linear_extrude(height = letter_height) {
		text(l, size = letter_size, font = font, halign = "center", valign = "center", $fn = 16);
	}
}

module tube(od, id, heigth){
	
	difference(){
		cylinder(h=heigth, d=od, center=true);
		cylinder(h=heigth+2, d=id, center=true);
	}
}