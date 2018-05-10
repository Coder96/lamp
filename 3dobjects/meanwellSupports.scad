$fn = 60;

bottomSupport();

translate([-0,-30,0])
	topSupport();

translate([35,-50,.65])
	rotate([90,0,0])
	wireClip(8);

translate([35,-65,.65])
	rotate([90,0,0])
	wireClip(8);

translate([25,-75,4.15])
	rotate([90,0,0])
	terminalCover();


module terminalCover(){
	
	translate([3,0,0])
		cube([41,15,2],center=true); //top
	
//	translate([3,-6.5,-1])
//		cube([41,2,4],center=true); //front gard
	translate([3,-6.5,-1])
		rotate([90,0,0])
		plate4Point(41,2,2,3);
	
	translate([-16.5,0,-11])
		cube([2,15,24],center=true);	//virtcal
	
	translate([-21,-5.5,-20])
		cube([10,4,6],center=true);	// coner
	translate([-18,5.5,-20])
		cube([4,4,6],center=true);	// corner

	difference(){
		translate([-21,0,-20])
			plate4Point(10,15,6,4);
		translate([-21,0,-15])
			screwCutOut(6.5, 3.5);
	}
	translate([-17.5,-5.5,-17])
		rotate([90,-90,0])
		triangle(8.49, 18, 2);
		
	translate([-11.5,-6.5,-11])
		rotate([90,0,0])
		plate4Point(12,24,2,4);
}

module wireClip(cWidth){
	
	difference(){
		union(){
			cube([18,cWidth,10],center=true);
			translate([-8.5,0,-5])
				rotate([90,0,0])
				plate2Point(5,20,cWidth,10);
		}
		translate([-8.5,0,-9])
			rotate([90,0,0])
			plate2Point(5,20,12,7);
		translate([-8.5,0,-10])
			cube([12,12,10], center=true);
		translate([2,0,7])
			screwCutOut(6.5, 3.8);
			
		translate([15,0,0])
			cube([12,12,20],center=true);
	}
}

module supportBase(){
	// Bottom plate
	difference(){
		translate([-12.5,0,0])
			plate4Point(135,20,6.7,6);
		translate([40,0,5])
			screwCutOut(12, 5.5);
		translate([-40,0,5])
			screwCutOut(12, 5.5);
// Wire Hold Down hole
		translate([-63,0,5])
			screwCutOut(3, 3);
	}

	// wire hoild down side support
	translate([-60,5,2])
		rotate([0,0,90])
		plate2Point(5,13,6,2);
	// wire hoild down side support
	translate([-60,-5,2])
		rotate([0,0,90])
		plate2Point(5,13,6,2);



	// side
	translate([52,0,5])
		plate2Point(5,20,10,6);

	// side
	color("blue")
	translate([-52,0,5])
		plate2Point(5,20,10,6);
}

module topSupport(){

	supportBase();

	difference(){
		translate([-43,-30,0]) color("orange")
			plate4Point(74,40,6.7,4);
		color("red")
			translate([-43,-18.30,5])
			screwCutOut(3, 3);
		
		color("green")
			translate([-54,-18,5])
			screwCutOut(3, 3);
	}
			
	translate([-75,-10,0])
		plate4Point(10,10,6.7,4);

		translate([-11,-10,0]) 
		plate4Point(10,10,6.7,4);
		
		
//	color("blue")
//	translate([-52,0,18])
//		plate2Point(5,20,32,6);
	
		scale([.5,1,1])
		translate([-52,-40,0])
		rotate([0,0,180])
		virtSupport();
	
}

module virtSupport(){

		// suport virtcal
	translate([0,8,7])
		rotate([90,0,90])
		plate2Point(5,15,70,4);
	// 
	color("red")
	translate([0,6,3.5])
		rotate([34,0,0])
		cube([70,2,1],center=true);
		
	hull(){
	// suport angle
	translate([0,6.2,12.3])
		rotate([90,-44,90])
		plate2Point(5,5,70,3);


	// suport top
	translate([0,5,14])
		cube([70,2,1],center=true);
	translate([0,5,13.5])
		cube([70,2,1],center=true);
	translate([0,7,14])
		cube([70,2,1],center=true);
	}

}


module bottomSupport(){

	supportBase();
	
	virtSupport();
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

/**
 * Simple triangles library
 *
 * Authors:
 *   - Eero 'rambo' af Heurlin 2010-
 *
 * License: LGPL 2.1
 */


/**
 * Standard right-angled triangle
 *
 * @param number o_len Lenght of the opposite side
 * @param number a_len Lenght of the adjacent side
 * @param number depth How wide/deep the triangle is in the 3rd dimension
 * @todo a better way ?
 */
module triangle(o_len, a_len, depth)
{
    linear_extrude(height=depth)
    {
        polygon(points=[[0,0],[a_len,0],[0,o_len]], paths=[[0,1,2]]);
    }
}

/**
 * Standard right-angled triangle (tangent version)
 *
 * @param number angle of adjacent to hypotenuse (ie tangent)
 * @param number a_len Lenght of the adjacent side
 * @param number depth How wide/deep the triangle is in the 3rd dimension
 */
module a_triangle(tan_angle, a_len, depth)
{
    linear_extrude(height=depth)
    {
        polygon(points=[[0,0],[a_len,0],[0,tan(tan_angle) * a_len]], paths=[[0,1,2]]);
    }
}

