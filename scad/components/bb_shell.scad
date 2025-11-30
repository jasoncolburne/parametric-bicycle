// Bottom Bracket Shell
// CNC milled component for NestWorks C500

include <../geometry.scad>

module bb_shell() {
    difference() {
        // Outer cylinder
        cylinder(h = bb_shell_width, d = bb_shell_od);

        // Inner bore (threaded)
        translate([0, 0, -epsilon])
            cylinder(h = bb_shell_width + 2*epsilon, d = bb_shell_id);
    }
}

// Render for preview
bb_shell();
