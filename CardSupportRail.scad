
$fn = 60;

m3_hole_d = 3.2;
m3_countersink_depth = 1.2;
m3_countersink_d = 6;

card_sep = 20.32;

makerbeam_w = 15;

plate_thickness = 3;

module plate() {
    translate([-makerbeam_w/2, -makerbeam_w/2, 0])
        cube([makerbeam_w, makerbeam_w, plate_thickness]);
}

module plate_with_screw_hole() {
    difference() {
        plate();
        translate([0, -plate_thickness/2, -2]) {
            cylinder(h=plate_thickness+4, d=m3_hole_d);
        }
        translate([0, -plate_thickness/2, plate_thickness-m3_countersink_depth]) {
            cylinder(h=plate_thickness, d=m3_countersink_d);
        }
    }
}

module angle_brace() {
    translate([plate_thickness, 0, 0]) {
        rotate([90, 0, 270]) {
            linear_extrude(plate_thickness) {
                polygon([[0,0], [makerbeam_w-plate_thickness, 0], [0, makerbeam_w-plate_thickness]]);
            }
        }
    }
}

module bracket() {
    translate([0, 0, makerbeam_w/2]) {
        rotate([90, 0, 0]) {
            rotate([0, 0, 180]) {
                plate_with_screw_hole();
            }
        }
    }
    translate([0, -makerbeam_w/2, 0]) {
        plate_with_screw_hole();
    }
    translate([-makerbeam_w/2, -plate_thickness, plate_thickness]) {
        angle_brace();
    }
    translate([makerbeam_w/2 - plate_thickness, -plate_thickness, plate_thickness]) {
        angle_brace();
    }
}

//plate_with_screw_hole();
//angle_brace();
bracket();
