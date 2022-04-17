double frac(double v) => v - v.floor();

double invAbs(double v) => (1 / v).abs();

num sq(num v) => v * v;

int col(b, s, p) => (((b * s).floor() & 0xff) << p);

int greyscale(num s, [int b = 255]) =>
    (0xff000000 | col(b, s, 16) | col(b, s, 8) | col(b, s, 0)) & 0xFFFFFFFF;
