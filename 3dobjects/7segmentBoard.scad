$fn = 60;

blankX = 25.5; // 73
blankY = 38.1;
blankZ = 2 ;

blankHoleOffsetX = .8;
blankHoleOffsetY = .8;

blankMonutHoleSize = 3.3;

segmentBlockX = 19.5;
segmentBlockY = 26;
segmentBlockZ = 8.1;

//color("LightGray",.5) boardBlank();

translate([0,0,(blankZ/2)+(segmentBlockZ/2)])
	boardCover();

	
module boardCover(){
	
	difference(){
		plate4Point(blankX+12,blankY+4,segmentBlockZ,6);
		
		translate([0,0,-((blankZ/2)+(segmentBlockZ/2))-.1])
			boardBlank();
		
		for(a = [[1,1],[-1,1],[1,-1],[-1,-1]]){
			translate([																											// Corner Hole
				a[0]*((blankX/2)-(blankMonutHoleSize/2)-blankHoleOffsetX),
				a[1]*((blankY/2)-(blankMonutHoleSize/2)-blankHoleOffsetY),
				(blankZ)+(segmentBlockZ)-3])
				screwCutOut(6,3.5);
		}
		translate([0,0,-9])
		for(a = [[1,1,-1,1],[1,-1,-1,-1]]){
			hull(){
				translate([																											// Corner Hole
					a[0]*((blankX/2)-(blankMonutHoleSize/2)-blankHoleOffsetX),
					a[1]*((blankY/2)-(blankMonutHoleSize/2)-blankHoleOffsetY),
					(blankZ)+(segmentBlockZ)-3])
					cylinder( h = segmentBlockZ-3, d1 = 2.5, d2 = 1, center = true);
				translate([																											// Corner Hole
					a[2]*((blankX/2)-(blankMonutHoleSize/2)-blankHoleOffsetX),
					a[3]*((blankY/2)-(blankMonutHoleSize/2)-blankHoleOffsetY),
					(blankZ)+(segmentBlockZ)-3])
					cylinder( h = segmentBlockZ-3, d1 = 2.5, d2 = 1, center = true);
			}
		}
	}
	rotate([0,0,-90]){
		translate([0,14,1])
			letter("Curr",6);
 		translate([0,-14,1])
			letter("Step",6);
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

module boardBlank(){

	
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
	
	translate([0,0,(segmentBlockZ/2)+(blankZ/2)])
		cube([segmentBlockX,segmentBlockY,segmentBlockZ+1],center=true);
	
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
	font = "Bitstream Vera Sans:style=Bold" ;
	linear_extrude(height = letter_height) {
		text(l, size = letter_size, font = font, halign = "center", valign = "center", $fn = 16);
	}
}

