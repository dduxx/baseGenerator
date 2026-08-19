# baseGenerator

Parametric OpenSCAD bases for tabletop miniatures and wargaming models. Supports round, square, and pill shapes with customizable dimensions, chamfer, and wall thickness.

## Requirements

- [OpenSCAD](https://openscad.org/)
- [buildscad](https://github.com/dduxx/buildscad) (optional, for CLI builds)

## Usage

### OpenSCAD Customizer

Open `scad/main.scad` in OpenSCAD and use the Customizer panel to select the base type and adjust parameters.

### Command line (buildscad)

```
buildscad build
```

Output files are placed in the `build/` directory.

## Parameters

| Parameter | Description | Default |
|---|---|---|
| `BASE_TYPE` | Base shape: `r` (round), `s` (square), `p` (pill) | `r` |
| `WIDTH` | X dimension in mm | `25` |
| `DEPTH` | Y dimension in mm | `25` |
| `HEIGHT` | Z dimension in mm | `4` |
| `TOP_DIFF` | Chamfer reduction from bottom to top in mm | `2` |
| `WALL_THICKNESS` | Hollow wall thickness in mm | `1` |
