import 'package:flutter/material.dart';

class DivinePremiumKpiCard extends StatelessWidget {
  const DivinePremiumKpiCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.variant,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final int variant;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: color.withValues(alpha: .90), width: 1.15),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: .095),
            const Color(0xFF35204C),
            const Color(0xFF160B29),
          ],
          stops: const [0, .35, 1],
        ),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: .17), blurRadius: 17),
          const BoxShadow(
            color: Color(0x33000000),
            blurRadius: 14,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 33,
              child: Opacity(
                opacity: .90,
                child: CustomPaint(
                  painter: _DivineKpiSparkPainter(
                    color: color,
                    variant: variant,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 7,
              top: 6,
              right: 7,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      color.withValues(alpha: .90),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 12, 5, 7),
              child: Column(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: .09),
                      border: Border.all(color: color.withValues(alpha: .24)),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: .15),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: TextStyle(
                      color: color,
                      fontSize: 27,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.8,
                      shadows: [
                        Shadow(
                          color: color.withValues(alpha: .35),
                          blurRadius: 9,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFF9F1FF),
                      fontSize: 6.1,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .20,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_downward_rounded,
                        color: Color(0xFFE8C779),
                        size: 8,
                      ),
                      const SizedBox(width: 2),
                      const Flexible(
                        child: Text(
                          'LUNAR INSIGHT',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFFD1B6E9),
                            fontSize: 5.3,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DivineKpiSparkPainter extends CustomPainter {
  const _DivineKpiSparkPainter({required this.color, required this.variant});

  final Color color;
  final int variant;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = color.withValues(alpha: .06)
      ..strokeWidth = .5;

    for (var i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final presets = <List<double>>[
      [.78, .68, .72, .49, .58, .40, .46, .28, .37, .18],
      [.68, .73, .59, .63, .47, .55, .34, .42, .23, .12],
      [.74, .62, .69, .51, .55, .39, .43, .33, .24, .15],
      [.81, .70, .76, .61, .65, .48, .52, .37, .43, .22],
    ];

    final values = presets[variant % presets.length];

    final path = Path();

    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height * values[i];

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: .18), color.withValues(alpha: 0)],
        ).createShader(Offset.zero & size),
    );

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color.withValues(alpha: .85),
    );
  }

  @override
  bool shouldRepaint(covariant _DivineKpiSparkPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.variant != variant;
  }
}
