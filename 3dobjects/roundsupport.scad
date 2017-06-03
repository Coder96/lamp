$fn = 60;

//cylinder(h=5,d=160,center=true);

difference(){
	color("Green") Support();
	difference(){
		translate([2, -2, 2]) scale([.9, .9, 1]) Support();
	  translate([-25, 0, 2]) cube([50,100,20], center=true);
	}
	difference(){
		translate([-2, 2, 2]) scale([.9, .9, 1]) Support();
	  translate([0, -25, 2]) cube([100,50,20], center=true);
	}
//	difference(){
//		Support();
//	  translate([-50, -50 ,1]) cube([50,50,20], center=true);
//	}
}


//cube([1650,2,10],center=ture);

module Support(){
	difference(){
		cylinder(h=10,d=100,center=true);
		translate([0,0,-10]) cube([50,50,20]);
		translate([40,-10,-10]) cube([10,11,20]);
		translate([-10,40,-10]) cube([11,10,20]);
		cylinder(h=12,d=10,center=true);
	}
}