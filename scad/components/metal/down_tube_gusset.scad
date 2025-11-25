// Down Tube Gusset
// CNC milled aluminum for NestWorks C500
// Joins two down tube sections at an angle for step-through frame

include <../../config.scad>

// Gusset dimensions
gusset_block_width = 80;
gusset_block_height = 60;
gusset_block_depth = 50;
socket_depth = 35;  // How deep tubes insert into gusset

module down_tube_gusset() {
    half_angle = (180 - down_tube_gusset_angle) / 2;

    difference() {
        // Main block - rounded edges
        hull() {
            for (x = [5, gusset_block_width - 5]) {
                for (y = [5, gusset_block_depth - 5]) {
                    translate([x, y, 0])
                        cylinder(h = gusset_block_height, r = 5);
                }
            }
        }

        // Socket for upper tube section (angled down)
        translate([gusset_block_width/2, gusset_block_depth/2, gusset_block_height])
            rotate([0, 180 - half_angle, 0])
                cylinder(h = socket_depth + epsilon, d = down_tube_od + socket_clearance);

        // Socket for lower tube section (angled up)
        translate([gusset_block_width/2, gusset_block_depth/2, 0])
            rotate([0, half_angle, 0])
                translate([0, 0, -epsilon])
                    cylinder(h = socket_depth + epsilon, d = down_tube_od + socket_clearance);

        // Bolt holes for upper tube - aligned with tube bolt pattern
        translate([gusset_block_width/2, gusset_block_depth/2, gusset_block_height])
            rotate([0, 180 - half_angle, 0])
                translate([0, 0, socket_depth/2]) {
                    for (i = [0:joint_bolt_count-1]) {
                        rotate([0, 0, i * 180])
                            rotate([90, 0, 0])
                                cylinder(h = gusset_block_depth, d = joint_bolt_diameter + 0.5, center = true);
                    }
                }

        // Bolt holes for lower tube - aligned with tube bolt pattern
        translate([gusset_block_width/2, gusset_block_depth/2, 0])
            rotate([0, half_angle, 0])
                translate([0, 0, socket_depth/2]) {
                    for (i = [0:joint_bolt_count-1]) {
                        rotate([0, 0, i * 180])
                            rotate([90, 0, 0])
                                cylinder(h = gusset_block_depth, d = joint_bolt_diameter + 0.5, center = true);
                    }
                }

        // Weight reduction - hollow out center
        translate([gusset_block_width/2, gusset_block_depth/2, gusset_block_height/2])
            sphere(d = 25);
    }
}

// Render for preview
down_tube_gusset();
