// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math' as math;

class PortfolioGauge extends StatefulWidget {
  const PortfolioGauge({
    super.key,
    this.width, // leave null to fill parent
    this.height, // set in FF (e.g., 220)
    this.score, // 0..max
    this.maxScore, // default 999
    this.durationMs, // default 1400
    this.delayMs, // default 0
    this.sweepDegrees, // default 300 (arc length)
    this.strokeWidth, // default auto (≈10% of height)
    this.yellowAt, // 0..1 along visible arc; default 0.40 (earlier yellow)
  });

  final double? width;
  final double? height;
  final int? score;
  final int? maxScore;
  final int? durationMs;
  final int? delayMs;
  final double? sweepDegrees;
  final double? strokeWidth;
  final double? yellowAt;

  @override
  State<PortfolioGauge> createState() => _PortfolioGaugeState();
}

class _PortfolioGaugeState extends State<PortfolioGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _numAnim;
  late Animation<double> _pctAnim;

  int get _max => (widget.maxScore ?? 999).clamp(1, 999999);
  int get _score => (widget.score ?? 0).clamp(0, _max);
  double get _targetPct => _score / _max;
  Duration get _duration => Duration(milliseconds: widget.durationMs ?? 1400);
  Duration get _delay => Duration(milliseconds: widget.delayMs ?? 0);
  double get _sweepDeg => (widget.sweepDegrees ?? 300).clamp(10, 359);
  double get _stroke {
    final h = widget.height ?? 220;
    final auto = (h * 0.10).clamp(10.0, 26.0);
    return (widget.strokeWidth ?? auto).toDouble();
  }

  double get _yellowAt => (widget.yellowAt ?? 0.40).clamp(0.05, 0.95);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    final curve =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    _numAnim = Tween<double>(begin: 0, end: _score.toDouble()).animate(curve);
    _pctAnim = Tween<double>(begin: 0, end: _targetPct).animate(curve);

    if (_delay.inMilliseconds > 0) {
      Future.delayed(_delay, () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant PortfolioGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    final changedScore = oldWidget.score != widget.score ||
        oldWidget.maxScore != widget.maxScore;
    final changedDuration = oldWidget.durationMs != widget.durationMs;

    if (changedScore || changedDuration) {
      _controller.duration = _duration;
      final curve =
          CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
      _numAnim = Tween<double>(begin: _numAnim.value, end: _score.toDouble())
          .animate(curve);
      _pctAnim =
          Tween<double>(begin: _pctAnim.value, end: _targetPct).animate(curve);
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.height ?? 220; // FF needs explicit height in designer
    final radius = (h / 2) - (_stroke / 2);

    final numberStyle = FlutterFlowTheme.of(context).bodyMedium?.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          height: 1.0,
        );

    // Center the gap at the bottom.
    final sweepRad = _sweepDeg * math.pi / 180;
    final startAngle = math.pi / 2 + ((2 * math.pi - sweepRad) / 2);

    return SizedBox(
      width: widget.width, // null = fill parent
      height: h,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            painter: _RingPainter(
              pct: _pctAnim.value.clamp(0.0, 1.0),
              radius: radius.clamp(20.0, 1000.0),
              stroke: _stroke,
              sweepRadians: sweepRad,
              startAngle: startAngle,
              yellowAt: _yellowAt,
            ),
            child: Center(
              child:
                  Text(_numAnim.value.round().toString(), style: numberStyle),
            ),
          );
        },
      ),
    );
  }
}

/// Paints a partial ring with correctly mapped gradient along the arc
class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.pct,
    required this.radius,
    required this.stroke,
    required this.sweepRadians,
    required this.startAngle,
    required this.yellowAt,
  });

  final double pct; // 0..1 of the arc filled
  final double radius;
  final double stroke;
  final double sweepRadians; // total arc length (radians)
  final double startAngle; // where the arc begins (radians)
  final double yellowAt; // 0..1 along visible arc

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track (background)
    final track = Paint()
      ..color = const Color(0xFFE8E8E8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, sweepRadians, false, track);

    // Gradient mapped ONLY to the visible arc length.
    const red = Color(0xFFE53935);
    const yellow = Color(0xFFFFB300);
    const green = Color(0xFF43A047);

    const double eps = 0.002; // tiny red lock at very start
    final full = 2 * math.pi;
    final ratio = sweepRadians / full; // fraction of full circle shown
    final y = yellowAt * ratio; // yellow location along visible arc

    final shader = SweepGradient(
      transform: GradientRotation(startAngle), // align 0.0 with arc start
      colors: const [red, red, yellow, green],
      stops: <double>[0.0, eps, y, ratio], // scaled to arc length
      tileMode: TileMode.clamp,
    ).createShader(rect);

    final progress = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    // Main progress arc with gradient
    final progressSweep = sweepRadians * pct;
    canvas.drawArc(rect, startAngle, progressSweep, false, progress);

    // ----- Start-cap mask to eliminate any stray seam color -----
    // Draw a tiny red arc at the very start, on top of the gradient.
    if (pct > 0) {
      // ~stroke/radius radians ≈ visual length of the round cap.
      final double capSweep = (stroke / radius) * 0.05;
      final capPaint = Paint()
        ..color = red
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        startAngle,
        math.min(capSweep, progressSweep),
        false,
        capPaint,
      );
    }
    // ------------------------------------------------------------
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      pct != old.pct ||
      radius != old.radius ||
      stroke != old.stroke ||
      sweepRadians != old.sweepRadians ||
      startAngle != old.startAngle ||
      yellowAt != old.yellowAt;
}
