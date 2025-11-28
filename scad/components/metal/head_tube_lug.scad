// Head Tube Lug
// CNC milled aluminum for NestWorks C500
// Connects head tube to down tube
// Wraps around lower portion of head tube

include <../../config.scad>

module head_tube_lug() {
    // Stepped bore dimensions
    seat_height = 60;  // Height from bottom to seating step (100mm - 40mm clamping = 60mm)
    seat_diameter = head_tube_od + socket_clearance - 4;  // Smaller bore for seating

    // Pinch bolt boss dimensions
    boss_length = 18;  // Increased by 50%
    boss_diameter = 9.5;  // Reduced diameter of boss cylinders
    boss_offset = 1;  // Move bosses outward from cavity for more wall thickness
    boss_translation = (lug_height - seat_height) / 2 + seat_height;
    tap_hole_diameter = 4.2;  // M5 tap drill size
    clearance_hole_diameter = 5.5;  // M5 clearance
    through_hole_position = extension_socket_depth - junction_socket_depth/2;
    bolt_head_clearance = 9.5;  // Clearance for M5 socket head (no raised rim)

    difference() {
        // Build complete solid shape first
        union() {
            // Main collar around head tube
            cylinder(h = lug_height, r = lug_outer_radius);

            // Extension for down tube socket (solid) - thicker walls for tap depth
            translate([0, 0, down_tube_extension_translation])
                rotate([0, dt_angle, 0]) {
                    cylinder(h = extension_depth, d = down_tube_od + 2*6);  // 6mm wall thickness

                    translate([0, 0, extension_depth - extension_socket_depth + junction_socket_depth/2])
                        rotate([90, 0, 0])
                            translate([0, 0, (down_tube_od + 2*6)/2])
                                sphere(r = 8);
                    }
                                
            // Pinch bolt boss - single boss in upper clamping section
            // Positioned at 75% height (45mm) in the clamping zone
            bolt_x = -(head_tube_od/2 + wall_thickness/2) - boss_offset;  // Moved outward
            translate([bolt_x, 0, boss_translation])
                rotate([90, 0, 0]) {
                    // Main cylinder
                    cylinder(h = boss_length, d = boss_diameter, center = true);
                    // Spherical cap on -Z end (the tapped end)
                    translate([0, 0, -boss_length/2])
                        sphere(d = boss_diameter);
                }

            // Extension for top tube socket at top of lug
            // Positioned so outer perimeter is flush with top (lug_height)
            // Socket points toward seat tube mid-junction at calculated tt_angle
            translate([0, 0, top_extension_translation + down_tube_extension_translation])
                rotate([0, tt_angle, 0]) {
                    cylinder(h = extension_depth, r = top_extension_outer_radius);  // 6mm walls

                    translate([socket_offset, 0, extension_depth - extension_socket_depth + junction_socket_depth/2])
                        rotate([90, 0, 0])
                            translate([0, 0, (top_tube_od + 2*6)/2])
                                sphere(r = 8);
                    }
        }

        // Cut all holes through the solid
        // Head tube bore - two sections to create seating step
        // Lower section: larger diameter, extends below lug to clear downtube sleeve
        translate([0, 0, -lug_height])
            cylinder(h = lug_height + seat_height + epsilon, d = head_tube_od + socket_clearance);

        // Upper section: smaller diameter, head tube seats on the step
        translate([0, 0, seat_height])
            cylinder(h = lug_height - seat_height + epsilon, d = head_tube_od + socket_clearance - 4);

        translate([0, 0, down_tube_extension_translation])
            rotate([0, dt_angle, 0]) {
                // Down tube socket bore (only as deep as needed for tube insertion)
                translate([0, 0, extension_depth - extension_socket_depth])
                    cylinder(h = extension_socket_depth + epsilon, d = down_tube_od + socket_clearance);

                // Down tube bolt holes - one tapped side, one counterbored side
                translate([0, 0, extension_depth - extension_socket_depth + junction_socket_depth/2])
                    rotate([90, 0, 0]) {
                        // Tap hole - starts 2mm inside socket bore, extends outward
                        tap_start = (down_tube_od + socket_clearance)/2 - 2;
                        translate([0, 0, tap_start])
                            cylinder(h = m6_thread_depth, d = m6_tap_drill, center = false);

                        // Clearance hole - from opposite side through to tap
                        translate([0, 0, -(down_tube_od/2 + 6)])
                            cylinder(h = down_tube_od/2 + 6 - tap_start, d = joint_bolt_diameter + 0.5, center = false);

                        // Counterbore for M5 socket head cap screw
                        translate([0, 0, -(down_tube_od/2 + 6)])
                            cylinder(h = 2.5, d = 9.5, center = false);
                    }
                }

        // Pinch bolt slot (to clamp on head tube) - 2mm wide slot on FRONT (180° from downtube)
        // Slot only cuts upper half (above shoulder) for clamping
        // Lower half remains solid ring for structural strength
        slot_x = -(head_tube_od/2 + wall_thickness) - boss_length/2;  // Start far enough out to cut through bosses
        slot_width = wall_thickness + boss_length;  // Wide enough to cut through wall + bosses
        translate([slot_x, -1, seat_height])
            cube([slot_width, 2, lug_height - seat_height + epsilon]);

        // Pinch bolt hole - single bolt at 75% height (45mm)
        bolt_x = -(head_tube_od/2 + wall_thickness/2) - boss_offset;  // Moved outward to match boss

        translate([bolt_x, 0, boss_translation])
            rotate([90, 0, 0]) {
                // Tap hole on -Z end (spherical cap end) - only drills partway
                translate([0, 0, -boss_length/2])
                    cylinder(h = boss_length/2 - 1, d = tap_hole_diameter, center = false);

                // Clearance hole - drills through from center to +Z end and beyond
                translate([0, 0, 1])
                    cylinder(h = boss_length/2 + 20, d = clearance_hole_diameter, center = false);

                translate([0, 0, boss_length/2])
                    cylinder(h = 20, d = bolt_head_clearance, center = false);
            }

        lug_collar_radius = (head_tube_od + 2*wall_thickness) / 2;
        socket_offset = lug_collar_radius - top_extension_outer_radius;
        translate([0, 0, top_extension_translation + down_tube_extension_translation])
            rotate([0, tt_angle, 0]) {
                // Top tube socket bore
                translate([socket_offset, 0, extension_depth - extension_socket_depth])
                    cylinder(h = extension_socket_depth + epsilon, d = top_tube_od + socket_clearance);

                // Top tube bolt hole (M6 through-bolt) - positioned like downtube bolt
                translate([socket_offset, 0, extension_depth - extension_socket_depth + junction_socket_depth/2])
                    rotate([90, 0, 0]) {
                        // Tap hole from one side
                        translate([0, 0, (top_tube_od + socket_clearance)/2 - 2])
                            cylinder(h = m6_thread_depth, d = m6_tap_drill);

                        // Clearance hole from opposite side
                        translate([0, 0, -(top_tube_od/2 + 6)])
                            cylinder(h = top_tube_od/2 + 6 - ((top_tube_od + socket_clearance)/2 - 2), d = joint_bolt_diameter + 0.5);

                        // Counterbore for socket head
                        translate([0, 0, -(top_tube_od/2 + 6)])
                            cylinder(h = 2.5, d = 9.5);
                    }
                }
                    
         // Chop the excess top extension off
         translate([0, 0, lug_height])
            cylinder(r=lug_outer_radius, h=50);
    }
}

// Wrapper to reposition origin at downtube socket cap center
module head_tube_lug_repositioned() {
    translate([0, 0, extension_depth-extension_socket_depth])
        rotate([0, 180-dt_angle, 0])
            translate([0, 0, -extension_socket_depth])
                head_tube_lug();
}

// Render for preview
head_tube_lug_repositioned();
