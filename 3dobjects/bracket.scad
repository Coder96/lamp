$fn = 60;


woodThickness = 20;
screwHeadDiamiter = 12.5;
screwShaftDiamiter = 5.5;

baseWidth = 15;
baseLength = 60;
basethickness = 4;

wedgeLength = 15;
spacing = (baseLength/2) - (wedgeLength/2) - 3 ;

difference(){
	union(){
		plate4Point(baseLength,baseWidth,basethickness,6);
		
		hull(){
			for(a = [[spacing,0],[-spacing,180]]){
				translate([a[0],0,6.9])
					rotate([0,0,a[1]])
					wedge(wedgeLength, 10, baseWidth);
			}
		}
	}
		for(a = [[spacing,0],[-spacing,180]]){
				translate([a[0],0,6.9])
			//		rotate([0,0,a[1]])
					screwCutOut(screwHeadDiamiter, screwShaftDiamiter);

		}
		translate([0,0,20+(basethickness/2)])
			cube([woodThickness,40,40],center=true);
}
////////////////////////////////////////////////////////////////////////////////////////////////////
module wedge(o_len, a_len, width){
	rotate([0,270,270])
		translate([0,0,-1*(width/2)])
		linear_extrude(height=width){
			translate([-1*(a_len/2),-1*(o_len/2),0])
			polygon(points=[[0,0],[a_len,0],[0,o_len]], paths=[[0,1,2]]);
		}
}
////////////////////////////////////////////////////////////////////////////////////////////////////
module screwCutOut(headDiamitor, shaftDiamitor){

	cylinder(h=10, d=headDiamitor, center=true);
	translate([0,0,-9])
		cylinder(h=10, d=shaftDiamitor, center=true);

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
