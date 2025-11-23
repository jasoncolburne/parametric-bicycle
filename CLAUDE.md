# Project Context

This repository contains OpenSCAD designs for a complete electric bicycle (ebike), along with documentation specifying compatible components.

## Fabrication Compatibility

### NestWorks C500 (CNC)
- Working area with ATC: 230×213×128mm
- Working area manual: 280×235×150mm
- Spindle: 800W, 9000-18000 RPM
- Precision: ±0.02mm (probe: <0.01mm)
- Materials: titanium, stainless steel, brass, copper, aluminum, wood, plastics
- 4th axis: 3-80mm diameter, up to 240mm length

### FibreSeeker 3 (Continuous Fiber 3D Printer)
- Build volume: 300×300×245mm
- Precision: ±0.2mm
- Layer thickness: 50μm minimum
- Materials: PLA, PETG, PC, PA + continuous carbon/glass fiber
- Tensile strength: up to 900 MPa

## Rider Ergonomics

Initial design optimized for:
- **Height**: 173 cm
- **Weight**: 55 kg

## Technology

- **OpenSCAD** - parametric 3D CAD modeling language
- Design files use `.scad` extension
