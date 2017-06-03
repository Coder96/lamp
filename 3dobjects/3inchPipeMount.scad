
$fn = 90;

$outerDiamiter = 90;
$InnerDiamiter = 77;


difference(){
	union(){
//		translate([0,30,-30.5],center=true)
//			cylinder(h=5,d=152.4,center=true);
		cylinder(h=50,d=$InnerDiamiter,center=true); // Inner diamiter
		translate([0,0,-20],center=true)
			cylinder(h=30,d=$outerDiamiter,center=true); // Outdide diamiter
	}
	cylinder(h=500,d=$InnerDiamiter-5,center=true); // Inner diamiter cut out

	difference(){ // Slot cut out
		translate([0,0,-27])
			cylinder(h=22,d=$outerDiamiter+20,center=true);
		translate([0,-35,-22])
			cube([180,40,22],center=true);
		translate([0,35,-22])
			cube([17,20,22],center=true);
	}

}



//translate([0,40,-20])
//	cube([2,9,20],center=true);

//translate([0,-25,-28])
//	support();
rotate([0,0,51])
	translate([0,-25,-28])
		support();
rotate([0,0,-51])
	translate([0,-25,-28])
		support();
translate([0,25,-28])
	rotate([0,0,180])
		support();


module support(){
	difference(){
		hull(){
			cylinder(h=10,d=10,center=true);
			translate([7,-10,0])
				cylinder(h=10,d=3,center=true);
			translate([-7,-10,0])
				cylinder(h=10,d=3,center=true);
		}
		translate([0,-4,0])
			cylinder(h=20,d=7,center=true);
	}
}