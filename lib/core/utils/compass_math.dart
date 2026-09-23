import 'dart:math' as math;

class CompassMath {
  /// Computes shortest angular distance between two degrees (-180 to 180).
  /// Essential for preventing 359° <-> 0° boundary rotation spin jumps.
  static double shortestAngleDelta(double from, double to) {
    double diff = (to - from) % 360.0;
    if (diff > 180.0) {
      diff -= 360.0;
    } else if (diff < -180.0) {
      diff += 360.0;
    }
    return diff;
  }

  /// Converts degree to cardinal string with 100% Vietnamese labels
  static String degreeToDirection(double degree) {
    final d = (degree % 360 + 360) % 360;
    if (d >= 337.5 || d < 22.5) return 'Chính Bắc (0° / 360°)';
    if (d >= 22.5 && d < 67.5) return 'Đông Bắc (45°)';
    if (d >= 67.5 && d < 112.5) return 'Chính Đông (90°)';
    if (d >= 112.5 && d < 157.5) return 'Đông Nam (135°)';
    if (d >= 157.5 && d < 202.5) return 'Chính Nam (180°)';
    if (d >= 202.5 && d < 247.5) return 'Tây Nam (225°)';
    if (d >= 247.5 && d < 292.5) return 'Chính Tây (270°)';
    return 'Tây Bắc (315°)';
  }

  /// Map exact heading to closest 8-sector center (0, 45, 90, 135, 180, 225, 270, 315)
  static int closestSectorAngle(double degree) {
    final d = (degree % 360 + 360) % 360;
    final sector = ((d + 22.5) ~/ 45) % 8;
    return sector * 45;
  }

  /// Converts degrees to radians
  static double toRadians(double degrees) => degrees * (math.pi / 180.0);
}
