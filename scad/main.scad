// The type of base to generate
BASE_TYPE = "r"; // [r:Round, s:Square, p:Pill]

// MM size of the base in the x direction
WIDTH = 25;

// MM size of the base in the y direction
DEPTH = 25;

// MM size of the base in the z direction
HEIGHT = 4;

// MM difference in size between the top and bottom of the base. Used to create chamfer
TOP_DIFF = 2;

// Thickness of the base walls
WALL_THICKNESS = 1;

module __Customizer_Limit__ () {}

$fn = 200;

if (BASE_TYPE == "r") {
    round_base(WIDTH, DEPTH, HEIGHT, TOP_DIFF, WALL_THICKNESS);
} else if (BASE_TYPE == "s") {
    square_base(WIDTH, DEPTH, HEIGHT, TOP_DIFF, WALL_THICKNESS);
} else {
    pill_base(WIDTH, DEPTH, HEIGHT, TOP_DIFF, WALL_THICKNESS);
}

module round_base(x, y, z, top_diff, wall_thickness) {
    _assert_dimensions(x, y, z, top_diff, wall_thickness);

    cutout_x = x - (wall_thickness * 2);
    cutout_y = y - (wall_thickness * 2);
    cutout_z = z / 2;

    x_scale_factor = x == y || x < y ? 1 : x / y;
    y_scale_factor = x == y || x > y ? 1 : y / x;

    diff_x_scale_factor = cutout_x == cutout_y || cutout_x < cutout_y ? 1 : cutout_x / cutout_y;
    diff_y_scale_factor = cutout_x == cutout_y || cutout_x > cutout_y ? 1 : cutout_y / cutout_x;

    base_rad = x > y ? y / 2 : x / 2;
    cutout_rad = cutout_x > cutout_y ? cutout_y / 2 : cutout_x / 2;

    difference() {
        scale([x_scale_factor, y_scale_factor, 1]) {
            cylinder(r1 = base_rad, r2 = base_rad - (top_diff / 2), h = z);
        }

        scale([diff_x_scale_factor, diff_y_scale_factor, 1]) {
            cylinder(r1 = cutout_rad, r2 = cutout_rad - (top_diff / 2), h = cutout_z);
        }
    }
}

module square_base(x, y, z, top_diff, wall_thickness) {
    _assert_dimensions(x, y, z, top_diff, wall_thickness);

    difference() {
        _chamfered_square(x, y, z, top_diff);

        _chamfered_square(
            x - (2 * wall_thickness),
            y - (2 * wall_thickness),
            z / 2,
            top_diff
        );
    }
}

module pill_base(x, y, z, top_diff, wall_thickness) {
    _assert_dimensions(x, y, z, top_diff, wall_thickness);

    base_rad = x > y ? y / 2 : x / 2;

    x_trans = x < y ? 0 : (x - (2 * base_rad)) / 2;
    y_trans = y < x ? 0 : (y - (2 * base_rad)) / 2;

    echo(x, y, z);
    echo(base_rad, x_trans, y_trans);

    difference() {
        hull() {
            translate([x_trans, y_trans, 0]) {
                cylinder(h = z, r1 = base_rad, r2 = base_rad - (top_diff / 2),center = false);
            }

            translate([-x_trans, -y_trans, 0]) {
                cylinder(h = z, r1 = base_rad, r2 = base_rad - (top_diff / 2),center = false);
            }
        }

        hull() {
            translate([x_trans, y_trans, 0]) {
                cylinder(
                    h = z / 2,
                    r1 = base_rad - (wall_thickness),
                    r2 = base_rad - (top_diff / 2) - (wall_thickness),
                    center = false
                );
            }

            translate([-x_trans, -y_trans, 0]) {
                cylinder(
                    h = z / 2,
                    r1 = base_rad - (wall_thickness),
                    r2 = base_rad - (top_diff / 2) - (wall_thickness),
                    center = false
                );
            }
        }
    }
}


module _chamfered_square(x, y, z, top_diff, hull_allowance = 0.00001) {
    top_x = x - top_diff;
    top_y = y - top_diff;

    hull() {
        translate([-x/2 , -y/2, 0]) {
            cube([x, y, hull_allowance]);
        }

        translate([-top_x/2 , -top_y/2, z - hull_allowance]) {
            cube([top_x, top_y, hull_allowance]);
        }
    }
}

module _assert_dimensions(x, y, z, top_diff, wall_thickness) {
    assert(is_num(x) && x > 0, "Expected a positive number MM measurement for the width.");
    assert(is_num(y) && y > 0, "Expected a positive number MM measurement for the depth.");
    assert(is_num(z) && z > 0, "Expected a positive number MM measurement for the height.");
    assert(is_num(top_diff) && top_diff >= 0, "The chamfer difference must be a positive number.");
    assert(
        is_num(wall_thickness) && wall_thickness > 0,
        "The wall thickness must be a positive number"
    );
}
