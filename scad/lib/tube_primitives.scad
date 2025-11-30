// Tube primitives for plastic-cf components

include <bolt_sizes.scad>
include <tube_sizes.scad>

// Creates a simple plastic-cf tube with optional through holes
// through_holes: array of Z positions along tube axis for orthogonal holes
module tube_core(tube_size, length, through_holes = []) {
    outer_r = tube_outer_radius(tube_size);
    thickness = tube_thickness(tube_size);
    bolt_size = tube_bolt_size(tube_size);
    through_r = bolt_through_radius(bolt_size);

    difference() {
        // Main tube cylinder
        cylinder(r = outer_r, h = length);

        // Bore (hollow interior)
        translate([0, 0, -0.01])
            cylinder(r = outer_r - thickness, h = length + 0.02);

        // Through holes (orthogonal to tube axis)
        for (z = through_holes) {
            translate([0, 0, z])
                rotate([90, 0, 0])
                    cylinder(r = through_r, h = outer_r * 3, center = true);
        }
    }
}

// Creates the end of a tube with either socket extension or joint mounting
// type: "socket" for insertion into junction, "joint" for joining tube sections
module tube_end(tube_size, type = "socket") {
    outer_r = tube_outer_radius(tube_size);
    thickness = tube_thickness(tube_size);
    socket_depth = tube_socket_depth(tube_size);
    inner_sleeve_depth = tube_inner_sleeve_depth(tube_size);
    bolt_size = tube_bolt_size(tube_size);
    through_r = bolt_through_radius(bolt_size);

    height = (type == "socket") ? socket_depth : inner_sleeve_depth;

    difference() {
        cylinder(r = outer_r, h = height);

        // Bore
        translate([0, 0, -0.01])
            cylinder(r = outer_r - thickness, h = height + 0.02);

        if (type == "socket") {
            translate([0, 0, height / 2])
                rotate([90, 0, 0])
                    cylinder(r = through_r, h = outer_r * 3, center = true);
        } else if (type == "joint") {
            translate([0, 0, height / 3])
                rotate([90, 0, 0])
                    cylinder(r = through_r, h = outer_r * 3, center = true);

            translate([0, 0, height * 2 / 3])
                rotate([90, 0, 90])
                    cylinder(r = through_r, h = outer_r * 3, center = true);
        }
    }
}

// Creates a complete plastic-cf tube with configurable ends
// Combines tube_core with tube_end at each end
// through_holes: array of Z positions along tube axis for orthogonal holes
module tube(tube_size, length, start_type = "socket", end_type = "socket", through_holes = []) {
    socket_depth = tube_socket_depth(tube_size);
    inner_sleeve_depth = tube_inner_sleeve_depth(tube_size);

    // Calculate core length based on end types
    start_length = (start_type == "socket") ? socket_depth : inner_sleeve_depth;
    end_length = (end_type == "socket") ? socket_depth : inner_sleeve_depth;
    core_length = length - start_length - end_length;

    // Filter through_holes to only include those in the core region
    core_through_holes = [for (z = through_holes) if (z >= start_length && z < start_length + core_length) z - start_length];

    // Start end
    tube_end(tube_size, start_type);

    // Core
    translate([0, 0, start_length])
        tube_core(tube_size, core_length, core_through_holes);

    // End end
    translate([0, 0, start_length + core_length])
        tube_end(tube_size, end_type);
}

// Helper function to calculate number of sections needed for a tube
// Uses global max_tube_length for maximum section length
function tube_num_sections(tube_size, total_length) =
    let(
        socket_depth = tube_socket_depth(tube_size),
        inner_sleeve_depth = tube_inner_sleeve_depth(tube_size),
        usable_length_per_section = max_tube_length - socket_depth - inner_sleeve_depth
    )
    ceil(total_length / usable_length_per_section);

// Creates a single section of a split tube for printing
// Automatically determines end types based on section number
// Uses global max_tube_length for maximum section length
module tube_section(tube_size, section_num, total_length, through_holes = []) {
    socket_depth = tube_socket_depth(tube_size);
    inner_sleeve_depth = tube_inner_sleeve_depth(tube_size);

    // Calculate number of sections needed
    num_sections = tube_num_sections(tube_size, total_length);

    // Calculate section length
    section_length = total_length / num_sections;
    
    // Determine end types
    // First section: socket start, joint end
    // Middle sections: joint both ends
    // Last section: joint start, socket end
    start_type = (section_num == 0) ? "socket" : "joint";
    end_type = (section_num == num_sections - 1) ? "socket" : "joint";

    // Render the section with through holes
    tube(tube_size, section_length, start_type, end_type, through_holes);
}

module sectioned_tube(tube_size, total_length, through_holes = [], debug_color = "invisible", body_color = "white") {
    socket_depth = tube_socket_depth(tube_size);
    inner_sleeve_depth = tube_inner_sleeve_depth(tube_size);
    num_sections = tube_num_sections(tube_size, total_length);

    // Calculate section positions
    // Each section overlaps with neighbors at joint regions
    section_length = total_length / num_sections;

    color(body_color)
        for (i = [0:num_sections-1]) {
            // Position: first section starts at 0, subsequent sections positioned to connect
            // Section 0: starts at 0
            // Section 1+: positioned at end of previous section's usable length
            section_start_z = i * section_length;

            // Filter through_holes to only those in this section's range
            // Range is from section start to section start + usable length + socket/joint
            section_holes = [
                for (z = through_holes)
                    if (z >= section_start_z && z < section_start_z + section_length)
                        z - section_start_z
            ];

            // Position and render section
            translate([0, 0, section_start_z])
                tube_section(tube_size, i, total_length, section_holes);
        }

    // Debug cylinders at socket-to-core junctions only
    if (debug_color != "invisible") {
        debug_cylinder_d = 5;
        debug_cylinder_length = 200;

        color(debug_color, 0.8) {
            // Socket-to-core junction at start
            translate([0, 0, 0])
                rotate([90, 0, 0])
                    cylinder(h = debug_cylinder_length, d = debug_cylinder_d, center = true);

            // Core-to-socket junction at end
            translate([0, 0, total_length])
                rotate([90, 0, 0])
                    cylinder(h = debug_cylinder_length, d = debug_cylinder_d, center = true);
        }
    }
}
