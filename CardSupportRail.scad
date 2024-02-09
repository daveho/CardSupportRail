// All dimensions are mm

$fn = 60;

m3_hole_d = 3.2;
m3_countersink_depth = 1.2;
m3_countersink_d = 6;

card_sep = 20.32;

makerbeam_w = 15;

plate_thickness = 2.5;

// diameter for a #6 screw where we want it to cut
// threads when screwed in
n6_hole_d = 3.09;

// "buffer" distance on either side of cards
buffer = 0.5 * makerbeam_w;

// The backplane I'm making this for only has two slots.
// So we don't need the rail to be very long.
rail_len = card_sep + 2*buffer;

// setback of center of card bracket screw slot from edge of rail
// (measured 5mm, making slightly more to allow for some error)
slot_hole_setback = 5.2;

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

module rail() {
        cube([rail_len, makerbeam_w, plate_thickness]);
}

module rail_with_screw_holes() {
    translate([-rail_len/2, -makerbeam_w/2, 0]) {
        difference() {
            rail();
            
            translate([buffer, slot_hole_setback, -2]) {
                cylinder(h=plate_thickness + 4, d=n6_hole_d);
            }
            
            translate([buffer + card_sep, slot_hole_setback, -2]) {
                cylinder(h=plate_thickness + 4, d=n6_hole_d);
            }
        }
    }
}

module support_rail_assembly() {
    translate([-rail_len/2, 0, 0]) {
        translate([-makerbeam_w, 0, plate_thickness]) {
            rotate([90, 0, 90]) {
                bracket();
            }
        }
    }
    
    translate([rail_len/2, 0, 0]) {
        translate([makerbeam_w, 0, plate_thickness]) {
            rotate([90, 0, -90]) {
                bracket();
            }
        }
    }
    
    rail_with_screw_holes();
}

//plate_with_screw_hole();
//angle_brace();
//bracket();
//rail();
//rail_with_screw_holes();

// This is upside-down from the way it should be printed
// (it was designed thinking about how it will be used)
//support_rail_assembly();

// Oriented correctly for printing
rotate([180, 0, 0]) {
    support_rail_assembly();
}
