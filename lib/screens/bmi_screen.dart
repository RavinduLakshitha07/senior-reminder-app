import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bmi_record.dart';
import '../providers/bmi_provider.dart';
import '../utils/app_sizes.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> with TickerProviderStateMixin {
  late AnimationController _needleController;
  late Animation<double> _needleAnimation;

  @override
  void initState() {
    super.initState();
    _needleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _needleAnimation = CurvedAnimation(
      parent: _needleController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _needleController.dispose();
    super.dispose();
  }

  void _animateNeedle() {
    _needleController.forward(from: 0);
  }

  String _trendIcon(double current, double? previous) {
    if (previous == null) return '—';
    if (current > previous) return '↑';
    if (current < previous) return '↓';
    return '→';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'BMI Calculator',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
body: Consumer<BmiProvider>(
        builder: (context, bmi, _) {
          final sizes = AppSizes(context);
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _UnitToggle(
                  unitSystem: bmi.unitSystem,
                  onChanged: (unit) => bmi.setUnitSystem(unit),
                ),
                SizedBox(height: sizes.mediumSpace),
                _GenderSelector(
                  gender: bmi.gender,
                  onChanged: (g) => bmi.setGender(g),
                ),
                SizedBox(height: sizes.largeSpace),
                _SliderCard(
                  icon: Icons.cake_rounded,
                  label: 'Age',
                  value: bmi.age,
                  displayValue: bmi.age.round().toString(),
                  min: 25,
                  max: 100,
                  divisions: 75,
                  activeColor: const Color(0xFF1976D2),
                  onChanged: (v) => bmi.setAge(v),
                ),
                const SizedBox(height: 14),
                _SliderCard(
                  icon: Icons.straighten_rounded,
                  label: 'Height',
                  value: bmi.displayHeight,
                  displayValue: bmi.heightLabel,
                  min: bmi.unitSystem == UnitSystem.metric ? 140 : 55,
                  max: bmi.unitSystem == UnitSystem.metric ? 200 : 79,
                  divisions: bmi.unitSystem == UnitSystem.metric ? 60 : 24,
                  activeColor: const Color(0xFF2E7D32),
                  onChanged: (v) => bmi.setHeight(v),
                ),
                const SizedBox(height: 14),
                _SliderCard(
                  icon: Icons.monitor_weight_rounded,
                  label: 'Weight',
                  value: bmi.displayWeight,
                  displayValue: bmi.weightLabel,
                  min: bmi.unitSystem == UnitSystem.metric ? 40 : 88,
                  max: bmi.unitSystem == UnitSystem.metric ? 150 : 330,
                  divisions: bmi.unitSystem == UnitSystem.metric ? 110 : 242,
                  activeColor: const Color(0xFFFB8C00),
                  onChanged: (v) => bmi.setWeight(v),
                ),
                const SizedBox(height: 24),
                _BmiGauge(
                  bmi: bmi.currentBmi,
                  category: bmi.currentCategory,
                  animation: _needleAnimation,
                ),
                const SizedBox(height: 16),
SizedBox(
                  width: double.infinity,
                  height: sizes.buttonHeight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      bmi.calculateBmi();
                      _animateNeedle();
                    },
                    icon: Icon(Icons.calculate_rounded, size: sizes.smallIcon),
                    label: Text(
                      'Calculate BMI',
                      style: TextStyle(
                        fontSize: sizes.body,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(sizes.radius * 0.8),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: sizes.smallSpace),
                SizedBox(
                  width: double.infinity,
                  height: sizes.buttonHeight,
                  child: OutlinedButton.icon(
                    onPressed: bmi.currentBmi == null
                        ? null
                        : () async {
                            await bmi.saveReading();
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('BMI reading saved!'),
                                backgroundColor: const Color(0xFF2E7D32),
                                action: SnackBarAction(
                                  label: 'View Reports',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const _BmiReportsScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                    icon: Icon(Icons.save_rounded, size: sizes.smallIcon),
                    label: Text(
                      'Save Reading',
                      style: TextStyle(
                        fontSize: sizes.body,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2E7D32),
                      side: const BorderSide(
                        color: Color(0xFF2E7D32),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(sizes.radius * 0.8),
                      ),
                    ),
                  ),
                ),
                if (bmi.currentBmi != null && bmi.currentCategory != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: _ResultCard(
                      bmi: bmi.currentBmi!,
                      category: bmi.currentCategory!,
                    ),
                  ),
                if (bmi.currentCategory != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: _HealthTipCard(category: bmi.currentCategory!),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: _BmiScaleReference(
                    currentCategory: bmi.currentCategory,
                  ),
                ),
                if (bmi.recentReadings.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: _RecentReadings(
                      readings: bmi.recentReadings,
                      trendIcon: _trendIcon,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BmiReportsScreen extends StatelessWidget {
  const _BmiReportsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'BMI Reports',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: Consumer<BmiProvider>(
        builder: (context, bmi, _) {
          if (bmi.history.isEmpty) {
            return const Center(
              child: Text(
                'No BMI readings yet.\nCalculate and save your first reading!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF94A3B8),
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            children: [
              const Text(
                'Your BMI History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              ...bmi.history.reversed.map((record) {
                final color = Color(record.category.colorValue);
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            record.bmi.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BMI ${record.bmi.toStringAsFixed(1)} - ${record.category.label}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${record.weight.round()}kg · ${record.height.round()}cm · Age ${record.age}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _formatDateShort(record.dateTime),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  String _formatDateShort(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }
}

class _UnitToggle extends StatelessWidget {
  final UnitSystem unitSystem;
  final ValueChanged<UnitSystem> onChanged;

  const _UnitToggle({
    required this.unitSystem,
    required this.onChanged,
  });

@override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(sizes.radius * 0.7),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(UnitSystem.metric),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: unitSystem == UnitSystem.metric
                      ? const Color(0xFF2E7D32)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.monitor_weight_rounded,
                      size: sizes.smallIcon,
                      color: unitSystem == UnitSystem.metric
                          ? Colors.white
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Metric',
                      style: TextStyle(
                        fontSize: sizes.body,
                        fontWeight: FontWeight.w600,
                        color: unitSystem == UnitSystem.metric
                            ? Colors.white
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(UnitSystem.imperial),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: unitSystem == UnitSystem.imperial
                      ? const Color(0xFF2E7D32)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.monitor_weight_rounded,
                      size: sizes.smallIcon,
                      color: unitSystem == UnitSystem.imperial
                          ? Colors.white
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Imperial',
                      style: TextStyle(
                        fontSize: sizes.body,
                        fontWeight: FontWeight.w600,
                        color: unitSystem == UnitSystem.imperial
                            ? Colors.white
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String gender;
  final ValueChanged<String> onChanged;

  const _GenderSelector({
    required this.gender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _GenderChip(
            emoji: '👨',
            label: 'Male',
            isSelected: gender == 'male',
            onTap: () => onChanged('male'),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _GenderChip(
            emoji: '👩',
            label: 'Female',
            isSelected: gender == 'female',
            onTap: () => onChanged('female'),
          ),
        ),
      ],
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderChip({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

@override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: sizes.mediumSpace),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(sizes.radius * 0.8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2E7D32)
                : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: TextStyle(fontSize: sizes.largeIcon)),
            SizedBox(height: sizes.smallSpace),
            Text(
              label,
              style: TextStyle(
                fontSize: sizes.body,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliderCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final String displayValue;
  final double min;
  final double max;
  final int divisions;
  final Color activeColor;
  final ValueChanged<double> onChanged;

  const _SliderCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.displayValue,
    required this.min,
    required this.max,
    required this.divisions,
    required this.activeColor,
    required this.onChanged,
  });

@override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(sizes.radius * 0.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: activeColor, size: sizes.smallIcon),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: sizes.body,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF475569),
                ),
              ),
              const Spacer(),
              Text(
                displayValue,
                style: TextStyle(
                  fontSize: sizes.heading,
                  fontWeight: FontWeight.bold,
                  color: activeColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: activeColor,
              inactiveTrackColor: activeColor.withValues(alpha: 0.15),
              thumbColor: activeColor,
              overlayColor: activeColor.withValues(alpha: 0.1),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 22),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _BmiGauge extends StatelessWidget {
  final double? bmi;
  final BmiCategory? category;
  final Animation<double> animation;

  const _BmiGauge({
    required this.bmi,
    required this.category,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: CustomPaint(
          painter: _BmiGaugePainter(
            bmi: bmi ?? 0,
            animationValue: animation.value,
          ),
          child: Center(
            child: bmi != null && category != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        bmi!.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color(category!.colorValue).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${category!.emoji} ${category!.label}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(category!.colorValue),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Text(
                    'Adjust sliders\n& tap Calculate',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _BmiGaugePainter extends CustomPainter {
  final double bmi;
  final double animationValue;

  _BmiGaugePainter({
    required this.bmi,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.85);
    final radius = size.width * 0.42;
    const startAngle = math.pi;
    const sweepAngle = math.pi;

    final bgPaint = Paint()
      ..color = const Color(0xFFE8E8E8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    final segments = [
      _ArcSegment(
        startFraction: 0,
        endFraction: 0.37,
        color: const Color(0xFF1976D2),
        label: 'Underweight',
      ),
      _ArcSegment(
        startFraction: 0.37,
        endFraction: 0.50,
        color: const Color(0xFF2E7D32),
        label: 'Normal',
      ),
      _ArcSegment(
        startFraction: 0.50,
        endFraction: 0.60,
        color: const Color(0xFFFB8C00),
        label: 'Overweight',
      ),
      _ArcSegment(
        startFraction: 0.60,
        endFraction: 1.0,
        color: const Color(0xFFD32F2F),
        label: 'Obese',
      ),
    ];

    for (final seg in segments) {
      final segPaint = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round;

      final segStart = startAngle + sweepAngle * seg.startFraction;
      final segSweep = sweepAngle * (seg.endFraction - seg.startFraction);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        segStart,
        segSweep,
        false,
        segPaint,
      );
    }

    if (bmi > 0) {
      final bmiFraction = (bmi.clamp(10, 40) - 10) / 30;
      final needleAngle = startAngle + sweepAngle * (bmiFraction * animationValue);
      final needleLength = radius - 10;

      final needleEnd = Offset(
        center.dx + math.cos(needleAngle) * needleLength,
        center.dy + math.sin(needleAngle) * needleLength,
      );

      final needlePaint = Paint()
        ..color = const Color(0xFF212121)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(center, needleEnd, needlePaint);

      canvas.drawCircle(
        center,
        8,
        Paint()..color = const Color(0xFF212121),
      );
      canvas.drawCircle(
        center,
        4,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BmiGaugePainter old) =>
      old.bmi != bmi || old.animationValue != animationValue;
}

class _ArcSegment {
  final double startFraction;
  final double endFraction;
  final Color color;
  final String label;

  _ArcSegment({
    required this.startFraction,
    required this.endFraction,
    required this.color,
    required this.label,
  });
}

class _ResultCard extends StatelessWidget {
  final double bmi;
  final BmiCategory category;

  const _ResultCard({
    required this.bmi,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(category.colorValue);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                category.emoji,
                style: const TextStyle(fontSize: 34),
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bmi.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    category.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.monitor_heart_rounded, color: color, size: 28),
          ),
        ],
      ),
    );
  }
}

class _HealthTipCard extends StatelessWidget {
  final BmiCategory category;

  const _HealthTipCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final color = Color(category.colorValue);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded, color: color, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Health Tip',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  category.healthTip,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF475569),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BmiScaleReference extends StatelessWidget {
  final BmiCategory? currentCategory;

  const _BmiScaleReference({this.currentCategory});

  @override
  Widget build(BuildContext context) {
    final categories = [
      (cat: BmiCategory.underweight, range: '< 18.5'),
      (cat: BmiCategory.normal, range: '18.5 – 24.9'),
      (cat: BmiCategory.overweight, range: '25 – 29.9'),
      (cat: BmiCategory.obese, range: '≥ 30'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BMI Scale',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: categories.map((item) {
              final isActive = currentCategory == item.cat;
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0xFFF0F0F0),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Color(item.cat.colorValue).withValues(
                          alpha: isActive ? 1.0 : 0.2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.cat.label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w400,
                          color: isActive
                              ? const Color(0xFF212121)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    Text(
                      item.range,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive
                            ? Color(item.cat.colorValue)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _RecentReadings extends StatelessWidget {
  final List<BmiRecord> readings;
  final String Function(double current, double? previous) trendIcon;

  const _RecentReadings({
    required this.readings,
    required this.trendIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Readings',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: readings.asMap().entries.map((entry) {
              final index = entry.key;
              final record = entry.value;
              final prevBmi =
                  index < readings.length - 1 ? readings[index + 1].bmi : null;
              final trend = trendIcon(record.bmi, prevBmi);

              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(record.category.colorValue).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          record.bmi.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(record.category.colorValue),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      trend,
                      style: TextStyle(
                        fontSize: 16,
                        color: trend == '↑'
                            ? const Color(0xFFD32F2F)
                            : trend == '↓'
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(record.dateTime),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }
}
