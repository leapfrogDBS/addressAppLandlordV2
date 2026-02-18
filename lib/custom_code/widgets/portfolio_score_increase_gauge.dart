// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math' as math;
import 'package:visibility_detector/visibility_detector.dart';

/// Gauge that shows portfolio score *increase*: animates from [startScore] to
/// [endScore].
///
/// Use on sales offer cards; set [animateWhenVisible] true to animate when
/// scrolled into view.
class PortfolioScoreIncreaseGauge extends StatefulWidget {
  const PortfolioScoreIncreaseGauge({
    super.key,
    this.width,
    this.height,
    this.startScore, // current portfolio score (e.g. 604)
    this.endScore, // new score with this offer (e.g. 775)
    this.maxScore,
    this.durationMs,
    this.delayMs,
    this.sweepDegrees,
    this.strokeWidth,
    this.yellowAt,
    this.animateWhenVisible, // true = animate when scrolled into view
  });

  final double? width;
  final double? height;
  final int? startScore;
  final int? endScore;
  final int? maxScore;
  final int? durationMs;
  final int? delayMs;
  final double? sweepDegrees;
  final double? strokeWidth;
  final double? yellowAt;
  final bool? animateWhenVisible;

  @override
  State<PortfolioScoreIncreaseGauge> createState() =>
      _PortfolioScoreIncreaseGaugeState();
}

class _PortfolioScoreIncreaseGaugeState
    extends State<PortfolioScoreIncreaseGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _numAnim;
  late Animation<double> _pctAnim;
  bool _hasTriggeredOnVisible = false;

  bool get _animateWhenVisible => widget.animateWhenVisible ?? false;

  int get _max => (widget.maxScore ?? 999).clamp(1, 999999);
  int get _start => (widget.startScore ?? 0).clamp(0, _max);
  int get _end => (widget.endScore ?? 0).clamp(0, _max);
  double get _startPct => _start / _max;
  double get _endPct => _end / _max;
  Duration get _duration => Duration(milliseconds: widget.durationMs ?? 1400);
  Duration get _delay => Duration(milliseconds: widget.delayMs ?? 0);
  double get _sweepDeg => (widget.sweepDegrees ?? 300).clamp(10, 359);
  double get _stroke {
    final h = widget.height ?? 220;
    final auto = (h * 0.10).clamp(10.0, 26.0);
    return (widget.strokeWidth ?? auto).toDouble();
  }

  double get _yellowAt => (widget.yellowAt ?? 0.40).clamp(0.05, 0.95);

  void _startAnimation() {
    if (!mounted || _controller.isAnimating) return;
    if (_delay.inMilliseconds > 0) {
      Future.delayed(_delay, () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    final curve =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    _numAnim = Tween<double>(begin: _start.toDouble(), end: _end.toDouble())
        .animate(curve);
    _pctAnim = Tween<double>(begin: _startPct, end: _endPct).animate(curve);

    if (!_animateWhenVisible) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(covariant PortfolioScoreIncreaseGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    final changed = oldWidget.startScore != widget.startScore ||
        oldWidget.endScore != widget.endScore ||
        oldWidget.maxScore != widget.maxScore ||
        oldWidget.durationMs != widget.durationMs;

    if (changed) {
      _controller.duration = _duration;
      final curve =
          CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
      _numAnim = Tween<double>(begin: _start.toDouble(), end: _end.toDouble())
          .animate(curve);
      _pctAnim = Tween<double>(begin: _startPct, end: _endPct).animate(curve);
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
    final h = widget.height ?? 220;
    final radius = (h / 2) - (_stroke / 2);

    final numberStyle = FlutterFlowTheme.of(context).bodyMedium?.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          height: 1.0,
        );

    final sweepRad = _sweepDeg * math.pi / 180;
    final startAngle = math.pi / 2 + ((2 * math.pi - sweepRad) / 2);

    final gaugeContent = SizedBox(
      width: widget.width,
      height: h,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            painter: _IncreaseRingPainter(
              pct: _pctAnim.value.clamp(0.0, 1.0),
              radius: radius.clamp(20.0, 1000.0),
              stroke: _stroke,
              sweepRadians: sweepRad,
              startAngle: startAngle,
              yellowAt: _yellowAt,
            ),
            child: Center(
              child: Text(
                _numAnim.value.round().toString(),
                style: numberStyle,
              ),
            ),
          );
        },
      ),
    );

    if (!_animateWhenVisible) {
      return gaugeContent;
    }

    return VisibilityDetector(
      key: Key('portfolio_increase_gauge_${identityHashCode(this)}'),
      onVisibilityChanged: (VisibilityInfo info) {
        if (_hasTriggeredOnVisible) return;
        if (info.visibleFraction >= 0.3) {
          _hasTriggeredOnVisible = true;
          _startAnimation();
        }
      },
      child: gaugeContent,
    );
  }
}

/// Same arc style as PortfolioGauge: gradient along arc, 0..1 = pct filled.
class _IncreaseRingPainter extends CustomPainter {
  _IncreaseRingPainter({
    required this.pct,
    required this.radius,
    required this.stroke,
    required this.sweepRadians,
    required this.startAngle,
    required this.yellowAt,
  });

  final double pct;
  final double radius;
  final double stroke;
  final double sweepRadians;
  final double startAngle;
  final double yellowAt;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..color = const Color(0xFFE8E8E8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, sweepRadians, false, track);

    const red = Color(0xFFE53935);
    const yellow = Color(0xFFFFB300);
    const green = Color(0xFF43A047);

    const double eps = 0.002;
    final full = 2 * math.pi;
    final ratio = sweepRadians / full;
    final y = yellowAt * ratio;

    final shader = SweepGradient(
      transform: GradientRotation(startAngle),
      colors: const [red, red, yellow, green],
      stops: <double>[0.0, eps, y, ratio],
      tileMode: TileMode.clamp,
    ).createShader(rect);

    final progress = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final progressSweep = sweepRadians * pct;
    canvas.drawArc(rect, startAngle, progressSweep, false, progress);

    if (pct > 0) {
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
  }

  @override
  bool shouldRepaint(covariant _IncreaseRingPainter old) =>
      pct != old.pct ||
      radius != old.radius ||
      stroke != old.stroke ||
      sweepRadians != old.sweepRadians ||
      startAngle != old.startAngle ||
      yellowAt != old.yellowAt;
}
