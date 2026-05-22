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

/// Horizontal portfolio score bar.
///
/// Fills left → right; no centre number. Horizontal portfolio score bar.
/// Fills left → right; no centre number.
class PortfolioGauge extends StatefulWidget {
  const PortfolioGauge({
    super.key,
    this.width, // null = fill parent
    this.height, // bar thickness if strokeWidth not set
    this.score, // 0..maxScore
    this.maxScore, // default 999
    this.durationMs, // default 1400
    this.delayMs, // default 0
    this.strokeWidth, // bar thickness (preferred)
  });

  final double? width;
  final double? height;
  final int? score;
  final int? maxScore;
  final int? durationMs;
  final int? delayMs;
  final double? strokeWidth;

  @override
  State<PortfolioGauge> createState() => _PortfolioGaugeState();
}

class _PortfolioGaugeState extends State<PortfolioGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pctAnim;

  int get _max => (widget.maxScore ?? 999).clamp(1, 999999);
  int get _score => (widget.score ?? 0).clamp(0, _max);
  double get _targetPct => _score / _max;
  Duration get _duration => Duration(milliseconds: widget.durationMs ?? 1400);
  Duration get _delay => Duration(milliseconds: widget.delayMs ?? 0);

  double get _barHeight {
    if (widget.strokeWidth != null) return widget.strokeWidth!;
    return (widget.height ?? 12).clamp(6.0, 32.0);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _pctAnim = Tween<double>(begin: 0, end: _targetPct).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

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
      _pctAnim = Tween<double>(begin: _pctAnim.value, end: _targetPct).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
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
    final theme = FlutterFlowTheme.of(context);

    return SizedBox(
      width: widget.width,
      height: _barHeight,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return _ScoreBar(
            pct: _pctAnim.value.clamp(0.0, 1.0),
            barHeight: _barHeight,
            trackColor: theme.alternate,
            gradientColors: [theme.tertiary, theme.secondary],
          );
        },
      ),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  const _ScoreBar({
    required this.pct,
    required this.barHeight,
    required this.trackColor,
    required this.gradientColors,
  });

  final double pct;
  final double barHeight;
  final Color trackColor;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(barHeight / 2);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        if (w <= 0) return const SizedBox.shrink();

        return SizedBox(
          height: barHeight,
          width: w,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: barHeight,
                width: w,
                decoration: BoxDecoration(
                  color: trackColor,
                  borderRadius: radius,
                ),
              ),
              ClipRRect(
                borderRadius: radius,
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: pct,
                  child: Container(
                    height: barHeight,
                    width: w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: gradientColors,
                        stops: const [0.0, 1.0],
                      ),
                      borderRadius: radius,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
