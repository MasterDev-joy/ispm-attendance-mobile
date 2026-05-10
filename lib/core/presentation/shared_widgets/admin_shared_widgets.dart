// lib/features/admin/shared_widgets/admin_shared_widgets.dart
//
// Widgets partagés entre reports_page, users_page et courses_page.
// ✅ Extraits de users_page.dart pour éviter la duplication.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

const _kAmber = Color(0xFFBA7517);

// ── AppBar admin ──────────────────────────────────────────────────────────────

class AdminAppBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final Widget? action;

  const AdminAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
    this.action,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            GestureDetector(
              onTap: onBack,
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: ISPMColors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ISPMColors.white.withOpacity(0.09)),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 15, color: ISPMColors.white),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.w700, color: ISPMColors.white)),
                  Text(subtitle,
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: ISPMColors.white.withOpacity(0.38))),
                ],
              ),
            ),
            if (action != null) action!,
          ],
        ),
      );
}

// ── Bouton d'action (add, etc.) ───────────────────────────────────────────────

class ActionBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const ActionBtn({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: _kAmber.withOpacity(0.13),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _kAmber.withOpacity(0.35)),
          ),
          child: Icon(icon, size: 18, color: _kAmber),
        ),
      );
}

// ── Panel d'erreur ────────────────────────────────────────────────────────────

class AdminErrorPanel extends StatelessWidget {
  final String message;
  final Color accent;
  final VoidCallback onRetry;

  const AdminErrorPanel({
    super.key,
    required this.message,
    required this.accent,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 36, color: ISPMColors.error),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: ISPMColors.white.withOpacity(0.40))),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: accent.withOpacity(0.35)),
                ),
                child: Text('Réessayer',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: accent)),
              ),
            ),
          ],
        ),
      );
}

// ── Panel vide ────────────────────────────────────────────────────────────────

class AdminEmptyPanel extends StatelessWidget {
  final Color accent;
  const AdminEmptyPanel({super.key, required this.accent});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.10),
                shape: BoxShape.circle,
                border: Border.all(color: accent.withOpacity(0.25)),
              ),
              child: Icon(Icons.inbox_rounded, size: 28, color: accent),
            ),
            const SizedBox(height: 16),
            const Text('Aucun élément trouvé',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600, color: ISPMColors.white)),
          ],
        ),
      );
}
