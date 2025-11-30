// Phase 1 Verification: Test BoltSize and TubeSize structs

include <../scad/lib/helpers.scad>
include <../scad/lib/bolt_sizes.scad>
include <../scad/lib/tube_sizes.scad>

// Test BoltSize accessors
echo("=== M6 Bolt Tests ===");
echo("M6 tap radius:", bolt_tap_radius(M6_BOLT));
echo("M6 clearance radius:", bolt_clearance_radius(M6_BOLT));
echo("M6 counterbore radius:", bolt_counterbore_radius(M6_BOLT));
echo("M6 boss radius:", bolt_boss_radius(M6_BOLT));

echo("=== M5 Bolt Tests ===");
echo("M5 tap radius:", bolt_tap_radius(M5_BOLT));
echo("M5 clearance radius:", bolt_clearance_radius(M5_BOLT));

// Test TubeSize accessors
echo("=== Down Tube Tests ===");
echo("Down tube outer radius:", tube_outer_radius(DOWN_TUBE));
echo("Down tube thickness:", tube_thickness(DOWN_TUBE));
echo("Down tube socket depth:", tube_socket_depth(DOWN_TUBE));
echo("Down tube extension depth:", tube_extension_depth(DOWN_TUBE));

echo("=== Seat Tube Tests ===");
echo("Seat tube outer radius:", tube_outer_radius(SEAT_TUBE));
echo("Seat tube bolt tap radius:", bolt_tap_radius(tube_bolt_size(SEAT_TUBE)));

echo("=== Chainstay Tests ===");
echo("Chainstay outer radius:", tube_outer_radius(CHAINSTAY));
echo("Chainstay bolt (M5) tap radius:", bolt_tap_radius(tube_bolt_size(CHAINSTAY)));

// Test vector_to_euler helper
echo("=== vector_to_euler Tests ===");
test_vec1 = [1, 0, 0];
test_vec2 = [0, 1, 0];
test_vec3 = [0, 0, 1];
test_vec4 = [1, 1, 1];
echo("Vector [1,0,0] -> Euler:", vector_to_euler(test_vec1));
echo("Vector [0,1,0] -> Euler:", vector_to_euler(test_vec2));
echo("Vector [0,0,1] -> Euler:", vector_to_euler(test_vec3));
echo("Vector [1,1,1] -> Euler:", vector_to_euler(test_vec4));

// Simple visual test - render a cube if everything parses
cube([10, 10, 10]);
