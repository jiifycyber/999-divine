import 'dart:math' as math;

class DivineMoonService {
  static const double synodicMonth = 29.530588853;
  static final DateTime referenceNewMoon = DateTime.utc(2000, 1, 6, 18, 14);

  static double age(DateTime date) {
    final target = DateTime.utc(date.year, date.month, date.day, 12);
    final days = target.difference(referenceNewMoon).inSeconds / 86400.0;
    return ((days % synodicMonth) + synodicMonth) % synodicMonth;
  }

  static double illumination(DateTime date) {
    final angle = 2 * math.pi * age(date) / synodicMonth;
    return (1 - math.cos(angle)) / 2;
  }

  static String phaseName(DateTime date) {
    final phase = age(date) / synodicMonth;
    if (phase < 0.0625 || phase >= 0.9375) return 'New Moon';
    if (phase < 0.1875) return 'Waxing Crescent';
    if (phase < 0.3125) return 'First Quarter';
    if (phase < 0.4375) return 'Waxing Gibbous';
    if (phase < 0.5625) return 'Full Moon';
    if (phase < 0.6875) return 'Waning Gibbous';
    if (phase < 0.8125) return 'Last Quarter';
    return 'Waning Crescent';
  }

  static String symbol(DateTime date) {
    switch (phaseName(date)) {
      case 'New Moon':
        return '🌑';
      case 'Waxing Crescent':
        return '🌒';
      case 'First Quarter':
        return '🌓';
      case 'Waxing Gibbous':
        return '🌔';
      case 'Full Moon':
        return '🌕';
      case 'Waning Gibbous':
        return '🌖';
      case 'Last Quarter':
        return '🌗';
      default:
        return '🌘';
    }
  }
}
