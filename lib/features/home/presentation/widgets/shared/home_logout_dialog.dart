// lib/features/home/presentation/widgets/shared/home_logout_dialog.dart
//
// Dialog de déconnexion partagé par les 3 rôles.
// Appelé via showLogoutDialog(context, onConfirm: ...).
// Style dark cohérent avec la home (grey900 + rouge).
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

/// Affiche le dialog de confirmation de déconnexion.
///
/// [onConfirm] est appelé si l'utilisateur appuie sur "Se déconnecter".
Future<void> showLogoutDialog(
    BuildContext context, {
      required VoidCallback onConfirm,
    }) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.60),
    builder: (ctx) => _LogoutDialog(onConfirm: onConfirm),
  );
}

// ── Widget dialog interne ─────────────────────────────────────────────────────

class _LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const _LogoutDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ISPMColors.grey900,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Icône + titre ────────────────────────────────────
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ISPMColors.error.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ISPMColors.error.withOpacity(0.28),
                    ),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    size: 18,
                    color: ISPMColors.error,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Déconnexion',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: ISPMColors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Message ──────────────────────────────────────────
            Text(
              'Voulez-vous vraiment vous déconnecter de votre compte ?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: ISPMColors.white.withOpacity(0.55),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            // ── Divider ──────────────────────────────────────────
            Divider(
              color: ISPMColors.white.withOpacity(0.07),
              thickness: 0.5,
              height: 0,
            ),

            const SizedBox(height: 16),

            // ── Boutons ──────────────────────────────────────────
            Row(
              children: [
                // Annuler
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: ISPMColors.white.withOpacity(0.55),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: ISPMColors.white.withOpacity(0.12),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Annuler',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Confirmer
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ISPMColors.error,
                      foregroundColor: ISPMColors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Se déconnecter'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}