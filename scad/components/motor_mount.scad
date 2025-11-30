// Motor Mount Plate
// CNC milled component for NestWorks C500

include <../geometry.scad>

module motor_mount() {
    difference() {
        // Main plate
        cube([motor_mount_width, motor_mount_height, motor_mount_thickness]);

        // Central clearance for BB shell
        translate([motor_mount_width/2, motor_mount_height/2, -epsilon])
            cylinder(h = motor_mount_thickness + 2*epsilon, d = bb_shell_od + 5);

        // Motor mounting holes (pattern depends on motor)
        // Generic 4-bolt pattern
        bolt_radius = 35;
        for (angle = [45, 135, 225, 315]) {
            translate([
                motor_mount_width/2 + bolt_radius * cos(angle),
                motor_mount_height/2 + bolt_radius * sin(angle),
                -epsilon
            ])
                cylinder(h = motor_mount_thickness + 2*epsilon, d = 6.5);
        }

        // Frame mounting holes (M6)
        translate([10, 10, -epsilon])
            cylinder(h = motor_mount_thickness + 2*epsilon, d = 6.5);
        translate([motor_mount_width - 10, 10, -epsilon])
            cylinder(h = motor_mount_thickness + 2*epsilon, d = 6.5);
        translate([10, motor_mount_height - 10, -epsilon])
            cylinder(h = motor_mount_thickness + 2*epsilon, d = 6.5);
        translate([motor_mount_width - 10, motor_mount_height - 10, -epsilon])
            cylinder(h = motor_mount_thickness + 2*epsilon, d = 6.5);
    }
}

// Render for preview
motor_mount();
