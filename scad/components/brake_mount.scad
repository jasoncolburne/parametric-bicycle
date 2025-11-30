// Disc Brake Mount (Post Mount)
// CNC milled component for NestWorks C500

include <../geometry.scad>

module brake_mount() {
    difference() {
        // Main body
        cube([brake_mount_width, brake_mount_height, brake_mount_thickness]);

        // Post mount holes (74mm spacing) - M6 threaded
        // These are tapped holes for caliper bolts
        translate([brake_mount_width/2, brake_mount_height/2 - brake_post_bolt_spacing/2, -epsilon])
            cylinder(h = brake_mount_thickness + 2*epsilon, d = 5);  // M6 tap drill
        translate([brake_mount_width/2, brake_mount_height/2 + brake_post_bolt_spacing/2, -epsilon])
            cylinder(h = brake_mount_thickness + 2*epsilon, d = 5);  // M6 tap drill

        // Frame mounting holes (M5)
        translate([10, brake_mount_height/2, -epsilon])
            cylinder(h = brake_mount_thickness + 2*epsilon, d = 5.5);
        translate([brake_mount_width - 10, brake_mount_height/2, -epsilon])
            cylinder(h = brake_mount_thickness + 2*epsilon, d = 5.5);
    }
}

// Render for preview
brake_mount();
