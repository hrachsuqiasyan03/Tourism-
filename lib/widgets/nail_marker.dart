import 'package:flutter/material.dart';
import '../models/place.dart';

/// Marker representing a destination pinned on the map in authentic Google Maps styling.
class NailMarker extends StatelessWidget {
  final Place place;
  final bool isSelected;
  final bool isHighlighted;
  final VoidCallback onTap;

  const NailMarker({
    super.key,
    required this.place,
    required this.isSelected,
    this.isHighlighted = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isSelected || isHighlighted) {
      // Prominent Google Maps Red Pin & Nail Marker for destinations selected by the user
      return GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 100,
          height: 64,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              // Pin needle ground shadow
              Positioned(
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),

              // The Google Maps Red Pin & Nail body
              Positioned(
                bottom: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Floating Google Place Name & Rating Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isHighlighted
                            ? const Color(0xFFD93025) // Google Dark Red
                            : const Color(0xFF202124), // Google Dark Slate
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: isHighlighted
                              ? const Color(0xFFFBBC04) // Google Gold
                              : Colors.white,
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              place.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 3),
                          const Icon(Icons.star, color: Color(0xFFFBBC04), size: 10),
                          Text(
                            ' ${place.rating}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 2),

                    // Google Maps Red Pin Icon Graphic with Nail Pin Head
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFEA4335), // Google Maps Red
                            Color(0xFFC5221F), // Dark Google Red
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD93025).withValues(alpha: 0.6),
                            blurRadius: 6,
                            spreadRadius: 1,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.push_pin,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),

                    // Needle tip pointing to the exact coordinate
                    CustomPaint(
                      size: const Size(6, 7),
                      painter: _PinTipPainter(
                        color: const Color(0xFFC5221F),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Standard Google Maps POI dot/pin for destinations on the map
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: '${place.name} (${place.city})',
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFEA4335), // Google Maps POI Red
            border: Border.all(color: Colors.white, width: 1.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.location_on,
              color: Colors.white,
              size: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _PinTipPainter extends CustomPainter {
  final Color color;

  _PinTipPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Person / User Location Marker showing current user position with animated beacon pulse.
class PersonLocationMarker extends StatefulWidget {
  final double latitude;
  final double longitude;
  final VoidCallback? onTap;

  const PersonLocationMarker({
    super.key,
    required this.latitude,
    required this.longitude,
    this.onTap,
  });

  @override
  State<PersonLocationMarker> createState() => _PersonLocationMarkerState();
}

class _PersonLocationMarkerState extends State<PersonLocationMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Pulse halo
                Container(
                  width: 32 + (40 * _pulseAnimation.value),
                  height: 32 + (40 * _pulseAnimation.value),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent.withValues(
                      alpha: 0.4 * (1.0 - _pulseAnimation.value),
                    ),
                  ),
                ),

                // Inner radar circle
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade600.withValues(alpha: 0.25),
                  ),
                ),

                // Person Avatar / Pin Center
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2563EB), // Vibrant Royal Blue
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),

                // Small "You" label tag on top
                Positioned(
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: const Text(
                      'You',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
