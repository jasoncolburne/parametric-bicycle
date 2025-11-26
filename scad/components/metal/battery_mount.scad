// Battery Mount Bracket
// CNC milled aluminum or 3D printed carbon fiber reinforced for NestWorks C500 / FibreSeeker 3
// Bolts directly to rivnuts in downtube via M5 bolts
// Provides cradle for shark pack battery

include <../../config.scad>

module battery_mount_bracket() {
    bracket_width = 90;
    bracket_height = 80;
    bracket_thickness = 6;

    difference() {
        union() {
            // Main mounting plate
            translate([-bracket_width/2, 0, 0])
                cube([bracket_width, bracket_thickness, bracket_height]);

            // Support ribs for structural rigidity
            for (x = [-30, 0, 30]) {
                translate([x - 2, bracket_thickness, 0])
                    cube([4, 15, bracket_height]);
            }
        }

        // Mounting holes to downtube rivnuts (74mm spacing)
        for (z_offset = [10, 10 + bottle_cage_spacing]) {
            translate([0, -epsilon, z_offset])
                rotate([-90, 0, 0])
                    cylinder(h = bracket_thickness + 2*epsilon, d = 5.5);  // M5 clearance
        }

        // Battery strap slots (for velcro straps to secure battery)
        for (z = [25, 55]) {
            translate([-bracket_width/2 - epsilon, bracket_thickness + 5, z])
                cube([bracket_width + 2*epsilon, 6, 8]);
        }
    }
}

// Render for preview
battery_mount_bracket();
