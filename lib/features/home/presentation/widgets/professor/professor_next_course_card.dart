// lib/features/home/presentation/widgets/professor/professor_next_course_card.dart
//
// Carte PROCHAIN cours — exclusive Professeur.
// Affiche : titre · filière · horaire · countdown animé avant début.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../schedule/domain/entities/course.dart';

class ProfessorNextCourseCard extends StatelessWidget {
  final Course course;
  final String Function(DateTime) formatTime;

  /// Texte du countdown calculé par le parent (ex: "dans 24 min", "dans 1h 10min")
  final String countdown;

  const ProfessorNextCourseCard({
    super.key,
    required this.course,
    required this.formatTime,
    required this.countdown,
  });

  /// Urgence : < 15 min → orange, < 5 min → rouge, sinon vert
  _CountdownUrgency get _urgency {
    final diff = course.startTime.difference(DateTime.now());
    if (diff.inMinutes < 5) return _CountdownUrgency.critical;
    if (diff.inMinutes < 15) return _CountdownUrgency.warning;
    return _CountdownUrgency.normal;
  }

  @override
  Widget build(BuildContext context) {
    final urgency = _urgency;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ISPMColors.grey900,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: urgency.borderColor,
          width: urgency == _CountdownUrgency.normal ? 1.0 : 1.5,
        ),
        boxShadow: urgency != _CountdownUrgency.normal
            ? [
          BoxShadow(
            color: urgency.accentColor.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 32,
            decoration: BoxDecoration(
              color: ISPMColors.green,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(width: 11),

          // ── Infos cours ────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: ISPMColors.white,
                    letterSpacing: -0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    // 1️⃣  Filière : can shrink & ellipsis
                    Flexible(
                      child: Text(
                        course.fieldOfStudy,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: ISPMColors.white.withOpacity(0.38),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),

                    // Séparateur — taille fixe, pas de Flexible
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: ISPMColors.white.withOpacity(0.20),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    // 2️⃣  Horaire : Flexible pour les plages longues
                    Text(
                      '${formatTime(course.startTime)} – ${formatTime(course.endTime)}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: ISPMColors.white.withOpacity(0.38),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // ── Badge countdown animé ───────────────────────────────
          _CountdownBadge(countdown: countdown, urgency: urgency),
        ],
      ),
    );
  }
}

// ── Urgence countdown ─────────────────────────────────────────────────────────

enum _CountdownUrgency { normal, warning, critical }

extension _CountdownUrgencyX on _CountdownUrgency {
  Color get accentColor => switch (this) {
    _CountdownUrgency.normal => ISPMColors.green,
    _CountdownUrgency.warning => const Color(0xFFF57C00),
    _CountdownUrgency.critical => ISPMColors.error,
  };

  Color get borderColor => switch (this) {
    _CountdownUrgency.normal => ISPMColors.white.withOpacity(0.06),
    _CountdownUrgency.warning =>
        const Color(0xFFF57C00).withOpacity(0.40),
    _CountdownUrgency.critical => ISPMColors.error.withOpacity(0.40),
  };

  IconData get icon => switch (this) {
    _CountdownUrgency.normal => Icons.schedule_rounded,
    _CountdownUrgency.warning => Icons.timer_outlined,
    _CountdownUrgency.critical => Icons.timer_off_outlined,
  };
}

// ── Badge countdown ───────────────────────────────────────────────────────────

class _CountdownBadge extends StatefulWidget {
  final String countdown;
  final _CountdownUrgency urgency;

  const _CountdownBadge({required this.countdown, required this.urgency});

  @override
  State<_CountdownBadge> createState() => _CountdownBadgeState();
}

class _CountdownBadgeState extends State<_CountdownBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );

    // Pulse uniquement si urgence critique ou warning
    if (widget.urgency != _CountdownUrgency.normal) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_CountdownBadge old) {
    super.didUpdateWidget(old);
    if (widget.urgency != old.urgency) {
      if (widget.urgency != _CountdownUrgency.normal) {
        _pulse.repeat(reverse: true);
      } else {
        _pulse.stop();
        _pulse.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.urgency.accentColor;

    return ScaleTransition(
      scale: _scaleAnim,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.urgency.icon, size: 14, color: color),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                widget.countdown,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: -0.2,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}