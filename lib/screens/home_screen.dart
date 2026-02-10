import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/product_type.dart';
import '../models/session_history.dart';

String formatTime(int totalSeconds) {
  final h = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
  final m = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
  final s = (totalSeconds % 60).toString().padLeft(2, '0');
  return '$h:$m:$s';
}

double getProgress(int seconds, ProductType product) {
  return (seconds / (product.maxMinutes * 60)).clamp(0.0, 1.0);
}

Color getStatusColor(double progress) {
  if (progress < 0.5) return const Color(0xFF6FCF97);
  if (progress < 0.75) return const Color(0xFFF2C94C);
  if (progress < 0.9) return const Color(0xFFF2994A);
  return const Color(0xFFEB5757);
}

String getStatusMessage(double progress, bool running) {
  if (!running && progress == 0) return 'Ready when you are! 💁‍♀️';
  if (progress < 0.25) return 'Fresh & comfy ✨';
  if (progress < 0.5) return "Cruisin' along 😎";
  if (progress < 0.75) return 'Past the halfway mark ⏰';
  if (progress < 0.9) return 'Getting up there... 👀';
  return 'Time to change! 🚨';
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductType _selectedProduct = ProductType.tampon;
  int _seconds = 0;
  bool _running = false;
  Timer? _timer;
  final List<SessionHistory> _history = [];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handlePress() {
    if (_running) {
      _timer?.cancel();
      setState(() {
        _history.insert(
          0,
          SessionHistory(
            productId: _selectedProduct.id,
            durationSeconds: _seconds,
            timestamp: _formatTimestamp(DateTime.now()),
          ),
        );
        if (_history.length > 5) {
          _history.removeRange(5, _history.length);
        }
        _running = false;
        _seconds = 0;
      });
    } else {
      setState(() {
        _running = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          _seconds++;
        });
      });
    }
  }

  String _formatTimestamp(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final month = dt.month;
    final day = dt.day;
    return '$month/$day, $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final progress = getProgress(_seconds, _selectedProduct);
    final statusColor = getStatusColor(progress);
    final statusMessage = getStatusMessage(progress, _running);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    // Header
                    const Text(
                      'Tampon In? ⏱️',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFD6336C),
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Opacity(
                      opacity: 0.7,
                      child: Text(
                        'Track it. Change it. Feel great.',
                        style: TextStyle(
                          color: Color(0xFFC2255C),
                          fontSize: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Product Selector (horizontal scroll)
                    SizedBox(
                      height: 44,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        itemCount: ProductType.all.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final p = ProductType.all[index];
                          final isSelected = _selectedProduct.id == p.id;
                          return GestureDetector(
                            onTap: _running ? null : () {
                              setState(() {
                                _selectedProduct = p;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFD6336C)
                                      : const Color(0xFFF0D0DA),
                                  width: 2.5,
                                ),
                                color: isSelected
                                    ? const Color(0xFFFFE0E9)
                                    : Colors.white,
                              ),
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: _running && !isSelected ? 0.4 : 1.0,
                                child: Text(
                                  p.label,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: const Color(0xFFD6336C),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Timer Circle
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CustomPaint(
                        painter: _TimerCirclePainter(
                          progress: progress,
                          statusColor: statusColor,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                formatTime(_seconds),
                                style: const TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF333333),
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Recommended / Max info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _InfoChip(
                          label: 'Recommended',
                          value: _selectedProduct.recommendedLabel,
                          color: const Color(0xFF6FCF97),
                        ),
                        const SizedBox(width: 16),
                        _InfoChip(
                          label: 'Maximum',
                          value: _selectedProduct.maxLabel,
                          color: const Color(0xFFEB5757),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Status Message
                    SizedBox(
                      height: 24,
                      child: Text(
                        statusMessage,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFD6336C),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Big Start/Reset Button
                    _BigButton(
                      running: _running,
                      onPressed: _handlePress,
                    ),

                    // Recent History
                    if (_history.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Recent Changes',
                              style: TextStyle(
                                color: Color(0xFFD6336C),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...(_history.map((entry) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        entry.product.label,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF666666),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      entry.formattedDuration,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Opacity(
                                      opacity: 0.6,
                                      child: Text(
                                        entry.timestamp,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF666666),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Footer tip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE0E9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        '💡 Tip: Change times vary by product. Always follow your doctor\'s advice.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFC2255C),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Info Chip (recommended / max labels) ---

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF999999),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

// --- Circular Progress Painter ---

class _TimerCirclePainter extends CustomPainter {
  final double progress;
  final Color statusColor;

  _TimerCirclePainter({required this.progress, required this.statusColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 90.0;
    const strokeWidth = 12.0;

    final bgPaint = Paint()
      ..color = const Color(0xFFF0D0DA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    if (progress > 0) {
      final progressPaint = Paint()
        ..color = statusColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TimerCirclePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.statusColor != statusColor;
  }
}

// --- Big Start/Reset Button ---

class _BigButton extends StatefulWidget {
  final bool running;
  final VoidCallback onPressed;

  const _BigButton({required this.running, required this.onPressed});

  @override
  State<_BigButton> createState() => _BigButtonState();
}

class _BigButtonState extends State<_BigButton> {
  bool _pressing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressing = true),
      onTapUp: (_) {
        setState(() => _pressing = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressing = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 160,
        height: 160,
        transform: Matrix4.identity()..scale(_pressing ? 0.95 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.running
                ? [const Color(0xFFFF6B6B), const Color(0xFFEE5A24)]
                : [const Color(0xFF6FCF97), const Color(0xFF27AE60)],
          ),
          boxShadow: [
            BoxShadow(
              color: widget.running
                  ? const Color(0xFFEE5A24).withOpacity(0.4)
                  : const Color(0xFF6FCF97).withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.running ? '🔄' : '▶️',
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 4),
            Text(
              widget.running ? 'CHANGED!' : 'START',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
