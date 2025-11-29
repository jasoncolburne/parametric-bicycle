// Collar struct for sleeve collar configurations
// Hybrid accessor pattern: indexed lists with constructor and accessor functions

include <tube_sizes.scad>

// Internal indices (private)
_COLLAR_TUBE_SIZE = 0;
_COLLAR_ROTATION = 1;
_COLLAR_HEIGHT = 2;

// Constructor
function Collar(tube_size, rotation, height) =
    [tube_size, rotation, height];

// Accessors
function collar_tube_size(c) = c[_COLLAR_TUBE_SIZE];
function collar_rotation(c) = c[_COLLAR_ROTATION];
function collar_height(c) = c[_COLLAR_HEIGHT];
