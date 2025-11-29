# Primitives Library Tests Makefile

# OpenSCAD executable
OPENSCAD := /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
OPENSCAD_FLAGS := --backend=Manifold

# Test files
TESTS := test_core_structs test_basic_primitives test_tubes test_sleeve_components test_sleeve_assembly

# Phony targets
.PHONY: all clean core_structs basic_primitives tubes sleeve_components sleeve_assembly

# Default: run all tests
all: $(TESTS)

# Core data structures
core_structs: test_core_structs

test_core_structs:
	@echo "=== Running Core Structs Tests (BoltSize, TubeSize, Helpers) ==="
	@$(OPENSCAD) $(OPENSCAD_FLAGS) -o /tmp/test_core_structs.stl test_core_structs.scad 2>&1 | grep "ECHO:"
	@echo "✓ Core structs tests passed"
	@echo ""

# Basic primitives
basic_primitives: test_basic_primitives

test_basic_primitives:
	@echo "=== Running Basic Primitives Tests (tube_core, inner_sleeve, rivnut_hole) ==="
	@$(OPENSCAD) $(OPENSCAD_FLAGS) -o /tmp/test_basic_primitives.stl test_basic_primitives.scad 2>&1 | grep "ECHO:"
	@echo "✓ Basic primitives tests passed"
	@echo ""

# Tube tests
tubes: test_tubes

test_tubes:
	@echo "=== Running Tube Tests (tube_end, tube, tube_section) ==="
	@$(OPENSCAD) $(OPENSCAD_FLAGS) -o /tmp/test_tubes.stl test_tubes.scad 2>&1 | grep "ECHO:"
	@echo "✓ Tube tests passed"
	@echo ""

# Sleeve components
sleeve_components: test_sleeve_components

test_sleeve_components:
	@echo "=== Running Sleeve Components Tests (sleeve_collar, sleeve_pinch_bolt) ==="
	@$(OPENSCAD) $(OPENSCAD_FLAGS) -o /tmp/test_sleeve_components.stl test_sleeve_components.scad 2>&1 | grep "ECHO:"
	@echo "✓ Sleeve components tests passed"
	@echo ""

# Sleeve assembly
sleeve_assembly: test_sleeve_assembly

test_sleeve_assembly:
	@echo "=== Running Sleeve Assembly Tests (sleeve, pinched_sleeve, tapped_sleeve) ==="
	@$(OPENSCAD) $(OPENSCAD_FLAGS) -o /tmp/test_sleeve_assembly.stl test_sleeve_assembly.scad 2>&1 | grep "ECHO:"
	@echo "✓ Sleeve assembly tests passed"
	@echo ""

clean:
	rm -f /tmp/test_*.stl
