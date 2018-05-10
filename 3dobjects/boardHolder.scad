$fn = 60;

blankX = 109.3; // 73
blankY = 140;
blankZ = 2 ;

	holeOffsetX = 1.6;
	holeOffsetY = 2.6;

//# translate([0,0,3]) boardBlank();

boardHolder();

//translate([70.2,-45,7])
//	wireClip(6);


/*
testwidth = 102;
testlength = (blankX/2)+11.7;

	translate([testwidth/2,-testlength,0])
	color("RED")
	cylinder(d=2,h=10,center=true);

	translate([-testwidth/2,-testlength,0])
	color("GREEN")
	cylinder(d=2,h=10,center=true);
*/
////////////////////////////////////////////////////////////////////////////////////////////////////
module boardHolder(){

	tubeOD = 9;

	translate([0,(blankY/2)+8,0])
		endPlate();
		
	translate([0,-((blankY/2)+8),0])
		endPlate();
		
	difference(){
		translate([0,0,0])
			plate4Point(blankX+4,blankY+4,6,4);
			
		translate([0,0,1])
			plate4Point(blankX-1,blankY,10,4);	
	}
	
	difference(){
		translate([-blankX/2,-blankY/2,-3])																// Upper Right Corner DB9
			rotate([0,0,0]) 
			triangle(15, 15, 6);	
		translate([-(((blankX/2)-2)-holeOffsetX),-(((blankY/2)-1)-holeOffsetY),2])
			screwCutOut(2.8, 2.8);
	}
	difference(){
		union(){
//			translate([-(((blankX/2)-2)-holeOffsetX)+17,-(((blankY/2)-1)-holeOffsetY)+62,-1]) // db9
//				cube([45,4,4],center=true);
			translate([0,-(((blankY/2)-1)-holeOffsetY)+62,-1]) // db9
				cube([blankX,4,4],center=true);
			translate([-(((blankX/2)-2)-holeOffsetX)+17,-(((blankY/2)+14)-holeOffsetY)+62,-1])	// rs232
				cube([45,4,4],center=true);
			translate([-(((blankX/2)-2)-holeOffsetX)+41,-(((blankY/2)-1)-holeOffsetY)+30,-1])
				cube([4,60,4],center=true);
				
			translate([-(((blankX/2)-2)-holeOffsetX)+41,-(((blankY/2)-1)-holeOffsetY),0])
				tube(tubeOD, 2.9, 6);
			translate([-(((blankX/2)-2)-holeOffsetX),-(((blankY/2)-1)-holeOffsetY)+62,0])
				tube(tubeOD, 2.9, 6);
			translate([-(((blankX/2)-2)-holeOffsetX)+41,-(((blankY/2)-1)-holeOffsetY)+62,0])
				tube(tubeOD, 2.9, 6);
			translate([-(((blankX/2)-2)-holeOffsetX)+8.3,-(((blankY/2)+14)-holeOffsetY)+62,0])	// rs232
				tube(tubeOD, 2.9, 6);
			translate([-(((blankX/2)-2)-holeOffsetX)+33.3,-(((blankY/2)+14)-holeOffsetY)+62,0])
				tube(tubeOD, 2.9, 6);
		}
		translate([-(((blankX/2)-2)-holeOffsetX)+41,-(((blankY/2)-1)-holeOffsetY),2])
			screwCutOut(2.8, 2.8);
		translate([-(((blankX/2)-2)-holeOffsetX),-(((blankY/2)-1)-holeOffsetY)+62,2])
			screwCutOut(2.8, 2.8);
		translate([-(((blankX/2)-2)-holeOffsetX)+41,-(((blankY/2)-1)-holeOffsetY)+62,2])
			screwCutOut(2.8, 2.8);
		translate([-(((blankX/2)-2)-holeOffsetX)+8.3,-(((blankY/2)+14)-holeOffsetY)+62,2]) // rs232
			screwCutOut(2.8, 2.8);
		translate([-(((blankX/2)-2)-holeOffsetX)+33.3,-(((blankY/2)+14)-holeOffsetY)+62,2])
			screwCutOut(2.8, 2.8);
	}
	
	difference(){
		translate([blankX/2,-blankY/2,-3])																// Upper Left 7 Segment
			rotate([0,0,90]) 
			triangle(15, 15, 6);	
		translate([((blankX/2)-2)-holeOffsetX,-(((blankY/2)-1)-holeOffsetY),2])
			screwCutOut(2.8, 2.8);
	}			
	difference(){
		union(){
			translate([((blankX/2)-2)-holeOffsetX-13,-(((blankY/2)-1)-holeOffsetY)+20.33,-1])
				cube([35,4,4],center=true);
			translate([((blankX/2)-2)-holeOffsetX-33,-(((blankY/2)-1)-holeOffsetY)+9.33,-1])
				cube([4,25,4],center=true);
			translate([((blankX/2)-2)-holeOffsetX-33,-(((blankY/2)-1)-holeOffsetY),0])
				tube(tubeOD, 2.9, 6);
			translate([((blankX/2)-2)-holeOffsetX,-(((blankY/2)-1)-holeOffsetY)+20.33,0])
				tube(tubeOD, 2.9, 6);
			translate([((blankX/2)-2)-holeOffsetX-33,-(((blankY/2)-1)-holeOffsetY)+20.33,0])
				tube(tubeOD, 2.9, 6);
		}
		translate([((blankX/2)-2)-holeOffsetX-33,-(((blankY/2)-1)-holeOffsetY),2])
			screwCutOut(2.8, 2.8);
		translate([((blankX/2)-2)-holeOffsetX,-(((blankY/2)-1)-holeOffsetY)+20.33,2])
			screwCutOut(2.8, 2.8);
		translate([((blankX/2)-2)-holeOffsetX-33,-(((blankY/2)-1)-holeOffsetY)+20.33,2])
			screwCutOut(2.8, 2.8);
	}
	
	
	difference(){
		translate([blankX/2,blankY/2,-3])														// Lower Right
			rotate([0,0,180]) 
			triangle(15, 15, 6);	
		translate([((blankX/2)-2)-holeOffsetX,(((blankY/2)-1)-holeOffsetY),2])
			screwCutOut(2.8, 2.8);
	}
	difference(){
		translate([-blankX/2,blankY/2,-3])														// Lower Left SD Card
			rotate([0,0,270]) 
			triangle(15, 15, 6);	
		translate([-(((blankX/2)-2)-holeOffsetX),(((blankY/2)-1)-holeOffsetY),2])
			screwCutOut(2.8, 2.8);
	}
	difference(){
		union(){
		translate([-(((blankX/2)-2)-holeOffsetX)+14,(((blankY/2)-1)-holeOffsetY)-40.6,-1])
			cube([39,4,4],center=true);
		translate([-(((blankX/2)-2)-holeOffsetX)+35.5,(((blankY/2)-1)-holeOffsetY)-20,-1])
			cube([4,45,4],center=true);
		translate([-(((blankX/2)-2)-holeOffsetX)+35.5,(((blankY/2)-1)-holeOffsetY),0])
			tube(tubeOD, 2.9, 6);
		translate([-(((blankX/2)-2)-holeOffsetX),(((blankY/2)-1)-holeOffsetY)-40.6,0])
			tube(tubeOD, 2.9, 6);
		translate([-(((blankX/2)-2)-holeOffsetX)+35.5,(((blankY/2)-1)-holeOffsetY)-40.6,0])
			tube(tubeOD, 2.9, 6);
		}
			translate([-(((blankX/2)-2)-holeOffsetX)+35.5,(((blankY/2)-1)-holeOffsetY),2])
			screwCutOut(2.8, 2.8);
		translate([-(((blankX/2)-2)-holeOffsetX),(((blankY/2)-1)-holeOffsetY)-40.6,2])
			screwCutOut(2.8, 2.8);
		translate([-(((blankX/2)-2)-holeOffsetX)+35.5,(((blankY/2)-1)-holeOffsetY)-40.6,2])
			screwCutOut(2.8, 2.8);
	}
	
	for(a = [-1,1]){
		translate([0,a*(blankY/2),0])
			rotate([0,0,90])
			plate2Point(0,blankX,6,4);
	}
	
	translate([(blankX/2)+14,-60,-1])
		wireClipSupport();
	translate([(blankX/2)+14,25,-1])
		wireClipSupport();
//	translate([(blankX/2)+14,60,-1])
//		wireClipSupport();
	
}
////////////////////////////////////////////////////////////////////////////////////////////////////
module wireClipSupport(){
	
	width = 20;
	
	difference(){
		plate4Point(23,width,4,6);
		translate([0,5,5])
			screwCutOut(8.25, 5.5);
		translate([-.5,-5,5])
			screwCutOut(2.9, 2.9);
	}
	translate([-11,0,0])
		cube([5,width,4],center=true);
	
	// wire hoild down side support
	translate([0,-1,2])
		rotate([0,0,90])
		plate2Point(width/2,6,6,2);
	// wire hoild down side support
	translate([0,-9,2])
		rotate([0,0,90])
		plate2Point(width/2,6,6,2);
}
////////////////////////////////////////////////////////////////////////////////////////////////////
module endPlate(){
	
	difference(){
		translate([0,0,-1])
			plate4Point(blankX-6,18,4,6);

	translate([(blankX/4)-2,0,4]) //17.5
		rotate([0,0,90])
		screwSlot(12, 5.5, (blankX/2)-10);

	translate([-((blankX/4)-2),0,4])
		rotate([0,0,90])
		screwSlot(12, 5.5, (blankX/2)-10);

	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////
module wireClip(cWidth){
	
	difference(){
		
		union(){
			translate([-2,0,0])
				cube([14,cWidth,10],center=true);
			translate([-8.5,0,-5])
				rotate([90,0,0])
				plate2Point(5,20,cWidth,10);
			translate([5,0,-5])
				rotate([90,0,0])
				plate2Point(5,20,cWidth,10);

		}
		
		translate([-8.5,0,-11])
			rotate([90,0,0])
			plate2Point(5,20,12,6);
		translate([5.5,0,-10])
			rotate([90,0,0])
			plate2Point(5,20,12,6);
		
		translate([0,0,-10])
			cube([40,40,10], center=true);
		
		translate([-2,0,7])
			screwCutOut(6.5, 3.8);
			
//		translate([15,0,0])
//			cube([12,12,20],center=true);
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////
module plate2Point(x,y,z,d){
	hull(){
		color("green") translate([0 ,(y/2) -(d/2),0]) cylinder(h=z, d=d, center=true);
		color("blue")  translate([0 ,-(y/2)+(d/2),0]) cylinder(h=z, d=d, center=true);
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////
module plate4Point(x,y,z,d){
	hull(){
		color("green") translate([(x/2)-(d/2) ,(y/2) -(d/2),0]) cylinder(h=z, d=d, center=true);
		color("blue")  translate([(x/2)-(d/2) ,-(y/2)+(d/2),0]) cylinder(h=z, d=d, center=true);
		color("red")   translate([-(x/2)+(d/2),(y/2) -(d/2),0]) cylinder(h=z, d=d, center=true);
		color("grey")  translate([-(x/2)+(d/2),-(y/2)+(d/2),0]) cylinder(h=z, d=d, center=true);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
module screwCutOut(headDiamitor, shaftDiamitor){

	cylinder(h=10, d=headDiamitor, center=true);
	translate([0,0,-9])
		cylinder(h=10, d=shaftDiamitor, center=true);

}
////////////////////////////////////////////////////////////////////////////////////////////////////
module screwSlot(headDiamitor, shaftDiamitor, slotWidth){

	plate2Point(0,slotWidth,10,headDiamitor);
	translate([0,0,-9])
		plate2Point(0,slotWidth-shaftDiamitor,10,shaftDiamitor);

}
////////////////////////////////////////////////////////////////////////////////////////////////////
module boardBlank(){
	
	difference(){
		cube([blankX,blankY,blankZ],center=true);
		
		translate([((blankX/2)-2)-holeOffsetX,((blankY/2)-1)-holeOffsetY,0]) color("green")
			cylinder(h=10, d=4, center=true);
		
		mirror([90,0,0])
			translate([((blankX/2)-2)-holeOffsetX,((blankY/2)-1)-holeOffsetY,0]) color("green")
			cylinder(h=10, d=4, center=true);
		
		translate([((blankX/2)-2)-holeOffsetX,-(((blankY/2)-1)-holeOffsetY),0]) color("green")
			cylinder(h=10, d=4, center=true);
		
	mirror([90,0,0])
		translate([((blankX/2)-2)-holeOffsetX,-(((blankY/2)-1)-holeOffsetY),0]) color("green")
		cylinder(h=10, d=4, center=true);
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////
module triangle(o_len, a_len, depth){
    linear_extrude(height=depth)
    {
        polygon(points=[[0,0],[a_len,0],[0,o_len]], paths=[[0,1,2]]);
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////
module tube(od, id, heigth){
	
	difference(){
		cylinder(h=heigth, d=od, center=true);
		cylinder(h=heigth+2, d=id, center=true);
	}
}