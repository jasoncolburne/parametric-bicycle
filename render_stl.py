#!/usr/bin/env python3
"""
Blender script to render STL files to PNG images.
Usage: blender -b -P render_stl.py -- <input.stl> <output.png> <camera_preset>
"""

import bpy
import sys
import math
import mathutils

def openscad_camera_to_blender(translation, rotation, distance):
    """Convert OpenSCAD gimbal camera parameters to Blender camera location.

    Args:
        translation: (x, y, z) - object center point (where to look)
        rotation: (rot_x, rot_y, rot_z) - gimbal rotation in degrees
        distance: camera distance from object center

    Returns:
        (camera_location, target_location) as mathutils.Vector tuples

    Note: OpenSCAD applies transformations (from GLView.cc):
    1. gluLookAt(0, -dist, 0, ...)  - camera at (0, -dist, 0)
    2. glRotate X, Y, Z             - rotate object
    3. glTranslate                  - translate object

    To find camera in world coords: apply inverse in reverse order.
    """
    target = mathutils.Vector(translation)

    # OpenSCAD internal storage (from Camera.cc): (90-x, -y, -z)
    internal_rot_x = math.radians(90 - rotation[0])
    internal_rot_y = math.radians(-rotation[1])
    internal_rot_z = math.radians(-rotation[2])

    # Camera starts at [0, -distance, 0] in camera space
    # Apply INVERSE rotations in REVERSE order: -Z, -Y, -X
    x, y, z = 0, -distance, 0

    # Inverse Z rotation (rotate by -internal_rot_z)
    cos_z = math.cos(-internal_rot_z)
    sin_z = math.sin(-internal_rot_z)
    x1 = x * cos_z - y * sin_z
    y1 = x * sin_z + y * cos_z
    z1 = z

    # Inverse Y rotation (rotate by -internal_rot_y)
    cos_y = math.cos(-internal_rot_y)
    sin_y = math.sin(-internal_rot_y)
    x2 = x1 * cos_y + z1 * sin_y
    y2 = y1
    z2 = -x1 * sin_y + z1 * cos_y

    # Inverse X rotation (rotate by -internal_rot_x)
    cos_x = math.cos(-internal_rot_x)
    sin_x = math.sin(-internal_rot_x)
    x3 = x2
    y3 = y2 * cos_x - z2 * sin_x
    z3 = y2 * sin_x + z2 * cos_x

    location = mathutils.Vector((target.x + x3, target.y + y3, target.z + z3))
    return location, target

# Clear default scene
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete()

# Get arguments after --
argv = sys.argv
argv = argv[argv.index("--") + 1:]

if len(argv) < 3:
    print("Usage: blender -b -P render_stl.py -- <input.stl> <output.png> <camera_preset>")
    sys.exit(1)

stl_path = argv[0]
output_path = argv[1]
camera_preset = argv[2]

# Import STL
bpy.ops.wm.stl_import(filepath=stl_path)

# Get imported object
obj = bpy.context.selected_objects[0]

# Add material with smooth shading
mat = bpy.data.materials.new(name="Material")
# Note: use_nodes is True by default in Blender 5.0+
bsdf = mat.node_tree.nodes["Principled BSDF"]
bsdf.inputs['Base Color'].default_value = (0.8, 0.8, 0.8, 1.0)
bsdf.inputs['Metallic'].default_value = 0.3
bsdf.inputs['Roughness'].default_value = 0.4

if obj.data.materials:
    obj.data.materials[0] = mat
else:
    obj.data.materials.append(mat)

# Flat shading to show accurate geometry without interpolation artifacts
bpy.ops.object.shade_flat()

# Add camera
cam_data = bpy.data.cameras.new("Camera")
cam_data.lens = 50  # Standard lens
cam_data.clip_start = 0.01  # Very close near clipping
cam_data.clip_end = 10000  # Very far clipping to handle large distances
cam = bpy.data.objects.new("Camera", cam_data)
bpy.context.scene.collection.objects.link(cam)
bpy.context.scene.camera = cam

# Camera presets using OpenSCAD camera parameters
if camera_preset == "full":
    # Full assembly - exact OpenSCAD view
    cam.location, cam_target = openscad_camera_to_blender(
        translation=(-77.53, -257.19, 268.36),
        rotation=(82.30, 0, 161.20),
        distance=2903.56
    )
elif camera_preset == "bb":
    # BB junction - adjusted to center in frame (look-at moved up)
    cam.location, cam_target = openscad_camera_to_blender(
        translation=(-61.24, -212.17, 0),  # Z adjusted from -26.17 to 0 (up)
        rotation=(80.90, 0, 164.70),
        distance=887.48
    )
elif camera_preset == "seat_tube":
    # Seat tube junction - adjusted to center in frame (look-at moved down)
    cam.location, cam_target = openscad_camera_to_blender(
        translation=(-165.17, -207.23, 450),  # Z adjusted from 480.09 to 450 (down)
        rotation=(92.80, 0, 178),
        distance=469.16
    )
elif camera_preset == "dropout":
    # Dropout junction - exact OpenSCAD view
    cam.location, cam_target = openscad_camera_to_blender(
        translation=(-125.32, -360.70, 53.38),
        rotation=(80.20, 0, 43.60),
        distance=35.63
    )
else:
    print(f"Unknown camera preset: {camera_preset}")
    sys.exit(1)

# Point camera at target using constraint (more reliable)
constraint = cam.constraints.new(type='TRACK_TO')
# Create an empty at the target location
target_empty = bpy.data.objects.new("CameraTarget", None)
target_empty.location = cam_target
bpy.context.scene.collection.objects.link(target_empty)
constraint.target = target_empty
constraint.track_axis = 'TRACK_NEGATIVE_Z'
constraint.up_axis = 'UP_Y'

# Add lights
# Key light
light_data = bpy.data.lights.new("KeyLight", 'SUN')
light_data.energy = 2.0
light = bpy.data.objects.new("KeyLight", light_data)
light.location = (500, 500, 1000)
bpy.context.scene.collection.objects.link(light)

# Fill light
fill_data = bpy.data.lights.new("FillLight", 'SUN')
fill_data.energy = 0.5
fill = bpy.data.objects.new("FillLight", fill_data)
fill.location = (-500, -500, 500)
bpy.context.scene.collection.objects.link(fill)

# Render settings
scene = bpy.context.scene
scene.render.engine = 'BLENDER_EEVEE'  # Much faster than Cycles
scene.eevee.taa_render_samples = 8
scene.render.resolution_x = 1920
scene.render.resolution_y = 1080
scene.render.image_settings.file_format = 'PNG'
scene.render.filepath = output_path

# Transparent background
scene.render.film_transparent = True

# Render
bpy.ops.render.render(write_still=True)

print(f"Rendered {stl_path} to {output_path}")
