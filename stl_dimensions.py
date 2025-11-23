#!/usr/bin/env python3
"""Report bounding box dimensions of STL files."""

import os
import sys

def stl_bbox_ascii(filename):
    """Get bounding box dimensions from ASCII STL file."""
    min_x = min_y = min_z = float('inf')
    max_x = max_y = max_z = float('-inf')
    count = 0
    with open(filename, 'r') as f:
        for line in f:
            if 'vertex' in line:
                parts = line.split()
                if len(parts) >= 4:
                    x, y, z = float(parts[1]), float(parts[2]), float(parts[3])
                    min_x = min(min_x, x); max_x = max(max_x, x)
                    min_y = min(min_y, y); max_y = max(max_y, y)
                    min_z = min(min_z, z); max_z = max(max_z, z)
                    count += 1
    if count == 0:
        return None
    return (max_x - min_x, max_y - min_y, max_z - min_z)

def main():
    stl_dir = 'stl'

    if len(sys.argv) > 1:
        # Specific files requested
        for path in sys.argv[1:]:
            if os.path.exists(path):
                dims = stl_bbox_ascii(path)
                if dims:
                    name = os.path.basename(path).replace('.stl', '')
                    print(f'{name:22} {dims[0]:7.1f} x {dims[1]:7.1f} x {dims[2]:6.1f} mm')
    else:
        # Show all STL files
        for subdir in ['metal', 'plastic-cf']:
            path = os.path.join(stl_dir, subdir)
            if os.path.exists(path):
                print(f'{path}:')
                for f in sorted(os.listdir(path)):
                    if f.endswith('.stl'):
                        filepath = os.path.join(path, f)
                        dims = stl_bbox_ascii(filepath)
                        if dims:
                            print(f'  {f[:-4]:22} {dims[0]:7.1f} x {dims[1]:7.1f} x {dims[2]:6.1f} mm')
                print()

if __name__ == '__main__':
    main()
